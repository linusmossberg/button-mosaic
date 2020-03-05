function label_image = segmentImage(image, S)

    lab_image = rgb2lab(smoothColor(image, S.smooth_est_scale));
    colors_lab = reshape(lab_image, [], 3);
    
    rng(1);
    
    [label_vec, ~] = kmeans(colors_lab, S.num_colors, ...
                            'MaxIter', 10000, ...
                            'Options', statset('UseParallel',1), ...
                            'Replicates', 5);
                        
    label_image = reshape(label_vec, size(image, 1:2));

    for i = 1:max(label_image(:))
        mask = label_image == i;

        mask = bwareaopen(~mask, S.label_min_area);
        mask = bwareaopen(~mask, S.label_min_area);
        mask = imclose(mask, strel('disk', S.label_close_radius));
        mask = bwareaopen(~mask, S.label_min_area);
        mask = bwareaopen(~mask, S.label_min_area);
        
        label_image(mask) = i; 
    end

    label_image = conCompSplitLabel(label_image, 'descend');

    label_image = smoothLabels(label_image, floor(S.min_radius));

    label_image = conCompSplitLabel(label_image, 'ascend');
end

