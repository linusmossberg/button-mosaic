function result = kDominantColors(image_lab, mask, k, max_colors, replicates, should_plot)

    if nargin < 6
        should_plot = false;
    end
    
    num_colors = sum(mask(:));
    
    resize_scale = 1;
    if(num_colors > max_colors)
        resize_scale = sqrt(max_colors/num_colors);
    end
    
    mask = imresize(mask, resize_scale, 'nearest');
    
    % If there are less than k unique colors, then k-means will not work.
    % It does however become trivial to determine dominant colors in such
    % cases.
    
    colors_lab = reshape(imresize(image_lab, resize_scale, 'nearest'), [], 3);
    colors_lab = colors_lab(mask(:), :);
    unique_colors = uniquetol(colors_lab, 1e-3, 'ByRows', true);
    num_unique_colors = size(unique_colors, 1);
    
    if(num_unique_colors <= k)
        result.dominance = zeros(1, k);
        result.colors_lab = zeros(k, 3);
        for i = 1:num_unique_colors
            c = unique_colors(i, :);
            result.dominance(i) = sum(sum(abs(colors_lab - c), 2) <= 1e-3);
            result.colors_lab(i, :) = c;
        end
        result.dominance = result.dominance / sum(result.dominance);
        
        [~,idx] = sort(result.dominance, 'descend');
        result.dominance = result.dominance(idx);
        result.colors_lab = result.colors_lab(idx, :);
    else
        
        if resize_scale ~= 1
            image_lab = imresize(image_lab, resize_scale, 'bilinear');
        end
        
        colors_lab = reshape(image_lab, [], 3);
        colors_lab = colors_lab(mask(:), :);
        
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