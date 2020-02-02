function L = smoothLabels(L, min_distance)
    
    f = waitbar(0, 'Smoothing segmented region labels');
    
    num_labels = max(L(:));
    
    for i = 1:num_labels
        mask = L == i;
        
        % American gothic, Wheat field
        %d = 8;
        %radius = 2;
        
        % Hilma
        %d = 8
        %radius = 1;
        
        % Wave
        %none
        
        % Scream
        %d = 10;
        %radius = 2;
        
        d = 8;
        radius = 1;
        
        mask = bwareaopen(~mask,d*d);
        mask = bwareaopen(~mask,d*d);
        mask = imclose(mask, strel('disk', radius));
        mask = bwareaopen(~mask,d*d);
        mask = bwareaopen(~mask,d*d);
        L(mask) = i; 
    end
    
    for i = 1:num_labels
        mask = L == i;
        
        new_mask = removeUnusable(mask, min_distance);
        unusable = mask & ~new_mask;
        
        [L, ~] = distributeUnusable(unusable, L, i, false);
        
        L(new_mask) = i;
        waitbar(double(i) / double(num_labels), f, 'Smoothing segmented region labels');
    end
    
    close(f);
end

function result = removeUnusable(mask, min_distance)
    distance = bwdist(~(mask & ~bwmorph(mask,'remove')));
    valid = distance >= min_distance;
        
    dim = 1 + 2 * min_distance;
    [X, Y] = meshgrid(1:dim, 1:dim);
    center = (dim + 1) / 2;
        
    structuring_element = sqrt((X-center).^2 + (Y-center).^2) <= min_distance;
        
    result = imdilate(valid, structuring_element) & mask;
end
