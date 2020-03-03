function result = createButtonMosaic(circles, dims, scale, AA)
    
    if nargin < 3 || ~isPowerOfTwo(scale)
        scale = 1;
    end

    if nargin < 4 || ~isPowerOfTwo(AA)
        AA = 1;
    end
    
    % The fourth dim contains:
    % 1: Uncorrected mosaic
    % 2: Mosaic with luma corrected buttons
    % 3: Mosaic with luma and chroma corrected buttons
    mosaic = zeros([dims * AA * scale, 3, 3]);
    
    button_history = 20;
    previous_filenames = repmat("", 1, button_history);
    current_idx = 1;
    
    pairs = containers.Map;
    
    f = waitbar(0, 'Finding and compositing matching objects');
    
    for i = 1:length(circles)
        [button_filenames, mean_colors_lab] = findMatchingButtons(circles(i), 20, 2.5);
        
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
        
        angle = rand() * 360;
        button.image = imrotate(button.image, angle, 'crop', 'bicubic');
        button.alpha = imrotate(button.alpha, angle, 'crop', 'bicubic');
        
        dims = [length(x_range), length(y_range)];
        
        button.image = imresize(button.image, dims, 'bicubic');
        button.alpha = imresize(button.alpha, dims, 'bicubic');
        
        Lab_offset = circles(i).mean_color_lab - mean_color_lab;
        L_offset = [Lab_offset(1), 0, 0];
        
        mosaic(x_range, y_range, :, 1) = applyAlpha(button.image, button.alpha, mosaic(x_range, y_range, :, 1));
        mosaic(x_range, y_range, :, 2) = applyAlpha(CC(button.image, L_offset), button.alpha, mosaic(x_range, y_range, :, 2));
        mosaic(x_range, y_range, :, 3) = applyAlpha(CC(button.image, Lab_offset), button.alpha, mosaic(x_range, y_range, :, 3));
        
        waitbar(i / length(circles), f, 'Finding and compositing matching objects');
    end
    result(:,:,:,1) = imresize(mosaic(:,:,:,1), 1/AA, 'bicubic');
    result(:,:,:,2) = imresize(mosaic(:,:,:,2), 1/AA, 'bicubic');
    result(:,:,:,3) = imresize(mosaic(:,:,:,3), 1/AA, 'bicubic');
    close(f)
end

function result = CC(image, Lab_vector)
    result = lab2rgb(rgb2lab(image) + reshape(Lab_vector, 1, 1, 3));
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

