function image = smoothColor(image, scale)
    f = waitbar(0, 'Smoothing image colors');
    for i = 1:3
        image(:,:,i) = diffuseWithEst(image(:,:,i), scale);
        waitbar(i/3, f, 'Smoothing image colors');
    end
    close(f)
end

function gray_image = diffuseWithEst(gray_image, scale)
    r = centerCropWindow2d(size(gray_image), round(size(gray_image) * scale));

    [grad_thresh, num_iter] = imdiffuseest(imcrop(gray_image, r));
    
    gray_image = imdiffusefilt(gray_image, ...
                               'ConductionMethod', 'exponential', ...
                               'GradientThreshold', grad_thresh, ...
                               'NumberOfIterations', num_iter);
end


