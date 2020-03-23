image = imread("..\input_images\earring_proc.png");
warning('off','images:bwfilt:tie');
image = im2double(image);

circle_packing_settings.num_clusters = 12;
circle_packing_settings.max_radius = Inf;
circle_packing_settings.radius_reduction_start = Inf;
circle_packing_settings.smooth_est_scale = 0.5;
circle_packing_settings.label_close_radius = 8;
circle_packing_settings.label_min_area = 1024;
circle_packing_settings.min_radius = 4;

mosaic_settings.scale = 1;
mosaic_settings.AA = 4;
mosaic_settings.button_history = 1;
mosaic_settings.similarity_threshold = 0;
mosaic_settings.unique_button_limit = Inf;
mosaic_settings.min_dominant_radius = 16;

[mosaic{1}, mosaic{2}] = buttonMosaic(image, circle_packing_settings, mosaic_settings);
mosaic{3} = lab2rgb(matchMean(rgb2lab(mosaic{2}), rgb2lab(image)));
imwrite(mosaic{1}, 'uncorrected.png');
imwrite(mosaic{2}, 'corrected.png');
imwrite(mosaic{3}, 'mean_corrected.png');

PPI = 104; % 4096px = 1 meter

distances = 0.25:0.5:20;

scielab_total_data = zeros(4, length(distances));
D65_wp = [0.9504, 1.0000, 1.0888];
XYZ_reference = rgb2xyz(image, 'WhitePoint', 'd65');

figure
for i = 1:length(mosaic)
    XYZ_reproduced = rgb2xyz(mosaic{i}, 'WhitePoint', 'd65');
    
    for j = 1:length(distances)
        D = distances(j) * 39.3700787;
        SPD = PPI * D * tan(pi/180);
        scielab_map = scielab(SPD, XYZ_reference, XYZ_reproduced, D65_wp, 'xyz');
        scielab_total_data(i, j) = mean(scielab_map(:));
        disp((100*i*j) / (length(mosaic)*length(distances)))
    end
    plot(distances, scielab_total_data(i, :), '.-', 'LineWidth', 1, 'MarkerSize', 10);hold on;
    drawnow
end
grid on;
hold off;

title('S-CIELAB over view distance of images reproduced with different color corrections')
xlabel('View Distance (meters)')
ylabel('S-CIELAB')
legend('Uncorrected', 'Corrected Buttons', 'Corrected Buttons + Image')