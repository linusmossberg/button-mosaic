% Finds S.num_matches of the most similar buttons.

function [filenames, mean_colors_lab] = findMatchingButtons(circle, S)
    persistent buttons;
    
    if isempty(buttons)
        
        if S.use_subset && isfile('..\buttons\buttons-subset.mat')
            buttons = load('..\buttons\buttons-subset.mat');
        else
            buttons = load('..\buttons\buttons.mat');
        end
        
        if isfile('..\buttons\skip.json')
            skip = jsondecode(fileread('..\buttons\skip.json'));
            skip_filenames = string(skip.filenames)';
            buttons_filenames = string({buttons.data.filename});
            
            [~,remove_idx,~] = intersect(buttons_filenames, skip_filenames);
            buttons.data(remove_idx) = [];
        end
    end
    
    max_similarities = repmat(-1e10, 1, S.num_matches);
    indices = zeros(1, S.num_matches, 'uint32');
    
    for i = 1:length(buttons.data)
        
        if circle.radius >= S.min_dominant_radius
            similarity = dominantColorsSimilarity(circle.dominant_colors, buttons.data(i).dominant_colors, 30);
        else
            similarity = meanColorSimilarity(circle.mean_color_lab, buttons.data(i).mean_color_lab);
        end
        
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
        indices(max_similarities(1) > (max_similarities + S.similarity_threshold)) = [];
        
        filenames = string({buttons.data(indices).filename});
        mean_colors_lab = reshape([buttons.data(indices).mean_color_lab], 3, [])';
    else
        filenames = '';
        mean_colors_lab = [];
    end
end

