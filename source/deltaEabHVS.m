function result = deltaEabHVS(original, reproduced, view_distance)
    %f = MFTsp(15, 0.0847, view_distance); % 300 DPI
    f = MFTsp(15, 0.2443, view_distance); % 104 DPI (4096px = 1m)
    
    hvs_original = filterColor(original, f);
    hvs_reproduced = filterColor(reproduced, f);
    
    hvs_original_Lab = reshape(rgb2lab(hvs_original), 3, []);
    hvs_reproduced_Lab = reshape(rgb2lab(hvs_reproduced), 3, []);
    
    dists = sqrt(sum((hvs_original_Lab - hvs_reproduced_Lab).^2));
    result = sum(dists) / numel(dists);
end

function image = filterColor(image, f)
    for c = 1:3
        image(:,:,c) = conv2(image(:,:,c), f, 'same');
    end
    image = max(image, 0);
end
