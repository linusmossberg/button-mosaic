% S requires the fields:
% button_history, similarity_threshold, min_dominant_radius, 
% unique_button_limit, scale, AA

function [mosaic, corrected] = createButtonMosaic(circles, image, S)

    search_settings.num_matches = S.button_history;
    search_settings.similarity_threshold = S.similarity_threshold;
    search_settings.min_dominant_radius = S.min_dominant_radius;
    search_settings.use_subset = S.unique_button_limit >= 1 && S.unique_button_limit <= 256;
    
    clear findMatchingButtons;
    if(search_settings.use_subset)
        createLimitedDatabase(image, S.unique_button_limit);
    end
    
    if nargin < 3 || ~isPowerOfTwo(S.scale)
        S.scale = 1;
    end

    if nargin < 4 || ~isPowerOfTwo(S.AA)
        S.AA = 1;
    end
    
    dims = size(image, 1:2);
    mosaic = zeros([dims * S.AA * S.scale, 3]);
    
    produce_corrected = nargout > 1;
    
    if produce_corrected
        % Mosaic with luma and chroma corrected buttons
        corrected = mosaic;
    end
    
    previous_filenames = repmat("", 1, S.button_history);
    current_idx = 1;
    
    pairs = containers.Map;
    
    f = waitbar(0, 'Finding and compositing matching buttons');
    
    for i = 1:length(circles)
        [button_filenames, mean_colors_lab] = findMatchingButtons(circles(i), search_settings);
        
        button_filename = button_filenames(1);
        mean_color_lab = mean_colors_lab(1, :);
        [~,best_idx] = setdiff(button_filenames, previous_filenames, 'stable');
        
        if ~isempty(best_idx)
            button_filename = button_filenames(best_idx(1));
            mean_color_lab = mean_colors_lab(best_idx(1), :);
        end
        
        previous_filenames(current_idx) = button_filename;
        current_idx = 1 + mod(current_idx, S.button_history);
        
        if ~isKey(pairs, button_filename)
            button = struct;
            [button.image, ~, button.alpha] = imread(strcat('..\buttons\', button_filename));
            pairs(button_filename) = button;
        else
            button = pairs(button_filename);
        end
        
        button.image = im2double(button.image);
        button.alpha = im2double(button.alpha);
        
        s_idx = (circles(i).position - circles(i).radius) * S.scale * S.AA;
        e_idx = (circles(i).position + circles(i).radius) * S.scale * S.AA;
    
        x_range = s_idx(2):e_idx(2);
        y_range = s_idx(1):e_idx(1);
        
        angle = rand() * 360;
        button.image = imrotate(button.image, angle, 'crop', 'bicubic');
        button.alpha = imrotate(button.alpha, angle, 'crop', 'bicubic');
        
        dims = [length(x_range), length(y_range)];
        
        button.image = imresize(button.image, dims, 'bicubic');
        button.alpha = imresize(button.alpha, dims, 'bicubic');
        
        mosaic(x_range, y_range, :) = applyAlpha(button.image, button.alpha, mosaic(x_range, y_range, :));
        
        if produce_corrected
            Lab_offset = circles(i).mean_color_lab - mean_color_lab;
            corrected(x_range, y_range, :) = applyAlpha(CC(button.image, Lab_offset), button.alpha, corrected(x_range, y_range, :));
        end
        
        waitbar(i / length(circles), f, 'Finding and compositing matching buttons');
    end
    
    mosaic = imresize(mosaic, 1/S.AA, 'bicubic');
    if produce_corrected
        corrected = imresize(corrected, 1/S.AA, 'bicubic');
    end
    
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