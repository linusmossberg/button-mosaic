%% Example 1: Use estimated and default settings
image = imread('https://uploads1.wikiart.org/images/eyvind-earle/winter-quiet-1980.jpg');

[mosaic, corrected] = buttonMosaic(image);

figure
subplot(1,3,1);imshow(image);title('Original')
subplot(1,3,2);imshow(mosaic);title('Button Mosaic')
subplot(1,3,3);imshow(corrected);title('Corrected Button Mosaic')

%% Example 2: Specify settings manually

image = imread('https://uploads1.wikiart.org/images/eyvind-earle/winter-quiet-1980.jpg');

circle_packing_settings.min_radius = 4;
circle_packing_settings.num_clusters = 5;
circle_packing_settings.max_radius = Inf;
circle_packing_settings.radius_reduction_start = Inf;
circle_packing_settings.smooth_est_scale = 1;
circle_packing_settings.label_close_radius = 2;
circle_packing_settings.label_min_area = 64;

mosaic_settings.scale = 1;
mosaic_settings.AA = 4;
mosaic_settings.button_history = 20;
mosaic_settings.similarity_threshold = 5;
mosaic_settings.min_dominant_radius = 16;
mosaic_settings.unique_button_limit = Inf;

[mosaic, corrected] = buttonMosaic(image, circle_packing_settings, mosaic_settings);

figure
subplot(1,3,1);imshow(image);title('Original')
subplot(1,3,2);imshow(mosaic);title('Button Mosaic')
subplot(1,3,3);imshow(corrected);title('Corrected Button Mosaic')