function image = smoothColor(image, scale)
%     image_lab = rgb2lab(image);
%     
%     patch = imcrop(image_lab,[83,17,65,65]);
%     patchSq = patch.^2;
%     edist = sqrt(sum(patchSq,3));
%     patchVar = std2(edist).^2;
%     
%     DoS = 4*patchVar;
%     smoothedLAB = imbilatfilt(image_lab,DoS,16);
%     image = lab2rgb(smoothedLAB);

%     region = [8,8];
% 
%     image(:,:,1) = medfilt2(image(:,:,1),region);
%     image(:,:,2) = medfilt2(image(:,:,2),region);
%     image(:,:,3) = medfilt2(image(:,:,3),region);
    
%     image(:,:,1) = imdiffusefilt(image(:,:,1));
%     image(:,:,2) = imdiffusefilt(image(:,:,2));
%     image(:,:,3) = imdiffusefilt(image(:,:,3));
    
    f = waitbar(0, 'Smoothing image colors');
    for i = 1:3
        image(:,:,i) = diffuseWithEst(image(:,:,i), scale);
        waitbar(i/3, f, 'Smoothing image colors');
    end
    close(f)
    
%     image = im2uint8(image);
%     image = rog_smooth(image, 0.01, 1, 3, 3);
%     image = im2single(image);
end

function gray_image = diffuseWithEst(gray_image, scale)
    r = centerCropWindow2d(size(gray_image), round(size(gray_image) * scale));

    [grad_thresh, num_iter] = imdiffuseest(imcrop(gray_image, r));
    
    gray_image = imdiffusefilt(gray_image, ...
                               'ConductionMethod', 'exponential', ...
                               'GradientThreshold', grad_thresh, ...
                               'NumberOfIterations', num_iter);
end


