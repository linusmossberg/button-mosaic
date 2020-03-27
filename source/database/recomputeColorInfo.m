function recomputeColorInfo()
    f = waitbar(0, 'Recomputing color info');
    buttons = load('../buttons/buttons.mat');
    for i = 1:length(buttons.data)
        entry = buttons.data(i);
        [image, ~, alpha] = imread(sprintf('../buttons/%s', entry.filename));
        mask = alpha > 128;
        image_lab = rgb2lab(im2double(image));
        
        entry.dominant_colors = kDominantColors(image_lab, mask, 3, Inf, 5);

        colors_lab = reshape(image_lab, [], 3);
        colors_lab = colors_lab(mask(:), :);
        entry.mean_color_lab = mean(colors_lab);
        
        buttons.data(i) = entry;
        
        waitbar(i / length(buttons.data), f, 'Recomputing color info');
    end
    data = buttons.data;
    save('../buttons/buttons.mat', 'data');
    close(f)
end

