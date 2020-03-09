function createLimitedDatabase(image, num_buttons)
    colors_lab = reshape(rgb2lab(image), [], 3);
    
    [label_vec, ~] = kmeans(colors_lab, num_buttons, ...
                            'MaxIter', 10000);
                        
    buttons = load('..\buttons\buttons.mat');
    
    buttons_subset = struct;
    for i = 1:max(label_vec)
        mask = reshape(label_vec == i, size(image, 1:2));
        dominant_colors = kDominantColors(image, mask, 3, 2e4, 5);
        buttons_subset.data(i) = findBestButton(dominant_colors);
    end
    data = buttons_subset.data;
    save('..\buttons\buttons-subset.mat', 'data');
    
    function best_button = findBestButton(dominant_colors)
        best_button_index = 1;
        best_similarity = -Inf;
        for j = 1:length(buttons.data)
            similarity = dominantColorsSimilarity(dominant_colors, buttons.data(j).dominant_colors, 30);

            if(similarity > best_similarity)
                best_similarity = similarity;
                best_button_index = j;
            end
        end
        best_button = buttons.data(best_button_index);
        buttons.data(best_button_index) = [];
    end
end