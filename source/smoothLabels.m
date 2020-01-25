function L = smoothLabels(L)
    num_labels = max(L(:));
    
    for i = 1:num_labels
        mask = L == i;

        mask = bwareaopen(~mask,16);
        mask = bwareaopen(~mask,16);
        
        L(mask) = i;
    end
    %L = imclose(L, strel('disk', 2));
end

