function label_image = segmentImage(image, settings)

    [label_image, ~] = imsegkmeans(image, settings.num_colors);

    for i = 1:max(label_image(:))
        mask = label_image == i;

        d = 32;
        radius = 8;

        mask = bwareaopen(~mask,d*d);
        mask = bwareaopen(~mask,d*d);
        mask = imclose(mask, strel('disk', radius));
        mask = bwareaopen(~mask,d*d);
        mask = bwareaopen(~mask,d*d);
        
        label_image(mask) = i; 
    end

    label_image = conCompSplitLabel(label_image, 'descend');

    label_image = smoothLabels(label_image, floor(settings.min_radius));

    label_image = conCompSplitLabel(label_image, 'ascend');
end

