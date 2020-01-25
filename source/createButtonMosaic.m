function result = createButtonMosaic(circles, result)
    result = im2double(result);
    
    button_history = 10;
    previous_filenames = repmat("", 1, button_history);
    current_idx = 1; 
    
    f = waitbar(0, 'Finding and inserting matching buttons');
    
    for i = 1:length(circles)
        button_filenames = findMatchingButtons(circles(i).dominant_colors, 10, 5);
        
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
        
        [image, ~, alpha] = imread(strcat('..\buttons\', button_filename));
        
        dim = 2 * circles(i).radius;
        dims = [dim dim];
        rect = floor([circles(i).position - (dims / 2) dims]);
        
        region = imcrop(result, rect);
        
        dims = size(region, 1:2);
        
        angle = rand() * 360;
        image = imrotate(image, angle, 'crop', 'bicubic');
        %alpha = imrotate(alpha, angle, 'crop', 'bicubic');
        
        image = im2double(imresize(image, dims));
        alpha = im2double(imresize(alpha, dims));
        
        region = applyAlpha(image, alpha, region);
        
        result(rect(2):rect(2)+rect(4), rect(1):rect(1)+rect(3), :) = region;
        
        waitbar(i / length(circles), f, 'Finding and inserting matching buttons');
    end
    close(f)
end

function result = applyAlpha(image, alpha, result)
    for i = 1:3
        result(:,:,i) = result(:,:,i) .* (1-alpha) + image(:,:,i) .* alpha;
    end
end

