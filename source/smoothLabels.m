function L = smoothLabels(L, min_distance)
    
    f = waitbar(0, 'Smoothing segmented region labels');
    
    num_labels = max(L(:));
    
    for i = 1:num_labels
        mask = L == i;
        
        new_mask = removeUnusable(mask, min_distance);
        unusable = mask & ~new_mask;
        
        unusable_CCs = bwlabel(unusable, 8) + 1;
        
        max_unusable_CCs = max(unusable_CCs(:));
        
        unusable_CCs(~unusable) = 0;
        
        for j = 1:max_unusable_CCs
            unusable_CC = unusable_CCs == j;
            
            neighbor_pixels = imdilate(unusable_CC, true(3));
            neighbor_pixels = bwperim(neighbor_pixels, 8);
            
            neighbor_labels = L(neighbor_pixels);
            
            neighbor_labels(neighbor_labels == i) = [];
            
            largest_neighbor = mode(neighbor_labels(:));
            
            if ~isnan(largest_neighbor) && largest_neighbor ~= 0
                L(unusable_CC) = largest_neighbor;
            end
        end
        
        L(new_mask) = i;
        waitbar(double(i) / double(num_labels), f, 'Smoothing segmented region labels');
    end
    
    close(f);
end

function result = removeUnusable(mask, min_distance)

%     mask(1,:) = false;
%     mask(:,1) = false;
%     mask(end,:) = false;
%     mask(:,end) = false;

    distance = bwdist(~(mask & ~bwperim(mask, 8)));
    valid = distance >= min_distance;
        
    dim = 1 + 2 * min_distance;
    [X, Y] = meshgrid(1:dim, 1:dim);
    center = (dim + 1) / 2;
        
    structuring_element = sqrt((X-center).^2 + (Y-center).^2) <= min_distance;
        
    result = imdilate(valid, structuring_element) & mask;
end
