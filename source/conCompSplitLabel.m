% Splits a labeled matrix further into individual connected components.
% Orders the labels by area
function L = conCompSplitLabel(L, order)
    current_label = 0;
    new_L = zeros(size(L));
    for i = unique(L(:))'
        region = L == i;
        CC = bwlabel(region, 8);
        new_L = new_L + CC + (CC ~= 0) * current_label;
        current_label = max(new_L(:));
    end
    L = uint32(round(new_L));

    S = regionprops(L, 'PixelIdxList', 'Area');
    [~, region_order] = sort([S.Area], order);

    current_idx = 1;
    for i = region_order
        L(S(i).PixelIdxList) = current_idx;
        current_idx = current_idx + 1;
    end
end