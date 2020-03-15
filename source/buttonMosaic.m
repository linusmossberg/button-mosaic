function [mosaic, corrected] = buttonMosaic(image, circle_packing_settings, mosaic_settings)

    addpath(genpath('.'));
    warning('off','images:bwfilt:tie');

    image = im2double(image);
    
    if nargin < 3
        [circle_packing_settings, mosaic_settings] = estSettings(image);
    end

    label_image = segmentImage(image, circle_packing_settings);
    circles = createPackedCircles(image, label_image, circle_packing_settings);
    
    if nargout > 1
        [mosaic, corrected] = createButtonMosaic(circles, image, mosaic_settings);
    else
        mosaic = createButtonMosaic(circles, image, mosaic_settings);
    end
end

function [circle_packing_settings, mosaic_settings] = estSettings(image)
    width = size(image, 2);
    est_factor = width/1024;
    [num_clusters, low_unique] = findNumClusters(image);
    
    disp(['Number of clusters: ' num2str(num_clusters)])

    circle_packing_settings.min_radius = 4;
    circle_packing_settings.num_clusters = num_clusters;
    circle_packing_settings.max_radius = Inf;
    circle_packing_settings.radius_reduction_start = Inf;
    circle_packing_settings.smooth_est_scale = min(1 / est_factor, 1);
    circle_packing_settings.label_close_radius = round(2 * est_factor);
    circle_packing_settings.label_min_area = (round(8 * est_factor))^2;
    
    if low_unique
        circle_packing_settings.smooth_est_scale = -1;
    end

    mosaic_settings.scale = 1;
    mosaic_settings.AA = 4;
    mosaic_settings.button_history = 20;
    mosaic_settings.similarity_threshold = 5;
    mosaic_settings.min_dominant_radius = 16;
    mosaic_settings.unique_button_limit = Inf;
end