image = imread("..\input_images\katmainps_public-domain.png");
image = im2double(image);
image = imresize(image, 4);
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

% settings.num_colors = 8;
% settings.min_radius = 4;
% settings.max_radius = Inf;
% settings.radius_reduction_start = Inf;
% settings.smooth_est_scale = min(1 / est_factor, 1);
% settings.label_close_radius = round(2 * est_factor);
% settings.label_min_area = (round(8 * est_factor))^2;

settings.num_colors = 4;
settings.min_radius = 4;
settings.max_radius = Inf;
settings.radius_reduction_start = Inf;
settings.smooth_est_scale = 0.25;
settings.label_close_radius = 8;
settings.label_min_area = 32*32;

label_image = segmentImage(image, settings);

figure
imshow(labeloverlay(ones(size(image)), label_image));

circles = createPackedCircles(image, label_image, settings);

%%
%figure;hold on;

mosaic_settings.scale = 1;
mosaic_settings.AA = 4;
mosaic_settings.button_history = 20;
mosaic_settings.similarity_threshold = 5;
mosaic_settings.min_dominant_radius = 8;
mosaic_settings.unique_button_limit = Inf;

%[result(:,:,:,1), result(:,:,:,2)] = createButtonMosaic(circles, image, mosaic_settings);
mosaic = createButtonMosaic(circles, image, mosaic_settings);

%imwrite(mosaic, 'dominant_similarity.png');
%imwrite(corrected, 'corrected.png');

% figure
% drawCircles(circles, size(image, 2), size(image, 1));

% figure
% subplot(2,2,1)
% imshow(result(:,:,:,1));title('Uncorrected Buttons')
% subplot(2,2,2)
% imshow(result(:,:,:,2));title('Luma+Chroma Corrected Buttons')
% subplot(2,2,3)
% imshow(result(:,:,:,3));title('Luma+Chroma Corrected Buttons, Mean Corrected')

addpath('lib')

distance = 50:200:6000;

dEab = zeros(1, length(distance));

for j = 1:length(distance)
    dEab(j) = deltaEabHVS(image, mosaic, distance(j));
end

plot(distance / 1000, dEab, '.-', 'LineWidth', 1, 'MarkerSize', 10)

hold off;
xlabel('View Distance (meters)')
ylabel('\DeltaE^*_a_b')
legend('Mean Color Similarity', 'Dominant Color Similarity')
title('HVS \DeltaE^*_a_b Similarity Measure Comparison')

%%
%shellysblogger_BY-NC-SA_0029.png
[b, ~, a] = imread('../buttons/pexels_CC0_0014.png');
mask = a > 128;
a = im2double(a);
b = im2double(b);
figure
subplot(1,3,1)
imshow(applyAlpha(b, a, ones(size(b))));title('Button')

subplot(1,3,2)
kDominantColors(b, mask, 3, Inf, 5, true);title('Dominant Colors')

subplot(1,3,3)
colors = reshape(b, [], 3);
colors = colors(mask(:), :);
mean_color = mean(colors);
c = repmat(reshape(mean(colors), 1, 1, 3), size(b, 1:2));
imshow(applyAlpha(c, a, ones(size(b))));title('Mean Color')


function result = applyAlpha(image, alpha, result)
    for i = 1:3
        result(:,:,i) = result(:,:,i) .* (1-alpha) + image(:,:,i) .* alpha;
    end
end






