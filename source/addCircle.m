function [L, circles] = addCircle(image, circles, centroid, radius, L)

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
    colors = reshape(rgb_region, [], 3);
    colors = colors(circle(:), :);
    
    new_circle.dominant_colors = kDominantColors(double(colors), 3, 10000, 3);
    new_circle.radius = radius;
    new_circle.position = centroid;
    new_circle.mean_color_lab = mean(rgb2lab(colors));
    
    circles = [circles new_circle];
end

