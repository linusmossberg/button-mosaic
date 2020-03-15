image = imread("..\input_images\Great_Wave_off_Kanagawa2_rmv_4096.png");
image = im2double(image);
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

settings.min_radius = 4;
settings.num_colors = 6;
settings.max_radius = Inf;
settings.radius_reduction_start = Inf;
settings.smooth_est_scale = 0.25;
settings.label_close_radius = 2;
settings.label_min_area = 8*8;

S = settings;

lab_image = rgb2lab(smoothColor(image, S.smooth_est_scale));
colors_lab = reshape(lab_image, [], 3);

rng(1);

[label_vec, ~] = kmeans(colors_lab, S.num_colors, ...
                        'MaxIter', 10000, ...
                        'Options', statset('UseParallel',1), ...
                        'Replicates', 5);

label_image = reshape(label_vec, size(image, 1:2));

for i = 1:max(label_image(:))
    mask = label_image == i;

    mask = bwareaopen(~mask, S.label_min_area);
    mask = bwareaopen(~mask, S.label_min_area);
    mask = imclose(mask, strel('disk', S.label_close_radius));
    mask = bwareaopen(~mask, S.label_min_area);
    mask = bwareaopen(~mask, S.label_min_area);

    label_image(mask) = i; 
end

orig_label_image = conCompSplitLabel(label_image, 'descend');
%%
for min_radius = 65:4096
    tic
    %label_image = segmentImage(image, settings);
    
    settings.min_radius = min_radius;
    
    %%%
    %label_image = smoothLabels(orig_label_image, floor(min_radius));
    %label_image = conCompSplitLabel(label_image, 'ascend');
    dim = 1 + 2 * min_radius;
    [X, Y] = meshgrid(1:dim, 1:dim);
    center = (dim + 1) / 2;
    structuring_element = sqrt((X-center).^2 + (Y-center).^2) <= min_radius;
    label_image = imopen(orig_label_image, structuring_element);
    label_image = conCompSplitLabel(label_image, 'ascend');
    %%%

    circles = createPackedCircles(image, label_image, settings);

    mosaic_settings.scale = 1;
    mosaic_settings.AA = 4;
    mosaic_settings.button_history = 20;
    mosaic_settings.similarity_threshold = 5;
    mosaic_settings.min_dominant_radius = 16;
    mosaic_settings.unique_button_limit = 4;
    mosaic_settings.min_radius = settings.min_radius;
    
    fig = figure;
    set(fig, 'Position', get(0, 'Screensize'));
    
    drawCircles(circles, size(image, 2), size(image, 1));
    drawnow
    F = getframe(fig).cdata;
    imwrite(F, ['circles-' num2str(length(circles)) '_min-radius-' num2str(min_radius, '%02d') '.png']);
    close(fig)
    toc
end
    
%%

%[result(:,:,:,1), result(:,:,:,2)] = createButtonMosaic(circles, image, mosaic_settings);
%mosaic = createButtonMosaic(circles, image, mosaic_settings);


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


% function result = applyAlpha(image, alpha, result)
%     for i = 1:3
%         result(:,:,i) = result(:,:,i) .* (1-alpha) + image(:,:,i) .* alpha;
%     end
% end

%%
d = dir('*.png')
[~, order] = sort([d.datenum], 'descend');
names = string({d.name});
names = names(order);

v = VideoWriter('database_animation.avi', 'Uncompressed AVI');
v.FrameRate = 10;
open(v);

for name = names
    if(isfile(name))
        writeVideo(v, imcrop(imread(name), [390, 77, 1599 - 390, 903 - 77,]));
        disp(name);
    end
end

close(v)

%%
%fig = fig;
p1 = plot(data(:,2), data(:,1), 'k-', 'LineWidth', 2)
set(gca, 'XDir','reverse')
hold on;

v = VideoWriter('database_animation23.avi', 'Uncompressed AVI');
v.FrameRate = 8;
open(v);

for i = 1:size(data, 1)
    title(['Min Radius: ' sprintf('%2d', data(i,2)) 'px, Num Circles: ' sprintf('%5d', data(i,1))]);
    p2 = plot(data(i,2), data(i,1), 'k.', 'MarkerSize', 30)
    drawnow
    F = getframe(gcf).cdata;
    writeVideo(v, F);
    delete(p2)
end

close(v)
%%
v = VideoReader('C:\Users\Me\Documents\TNM097\stuff2\database_animation.avi');
vw = VideoWriter('C:\Users\Me\Documents\TNM097\stuff2\database_animation_2.avi', 'Uncompressed AVI');
vw.FrameRate = 10;
open(vw)

colors = [];
while hasFrame(v)
    %frame = imresize(readFrame(v), 960/1208, 'bicubic');
    frame = readFrame(v);
    writeVideo(vw, frame);
    frame = imresize(frame, 0.25, 'nearest');
    frame = rgb2lab(frame);
    colors = [colors ; reshape(frame, [], 3)];
    disp(rand())
end
k = 64;
[~, C] = kmeans(colors, k, 'MaxIter', 10000, 'Replicates', 5);

[~,order] = sort(C(:,1));
C = C(order, :);

C = clamp(lab2rgb(C), 0, 1);
C = [C ; ones(256 - k, 3)];

imwrite(reshape(C, [], 16, 3), 'C:\Users\Me\Documents\TNM097\stuff2\palette.png')
close(vw)
