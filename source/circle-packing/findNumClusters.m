function [num_clusters, low_unique] = findNumClusters(image)

    max_clusters = 16;
    
    num_unique_colors = size(uniquetol(reshape(image, [], 3), 1e-3, 'ByRows', true), 1);
    
    low_unique = false;
    if num_unique_colors <= max_clusters
        num_clusters = num_unique_colors;
        low_unique = true;
        return;
    end

    num_colors = prod(size(image), 1:2);
    max_colors = 256*256;
    
    if(num_colors > max_colors)
        image = imresize(image, sqrt(max_colors/num_colors), 'nearest');
    end
    
    image = rgb2lab(image);

    image_vec = reshape(image, [], 3);

    kmeans_func = @(X,K)(kmeans(X, K, 'MaxIter', 10000, ...
                                      'Options', statset('UseParallel',1), ...
                                      'Replicates', 3));

    evaluation = evalclusters(image_vec, kmeans_func, 'CalinskiHarabasz', 'KList', 1:max_clusters);

    num_clusters = evaluation.OptimalK;
end