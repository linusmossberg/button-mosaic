function label_image = segmentImage(image, settings)

    lab_image = rgb2lab(smoothColor(image, settings.smooth_est_scale));
    colors_lab = reshape(lab_image, [], 3);
    
    rng(1);
    
    [label_vec, ~] = kmeans(colors_lab, settings.num_colors, ...
                            'MaxIter', 10000, ...
                            'Options', statset('UseParallel',1), ...
                            'Replicates', 5);
                        
    label_image = reshape(label_vec, size(image, 1:2));

    for i = 1:max(label_image(:))
        mask = label_image == i;

        mask = bwareaopen(~mask, settings.label_min_area);
        mask = bwareaopen(~mask, settings.label_min_area);
        mask = imclose(mask, strel('disk', settings.label_close_radius));
        mask = bwareaopen(~mask, settings.label_min_area);
        mask = bwareaopen(~mask, settings.label_min_area);
        
        label_image(mask) = i; 
    end

    label_image = conCompSplitLabel(label_image, 'descend');

    label_image = smoothLabels(label_image, floor(settings.min_radius));

    label_image = conCompSplitLabel(label_image, 'ascend');
end

