function result = kDominantColors(colors, k, max_colors, replicates, should_plot)

    if nargin < 5
        should_plot = false;
    end
    
    colors = reshape(colors, [], 3);
    
    num_colors = size(colors, 1);
    
    if num_colors > max_colors
        step_size = round(num_colors/max_colors);
        colors = colors(1:step_size:num_colors, :);
    end

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
    
    if should_plot
        pie(result.dominance);
        colormap(lab2rgb(result.colors_lab));
    end
end

