function result = kDominantColors(image, mask, k, max_colors, replicates, should_plot)

    if nargin < 6
        should_plot = false;
    end
    
    num_colors = prod(size(image), 1:2);
    
    resize_scale = 1;
    if(num_colors > max_colors)
        resize_scale = sqrt(max_colors/num_colors);
    end
    
    mask = imresize(mask, resize_scale, 'nearest');
    
    % If there are less than k unique colors, then k-means will not work.
    % It does however become trivial to determine dominant colors in such
    % cases.
    
    color_samples = reshape(imresize(image, resize_scale, 'nearest'), [], 3);
    color_samples = color_samples(mask(:), :);
    unique_colors = uniquetol(color_samples, 1e-3, 'ByRows', true);
    num_unique_colors = size(unique_colors, 1);
    
    if(num_unique_colors <= k)
        result.dominance = zeros(1, k);
        result.colors_lab = zeros(k, 3);
        for i = 1:num_unique_colors
            c = unique_colors(i, :);
            result.dominance(i) = sum(sum(abs(color_samples - c), 2) <= 1e-3);
            result.colors_lab(i, :) = rgb2lab(c);
        end
        result.dominance = result.dominance / sum(result.dominance);
        
        [~,idx] = sort(result.dominance, 'descend');
        result.dominance = result.dominance(idx);
        result.colors_lab = result.colors_lab(idx, :);
    else
        interpolated_color_samples = reshape(imresize(image, resize_scale, 'bilinear'), [], 3);
        interpolated_color_samples = interpolated_color_samples(mask(:), :);
        
        colors_lab = rgb2lab(interpolated_color_samples);
        [L, dominant_colors] = kmeans(colors_lab, k, 'MaxIter', 10000, ...
                                      'Options', statset('UseParallel',1), ...
                                      'Replicates', replicates);

        values = histcounts(L, k);

        [~,idx] = sort(values, 'descend');
        values = values(idx);
        dominant_colors = dominant_colors(idx, :);

        result.colors_lab = dominant_colors;
        result.dominance = values / sum(values);
    end
    
    if should_plot
        pie(result.dominance);
        colormap(clamp(lab2rgb(result.colors_lab), 0, 1));
    end
end

