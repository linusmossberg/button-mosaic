image = imread("..\input_images\eyevind_earle1.jpg");
image = im2double(image);
image = imresize(image, 1/2);
%image = smoothColor(orig_image, 1.0);

%generateLimitedDatabase(image, 64);

warning('off','images:bwfilt:tie');

%num_colors = findNumClusters(lab_image);

% American Gothic, Wheat Field, Hilma
%num_colors = 8;
%min_distance = 1;

% Hilma
%num_colors = 9;

% Wave
% num_colors = 6;
% min_distance = 1;

% Scream
%num_colors = 8;
%min_distance = 1;

% Earring
% num_colors = 12;
% min_radius = 4;
% max_radius = 800;
% radius_reduction_cutoff = 256;

width = size(image, 2);
est_factor = width/1024;

settings.num_colors = 8;
settings.min_radius = 4;
settings.max_radius = Inf;
settings.radius_reduction_start = Inf;
settings.smooth_est_scale = min(1 / est_factor, 1);
settings.label_close_radius = round(2 * est_factor);
settings.label_min_area = (round(8 * est_factor))^2;

label_image = segmentImage(image, settings);

figure
imshow(labeloverlay(ones(size(image)), label_image));

circles = createPackedCircles(image, label_image, settings);

%%

mosaic_settings.scale = 1;
mosaic_settings.AA = 4;
mosaic_settings.button_history = 20;
mosaic_settings.similarity_threshold = 2.5;
mosaic_settings.min_dominant_radius = 16;
mosaic_settings.unique_button_limit = 8;

result = zeros([size(image), 3]);

[result(:,:,:,1), result(:,:,:,2)] = createButtonMosaic(circles, image, mosaic_settings);

result(:,:,:,3) = matchMean(result(:,:,:,2), image);

%figure
%drawCircles(circles, size(image, 2), size(image, 1));

figure
subplot(2,2,1)
imshow(result(:,:,:,1));title('Uncorrected Buttons')
subplot(2,2,2)
imshow(result(:,:,:,2));title('Luma+Chroma Corrected Buttons')
subplot(2,2,3)
imshow(result(:,:,:,3));title('Luma+Chroma Corrected Buttons, Mean Corrected')

addpath('lib')

distance = 500:250:10000;

dEab = zeros(size(result, 4), length(distance));

figure;hold on;
for i = 1:size(result, 4)
    for j = 1:length(distance)
        dEab(i,j) = deltaEabHVS(image, result(:,:,:,i), distance(j));
    end
    plot(distance / 1000, dEab(i, :), '.-', 'LineWidth', 1, 'MarkerSize', 10)
end

hold off;
xlabel('Distance (meters)')
ylabel('\DeltaE^*_a_b')

legend('Uncorrected', 'Luma+Chroma', 'Luma+Chroma+Mean')






