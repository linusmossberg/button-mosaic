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

settings.num_colors = 12;
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

result = createButtonMosaic(circles, zeros(size(image)), settings.scale, settings.AA);

figure
imshow(result)





