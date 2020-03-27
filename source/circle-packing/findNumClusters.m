function [num_clusters, low_unique] = findNumClusters(image_lab)

    max_clusters = 16;
    
    num_unique_colors = size(unique(reshape(im2uint8(lab2rgb(image_lab)), [], 3), 'rows'), 1);
    
    low_unique = false;
    if num_unique_colors <= max_clusters
        num_clusters = num_unique_colors;
        low_unique = true;
        return;
    end

    num_colors = prod(size(image_lab, 1:2));
    max_colors = 256*256;
    
    if(num_colors > max_colors)
        image_lab = imresize(image_lab, sqrt(max_colors/num_colors), 'bilinear');
    end

    colors_lab = reshape(image_lab, [], 3);

    kmeans_func = @(X,K)(kmeans(X, K, 'MaxIter', 10000, ...
                                      'Options', statset('UseParallel',1), ...
                                      'Replicates', 3));

    evaluation = evalclusters(colors_lab, kmeans_func, 'CalinskiHarabasz', 'KList', 1:max_clusters);

    num_clusters = evaluation.OptimalK;
end