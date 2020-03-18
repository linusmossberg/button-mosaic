function recomputeColorInfo()
    f = waitbar(0, 'Recomputing color info');
    buttons = load('../buttons/buttons.mat');
    for i = 1:length(buttons.data)
        entry = buttons.data(i);
        [image, ~, alpha] = imread(sprintf('../buttons/%s', entry.filename));
        mask = alpha > 128;
        image = im2double(image);
        
        entry.dominant_colors = kDominantColors(image, mask, 3, 100000, 5);

        colors = reshape(image, [], 3);
        colors = colors(mask(:), :);
        entry.mean_color_lab = mean(rgb2lab(colors));
        
        buttons.data(i) = entry;
        
        waitbar(i / length(buttons.data), f, 'Smoothing segmented region labels');
    end
    data = buttons.data;
    save('../buttons/buttons.mat', 'data');
end

