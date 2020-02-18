function circles = createPackedCircles(image, label_image, settings)
    num_regions = max(label_image(:));

    circles = [];

    f = waitbar(0, 'Creating circles');
    completed_area = 0;

    remaining = false(size(label_image));

    for i = 1:(num_regions + 1)

        if i <= num_regions
            mask = label_image == i;
            stats = regionprops(mask, 'BoundingBox', 'Area');

            completed_area = completed_area + stats.Area;

            BB = ceil(stats.BoundingBox);

            [h, w] = size(mask);

            BB(3) = clamp(BB(3) + 2, 1, w - BB(1) + 1);
            BB(4) = clamp(BB(4) + 2, 1, h - BB(2) + 1);
            BB(1) = clamp(BB(1) - 1, 1, w);
            BB(2) = clamp(BB(2) - 1, 1, h);

            small_mask = mask(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1);
            small_image = image(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1, :);
            offset = [BB(1) - 1, BB(2) - 1];
        else
            small_image = image;
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

            if radius > settings.radius_reduction_start
                radius_diff =  radius - radius_reduction_start;
                radius = radius ./ (1 + radius_diff/max_radius);
            end

            radius = floor(radius);

            [small_mask, circles] = createCircle(small_image, circles, centroid, radius, small_mask, offset);
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

        waitbar(completed_area / numel(label_image), f, 'Creating circles');
    end

    disp(strcat("Number of circles: ", num2str(length(circles))));

    close(f)
end

function [L, circles] = createCircle(image, circles, centroid, radius, L, offset)

    new_circle = struct;

    s_idx = centroid - radius;
    e_idx = centroid + radius;
    
    x_range = s_idx(2):e_idx(2);
    y_range = s_idx(1):e_idx(1);
    
    [Y, X] = meshgrid(y_range, x_range);
    circle = (X - centroid(2)).^2 + (Y - centroid(1)).^2 <= radius^2;
    
    region = L(x_range, y_range);
    region(circle) = false;
    L(x_range, y_range) = region;
    
    rgb_region = image(x_range, y_range, :);
    
    new_circle.dominant_colors = kDominantColors(rgb_region, circle, 3, 10000, 3);
    new_circle.radius = radius;
    new_circle.position = offset + centroid;
    
    colors = reshape(rgb_region, [], 3);
    colors = colors(circle(:), :);
    new_circle.mean_color_lab = mean(rgb2lab(colors));
    
    circles = [circles new_circle];
end

