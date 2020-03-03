function dEab = HVS_dEab(ref, res, distance)
    f = MFTsp(15, 0.0847, distance);
    
    res_s(:,:,1) = conv2(res(:,:,1), f, 'same');
    res_s(:,:,2) = conv2(res(:,:,2), f, 'same');
    res_s(:,:,3) = conv2(res(:,:,3), f, 'same');
    
    res_s = max(res_s, 0);
    
    ref_s(:,:,1) = conv2(ref(:,:,1), f, 'same');
    ref_s(:,:,2) = conv2(ref(:,:,2), f, 'same');
    ref_s(:,:,3) = conv2(ref(:,:,3), f, 'same');
    
    ref_s = max(ref_s, 0);
    
    ref_Lab = reshape(rgb2lab(ref_s), 3, []);
    res_Lab = reshape(rgb2lab(res_s), 3, []);
    
    dists = sqrt(sum((ref_Lab - res_Lab).^2));
    dEab = sum(dists) / numel(dists);
end

