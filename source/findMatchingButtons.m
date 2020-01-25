% Finds num_buttons of the most similar buttons.

function filenames = findMatchingButtons(query_dc, num_buttons, similarity_threshold)
    persistent buttons;
    
    if isempty(buttons)
        buttons = load('..\buttons\buttons.mat');
    end
    
    max_similarities = repmat(-1e10, 1, num_buttons);
    indices = zeros(1, num_buttons, 'uint32');
    
    for i = 1:length(buttons.data)
        button_dc = buttons.data(i).dominant_colors;
        similarity = dominantColorsSimilarity(query_dc, button_dc, 30);
        
        if any(similarity > max_similarities)
            [~, idx] = min(max_similarities);
            max_similarities(idx) = similarity;
            indices(idx) = i;
        end
    end
    
    if(any(indices))
        [max_similarities, idx] = sort(max_similarities, 'descend');
        indices = indices(idx);
        
        % Remove any matches that are too unsimilar compared to the most
        % similar match, determined by similarity_threshold.
        indices(max_similarities(1) > (max_similarities + similarity_threshold)) = [];
        
        filenames = string({buttons.data(indices).filename});
    else
        filenames = '';
    end
end

