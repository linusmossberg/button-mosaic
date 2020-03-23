image = imread("..\input_images\katmainps_public-domain.png");
warning('off','images:bwfilt:tie');
image = im2double(image);
image = imresize(image, 4);

circle_packing_settings.num_clusters = 4;
circle_packing_settings.max_radius = Inf;
circle_packing_settings.radius_reduction_start = Inf;
circle_packing_settings.smooth_est_scale = 0.25;
circle_packing_settings.label_close_radius = 8;
circle_packing_settings.label_min_area = 1024;
circle_packing_settings.min_radius = 16;

mosaic_settings.scale = 1;
mosaic_settings.AA = 4;
mosaic_settings.button_history = 20;
mosaic_settings.similarity_threshold = 5;
mosaic_settings.unique_button_limit = Inf;

mosaic_settings.min_dominant_radius = Inf;
[mosaic{1}, mosaic{2}] = buttonMosaic(image, circle_packing_settings, mosaic_settings);
imwrite(mosaic{1}, 'mean_sim2.png');
imwrite(mosaic{2}, 'corrected_mean_sim.png');
mosaic_settings.min_dominant_radius = 0;
[mosaic{3}, mosaic{4}] = buttonMosaic(image, circle_packing_settings, mosaic_settings);
imwrite(mosaic{3}, 'dominant_sim.png');
imwrite(mosaic{4}, 'corrected_dominant_sim.png');

PPI = 104; % 4096px = 1 meter

distances = 0.25:0.5:20;

figure

scielab_total_data = zeros(4, length(distances));
D65_wp = [0.9504, 1.0000, 1.0888];
XYZ_reference = rgb2xyz(image, 'WhitePoint', 'd65');
for i = 1:length(mosaic)
    
    XYZ_reproduced = rgb2xyz(mosaic{i}, 'WhitePoint', 'd65');
    
    for j = 1:length(distances)
        D = distances(j) * 39.3700787;
        SPD = PPI * D * tan(pi/180);
        scielab_map = scielab(SPD, XYZ_reference, XYZ_reproduced, D65_wp, 'xyz');
        scielab_total_data(i, j) = mean(scielab_map(:));
        disp((100*i*j) / (4*length(distances)))
    end
    plot(distances(2:30), scielab_total_data(i, 2:30), '.-', 'LineWidth', 1, 'MarkerSize', 10);hold on;
    drawnow
end
grid on;
hold off;

title('S-CIELAB over view distance of images reproduced with different color matching functions')
xlabel('View Distance (meters)')
ylabel('S-CIELAB')
legend('Mean Color Matching', 'Dominant Color Matching')