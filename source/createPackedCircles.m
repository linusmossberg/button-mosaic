function circles = createPackedCircles(lab_image, label_image, settings)

    num_regions = max(label_image(:));

    circles = [];
    
    f = waitbar(0, 'Creating packed circles');
    completed_area = 0;

    remaining = false(size(label_image));

    for i = 1:(num_regions + 1)

        if i <= num_regions
            mask = label_image == i;
            stats = regionprops(mask, 'BoundingBox', 'Area');

            completed_area = completed_area + stats.Area;

            if length(stats) ~= 1
                disp(length(stats))
            end

            BB = ceil(stats.BoundingBox);

            [h, w] = size(mask);

            BB(3) = clamp(BB(3) + 2, 1, w - BB(1) + 1);
            BB(4) = clamp(BB(4) + 2, 1, h - BB(2) + 1);
            BB(1) = clamp(BB(1) - 1, 1, w);
            BB(2) = clamp(BB(2) - 1, 1, h);

            small_mask = mask(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1);
            small_lab_image = lab_image(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1, :);
            offset = [BB(1) - 1, BB(2) - 1];
        else
            small_lab_image = lab_image;
            small_mask = remaining;
            offset = [0, 0];
        end

        while true

            % Remove the boundary pixels of the region in order to not include
            % these in the resulting radius.
            distance = bwdist(~(small_mask & ~bwmorph(small_mask,'remove')));

            [radius, ~] = max(distance(:));

            max_region = bwareafilt(distance >= radius - 1e-4, 1);
            [row, col] = ind2sub(size(small_mask), find(max_region));
            [~, idx] = min((row - mean(row)).^2 + (col - mean(col)).^2);
            centroid = [col(idx), row(idx)];

            if(radius < settings.min_radius)
                break;
            end

            if radius > settings.radius_reduction_cutoff
                radius_diff =  radius - radius_reduction_cutoff;
                radius = radius ./ (1 + radius_diff/max_radius);
            end

            radius = floor(radius);

            [small_mask, circles] = addCircle(small_lab_image, circles, centroid, radius, small_mask, offset);
        end

        if(i <= (num_regions - 1))
            small_label_image = label_image(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1);
            [small_label_image, small_mask] = distributeUnusable(small_mask, small_label_image, i, true);
            label_image(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1) = small_label_image;
        end

        if i <= num_regions
            mask(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1) = small_mask;
            remaining(mask) = true;
        else
            remaining = small_mask;
        end

        waitbar(completed_area / numel(label_image), f, 'Creating packed circles');
    end

    disp(strcat("Number of circles: ", num2str(length(circles))));

    close(f)
end

