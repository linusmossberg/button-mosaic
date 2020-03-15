function [L, remaining] = distributeUnusable(unusable, L, i, t)
    unusable_CCs = bwlabel(unusable, 8) + 1;

    max_unusable_CCs = max(unusable_CCs(:));

    unusable_CCs(~unusable) = 0;
    
    remaining = unusable;

    for j = 1:max_unusable_CCs
        unusable_CC = unusable_CCs == j;

        neighbor_pixels = imdilate(unusable_CC, true(3));
        neighbor_pixels = bwperim(neighbor_pixels, 8);

        neighbor_labels = L(neighbor_pixels);
        
        if t
            neighbor_labels(neighbor_labels <= i) = [];
        else
            neighbor_labels(neighbor_labels == i) = [];
        end

        largest_neighbor = mode(neighbor_labels(:));

        if ~isnan(largest_neighbor) && largest_neighbor ~= 0
            L(unusable_CC) = largest_neighbor;
            remaining(unusable_CC) = false;
        end
    end
end

