image = imread("..\input_images\earring_proc.png");
warning('off','images:bwfilt:tie');
image = im2double(image);

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
mosaic_settings.unique_button_limit = Inf;

min_radius = 4:2:14;
num_circles = zeros(size(min_radius));

for i = 1:length(min_radius)
    circle_packing_settings.min_radius = min_radius(i);
    label_image = segmentImage(image, circle_packing_settings);
    circles = createPackedCircles(image, label_image, circle_packing_settings);
    [m, mosaic] = createButtonMosaic(circles, image, mosaic_settings);
    imwrite(mosaic, sprintf('total-%d_r-%d.png', length(circles), min_radius(i)));
    num_circles(i) = length(circles);
end

PPI = 104; % 4096px = 1 meter

distances = 0.25:1:10;

figure

scielab_total_data = zeros(1, 6);
D65_wp = [0.9504, 1.0000, 1.0888];
XYZ_reference = rgb2xyz(image, 'WhitePoint', 'd65');
for i = 1:length(min_radius)
    XYZ_reproduced = rgb2xyz(im2double(imread(sprintf('total-%d_r-%d.png', num_circles(i), min_radius(i)))), 'WhitePoint', 'd65');
    
    for j = 1:length(distances)
        D = distances(j) * 39.3700787;
        SPD = PPI * D * tan(pi/180);
        scielab_total_data(i, j) = scielab(SPD, XYZ_reference, XYZ_reproduced, D65_wp, 'xyz');
    end
    plot(distances, scielab_total_data(i, :));hold on;
end
hold off;

title('S-CIELAB over view distance of images reproduced with different amounts of total buttons')
xlabel('View Distance (meters)')
ylabel('S-CIELAB')
legend(string(num_circles))