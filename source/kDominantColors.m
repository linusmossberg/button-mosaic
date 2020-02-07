function result = kDominantColors(colors, k, max_colors, replicates, should_plot)

    if nargin < 5
        should_plot = false;
    end
    
    colors = reshape(colors, [], 3);
    
    num_colors = size(colors, 1);
    
    if num_colors > max_colors
        colors = reshape(colors, [], 1, 3);
        colors = imresize(colors, [max_colors, 1], 'bilinear');
        colors = reshape(colors, [], 3);
    end
    
    % If there are less than k unique colors, then k-means will not work.
    % It does however become trivial to determine dominant colors in such
    % cases.
    
    unique_colors = uniquetol(colors, 1e-3, 'ByRows', true);
    num_unique_colors = size(unique_colors, 1);
    
    if(num_unique_colors <= k)
        result.dominance = zeros(1, k);
        result.colors_lab = zeros(k, 3);
        for i = 1:num_unique_colors
            c = unique_colors(i, :);
            result.dominance(i) = sum(sum(abs(colors - c), 2) <= 1e-3);
            result.colors_lab(i, :) = rgb2lab(c);
        end
        result.dominance = result.dominance / sum(result.dominance);
        
        [~,idx] = sort(result.dominance, 'descend');
        result.dominance = result.dominance(idx);
        result.colors_lab = result.colors_lab(idx, :);
    else
        colors_lab = rgb2lab(colors);
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

