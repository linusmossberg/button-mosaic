image = imread("..\input_images\646full-the-holy-mountain-screenshot.jpg");
image = im2double(image);
%orig_image = imresize(orig_image, 1/8);
%image = smoothColor(orig_image, 1.0);

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

settings.num_colors = 4;
settings.min_radius = 4;
settings.max_radius = 800;
settings.radius_reduction_start = 256;
settings.smooth_est_scale = 1.0;
settings.scale = 1;
settings.AA = 4;
settings.label_close_radius = 4;
settings.label_min_area = 8*8;

label_image = segmentImage(image, settings);

figure
imshow(labeloverlay(ones(size(image)), label_image));

circles = createPackedCircles(image, label_image, settings);

result = createButtonMosaic(circles, size(image, 1:2), settings.scale, settings.AA);

result(:,:,:,4) = matchMean(result(:,:,:,3), image);

%figure
%drawCircles(circles, size(image, 2), size(image, 1));

figure
subplot(2,2,1)
imshow(result(:,:,:,1));title('Uncorrected Buttons')
subplot(2,2,2)
imshow(result(:,:,:,2));title('Luma Corrected Buttons')
subplot(2,2,3)
imshow(result(:,:,:,3));title('Luma+Chroma Corrected Buttons')
subplot(2,2,4)
imshow(result(:,:,:,4));title('Luma+Chroma Corrected Buttons, Mean Corrected')

%%

addpath('lib')

distance = 500:100:5000;

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

legend('Uncorrected', 'Luma', 'Luma+Chroma', 'Luma+Chroma+Mean')






