function image = smoothColor(image)
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
    
    for i = 1:1
        image(:,:,1) = diffuseWithEst(image(:,:,1));
        image(:,:,2) = diffuseWithEst(image(:,:,2));
        image(:,:,3) = diffuseWithEst(image(:,:,3));
    end
    
%     image = im2uint8(image);
%     image = rog_smooth(image, 0.01, 1, 3, 3);
%     image = im2single(image);
end

function gray_image = diffuseWithEst(gray_image)
    [grad_thresh, num_iter] = imdiffuseest(gray_image);
    
    gray_image = imdiffusefilt(gray_image, ...
                               'ConductionMethod', 'quadratic', ...
                               'GradientThreshold', grad_thresh, ...
                               'NumberOfIterations', num_iter);
end


