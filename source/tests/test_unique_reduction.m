image = imread("..\input_images\earring_proc.png");
warning('off','images:bwfilt:tie');
image = im2double(image);

circle_packing_settings.min_radius = 4;
circle_packing_settings.num_clusters = 12;
circle_packing_settings.max_radius = Inf;
circle_packing_settings.radius_reduction_start = Inf;
circle_packing_settings.smooth_est_scale = 0.5;
circle_packing_settings.label_close_radius = 8;
circle_packing_settings.label_min_area = 1024;

mosaic_settings.scale = 1;
mosaic_settings.AA = 4;
mosaic_settings.button_history = 1;
mosaic_settings.similarity_threshold = 0;
mosaic_settings.min_dominant_radius = 16;

label_image = segmentImage(image, circle_packing_settings);
circles = createPackedCircles(image, label_image, circle_packing_settings);

for num_unique_buttons = 2.^(1:6)
    mosaic_settings.unique_button_limit = num_unique_buttons;
    mosaic = createButtonMosaic(circles, image, mosaic_settings);
    imwrite(mosaic, sprintf('unique_%d.png', num_unique_buttons));
end

PPI = 104; % 4096px = 1 meter
D = 3 * 39.3700787; % 3 meters
SPD = PPI * D * tan(pi/180);

i = 1;
scielab_unique_reduction = zeros(1, 6);
D65_wp = [0.9504, 1.0000, 1.0888];
XYZ_reference = rgb2xyz(image, 'WhitePoint', 'd65');
for num_unique_buttons = 2.^(1:6)
    XYZ_reproduced = rgb2xyz(im2double(imread(sprintf('unique_%d.png', num_unique_buttons))), 'WhitePoint', 'd65');
    scielab_unique_reduction(i) = scielab(SPD, XYZ_reference, XYZ_reproduced, D65_wp, 'xyz');
    i = i + 1;
end

bar(categorical(2.^(1:6)), scielab_unique_reduction)

title('S-CIELAB of images reproduced with different amounts of unique buttons')
xlabel('Unique Buttons')
ylabel('S-CIELAB')