function createDatabaseAnimation(start_index)
    
    % Has to be modified on screen sizes other than 1920x1080
    crop_square = [590, 73, 1398 - 590, 881 - 73];

    buttons = load('../buttons/buttons.mat');
    
    v = VideoWriter('database_animation4.mp4', 'MPEG-4');
    v.Quality = 100;
    v.FrameRate = 60;
    open(v);
    
    prev_button = buttons.data(start_index);
    prev_buttons(1) = prev_button;
    empty_button = prev_button;
    empty_button.filename = '';
    prev_buttons(2:64) = empty_button;
    
    buttons.data(start_index) = [];
    
    cform = makecform('xyz2xyl');
    
    fig = figure
    set(fig, 'Position', get(0, 'Screensize'));
    plotChromaticity(); hold on;axis square;
    plot([0.64,0.3,0.15,0.64],[0.33,0.6,0.06,0.33], '--', 'Color', [0.2, 0.2, 0.2])
    xlim(xlim - 0.07)
    ylim(ylim - 0.005)
    
    drawnow
    
    idx = 1;
    while ~isempty(buttons.data)
        closest_button_index = findClosestButton(prev_button);
        
        prev_button = buttons.data(closest_button_index);
        buttons.data(closest_button_index) = [];
        
%         idx = 1 + mod(idx, 64);
%         prev_buttons(idx) = prev_button;
        prev_buttons = [prev_button prev_buttons];
        prev_buttons(end) = [];
        
        for i = 1:length(prev_buttons)
            dc = prev_buttons(i).dominant_colors;
            for j = 1:length(dc.dominance)
                if(dc.dominance(j) > 0.1)
                    xyY = applycform(lab2xyz(dc.colors_lab(j, :)), cform);
                    plot(xyY(1), xyY(2), '.k');
                end
            end
        end
        drawnow
        F = getframe(fig).cdata;
        F = imcrop(F, crop_square);
        writeFrame(prev_buttons, F);
    end
    
    hold off;
    
    close(v);
    
    function closest_button_index = findClosestButton(prev_button)
        best_similarity = -Inf;
        for i = 1:length(buttons.data)
            similarity = dominantColorsSimilarity(prev_button.dominant_colors, buttons.data(i).dominant_colors, 30);

            if(similarity > best_similarity)
                best_similarity = similarity;
                closest_button_index = i;
            end
        end
    end

    function writeFrame(buttons, F)
        images = {};
        for i = 1:length(buttons)
            if(isempty(buttons(i).filename))
                images{1, i} = im2uint8(ones(128,128,3));
            else
                [b, ~, a] = imread(['../buttons/' buttons(i).filename]);
                b = imresize(im2double(b), [128, 128], 'bicubic');
                a = imresize(im2double(a), [128, 128], 'bicubic');
                images{1, i} = im2uint8(applyAlpha(b, a, ones(size(b))));
            end
        end
        
        writeVideo(v, imtile({imtile(images), F}));
    end
end

function result = applyAlpha(image, alpha, result)
    for i = 1:3
        result(:,:,i) = result(:,:,i) .* (1-alpha) + image(:,:,i) .* alpha;
    end
end

