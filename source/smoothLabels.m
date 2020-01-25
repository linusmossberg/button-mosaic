function L = smoothLabels(L)
    num_labels = max(L(:));
    
    for i = 1:num_labels
        mask = L == i;

        mask = bwareaopen(~mask,50);
        mask = bwareaopen(~mask,50);
        
        mask = imclose(mask, strel('disk', 2));
        
        mask = bwareaopen(~mask,50);
        mask = bwareaopen(~mask,50);
        
        L(mask) = i;
    end
end

