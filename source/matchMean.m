function result = matchMean(image, reference)
    reference_mean_color = mean(reshape(reference, [], 3));
    image_mean_color = mean(reshape(image, [], 3));
    move = reference_mean_color - image_mean_color;
    result = image + reshape(move, 1, 1, 3);
end

