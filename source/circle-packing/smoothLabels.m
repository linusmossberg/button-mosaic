function L = smoothLabels(L, min_distance)
    
    f = waitbar(0, 'Smoothing segmented region labels');
    
    num_labels = max(L(:));
    
    for i = 1:num_labels
        mask = L == i;
        
        stats = regionprops(mask, 'BoundingBox');
        
        if(length(stats) ~= 1)
            disp(length(stats))
        end
        
        BB = ceil(stats.BoundingBox);
        
        [h, w] = size(mask);
        
        BB(3) = clamp(BB(3) + 2, 1, w - BB(1) + 1);
        BB(4) = clamp(BB(4) + 2, 1, h - BB(2) + 1);
        BB(1) = clamp(BB(1) - 1, 1, w);
        BB(2) = clamp(BB(2) - 1, 1, h);
        
        small_mask = mask(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1);
        
        new_small_mask = removeUnusable(small_mask, min_distance);
        unusable = small_mask & ~new_small_mask;
        
        small_L = L(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1);
        [small_L, ~] = distributeUnusable(unusable, small_L, i, false);
        L(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1) = small_L;
        
        new_mask = false(size(mask));
        new_mask(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1) = new_small_mask;
        
        L(new_mask) = i;
        waitbar(double(i) / double(num_labels), f, 'Smoothing segmented region labels');
    end
    
    close(f);
end

function result = removeUnusable(mask, min_distance)        
    dim = 1 + 2 * min_distance;
    [X, Y] = meshgrid(1:dim, 1:dim);
    center = (dim + 1) / 2;
        
    structuring_element = (X-center).^2 + (Y-center).^2 <= (min_distance+0.5)^2;
        
    result = imopen(mask, structuring_element) & mask;
end