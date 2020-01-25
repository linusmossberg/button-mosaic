function num_clusters = findNumClusters(image)
    image = imresize(double(image), 0.25, 'nearest');

    image_vec = reshape(image, [], 3);

    kmeans_func = @(X,K)(kmeans(X, K, 'MaxIter', 10000, ...
                                      'Options', statset('UseParallel',1), ...
                                      'Replicates', 3));

    evaluation = evalclusters(image_vec, kmeans_func, 'CalinskiHarabasz', 'KList', 1:16);

    num_clusters = evaluation.OptimalK;
end