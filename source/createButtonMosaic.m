function result = createButtonMosaic(circles, result)
    result = im2double(result);
    
    button_history = 10;
    previous_filenames = repmat("", 1, button_history);
    current_idx = 1;
    
    pairs = containers.Map;
    
    f = waitbar(0, 'Finding and inserting matching buttons');
    
    for i = 1:length(circles)
        button_filenames = findMatchingButtons(circles(i), 10, 5);
        
        button_filename = button_filenames(1);
        for j = 1:length(button_filenames)
            idx = find(previous_filenames == button_filenames(j), 1, 'first');
            if isempty(idx)
                button_filename = button_filenames(j);
                break;
            end
        end
        
        previous_filenames(current_idx) = button_filename;
        current_idx = 1 + mod(current_idx, 10);
        
        if ~isKey(pairs, button_filename)
            button = struct;
            [button.image, ~, button.alpha] = imread(strcat('..\buttons\', button_filename));
            button.image = im2double(button.image);
            button.alpha = im2double(button.alpha);
            pairs(button_filename) = button;
        else
            button = pairs(button_filename);
        end
        
        s_idx = circles(i).position - circles(i).radius;
        e_idx = circles(i).position + circles(i).radius;
    
        x_range = s_idx(2):e_idx(2);
        y_range = s_idx(1):e_idx(1);
        
        region = result(x_range, y_range, :);
        
        angle = rand() * 360;
        button.image = imrotate(button.image, angle, 'crop', 'bicubic');
        button.alpha = imrotate(button.alpha, angle, 'crop', 'bicubic');
        
        dims = size(region, 1:2);
        
        button.image = imresize(button.image, dims, 'bicubic');
        button.alpha = imresize(button.alpha, dims, 'bicubic');
        
        region = applyAlpha(button.image, button.alpha, region);
        
        result(x_range, y_range, :) = region;
        
        waitbar(i / length(circles), f, 'Finding and inserting matching buttons');
    end
    close(f)
end

function result = applyAlpha(image, alpha, result)
    for i = 1:3
        result(:,:,i) = result(:,:,i) .* (1-alpha) + image(:,:,i) .* alpha;
    end
end

