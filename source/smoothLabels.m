function L = smoothLabels(L)
    num_labels = max(L(:));
    
    for i = 1:num_labels
        mask = L == i;
        
        d = 10;
        
        mask = bwareaopen(~mask,d*d);
        mask = bwareaopen(~mask,d*d);
        
        mask = imclose(mask, strel('disk', 2));
        
        mask = bwareaopen(~mask,d*d);
        mask = bwareaopen(~mask,d*d);
        
        L(mask) = i;
    end
    %L = imclose(L, strel('disk', 2));
end

