function result = createButtonMosaic(circles, result, scale, AA)
    
    if nargin < 3 || ~isPowerOfTwo(scale)
        scale = 1;
    end

    if nargin < 4 || ~isPowerOfTwo(AA)
        AA = 1;
    end
    
    result = im2double(result);
    
    result = imresize(result, scale * AA, 'nearest');
    
    button_history = 20;
    previous_filenames = repmat("", 1, button_history);
    current_idx = 1;
    
    pairs = containers.Map;
    
    f = waitbar(0, 'Finding and compositing matching objects');
    
    for i = 1:length(circles)
        [button_filenames, mean_colors_lab] = findMatchingButtons(circles(i), 20, 5);
        
        button_filename = button_filenames(1);
        mean_color_lab = mean_colors_lab(1, :);
        [~,best_idx] = setdiff(button_filenames, previous_filenames, 'stable');
        
        if ~isempty(best_idx)
            button_filename = button_filenames(best_idx(1));
            mean_color_lab = mean_colors_lab(best_idx(1), :);
        end
        
        previous_filenames(current_idx) = button_filename;
        current_idx = 1 + mod(current_idx, button_history);
        
        if ~isKey(pairs, button_filename)
            button = struct;
            [button.image, ~, button.alpha] = imread(strcat('..\buttons\', button_filename));
            button.image = im2double(button.image);
            button.alpha = im2double(button.alpha);
            pairs(button_filename) = button;
        else
            button = pairs(button_filename);
        end
        
        s_idx = (circles(i).position - circles(i).radius) * scale * AA;
        e_idx = (circles(i).position + circles(i).radius) * scale * AA;
    
        x_range = s_idx(2):e_idx(2);
        y_range = s_idx(1):e_idx(1);
        
        region = result(x_range, y_range, :);
        
        angle = rand() * 360;
        button.image = imrotate(button.image, angle, 'crop', 'bicubic');
        button.alpha = imrotate(button.alpha, angle, 'crop', 'bicubic');
        
        dims = size(region, 1:2);
        
        button.image = imresize(button.image, dims, 'bicubic');
        button.alpha = imresize(button.alpha, dims, 'bicubic');
        
        Lab_diff = circles(i).mean_color_lab - mean_color_lab; 
        button.image = lab2rgb(rgb2lab(button.image) + reshape(Lab_diff, 1, 1, 3));
        
        region = applyAlpha(button.image, button.alpha, region);
        
        result(x_range, y_range, :) = region;
        
        waitbar(i / length(circles), f, 'Finding and compositing matching objects');
    end
    result = imresize(result, 1/AA, 'bicubic');
    close(f)
end

function result = applyAlpha(image, alpha, result)
    for i = 1:3
        result(:,:,i) = result(:,:,i) .* (1-alpha) + image(:,:,i) .* alpha;
    end
end

function result = isPowerOfTwo(n) 
    if n == 0
        result = false;
    else
        result = (ceil(log2(n)) == floor(log2(n)));
    end
end

