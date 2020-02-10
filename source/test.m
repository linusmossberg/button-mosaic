orig_image = imread("..\input_images\The_Scream_proc.png");
orig_image = im2single(orig_image);
%orig_image = imresize(orig_image, 1/8);
image = smoothColor(orig_image, 0.25);

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

num_colors = 10;
min_distance = 4;

[L, ~] = imsegkmeans(image, num_colors);

for i = 1:max(L(:))
    mask = L == i;
    
    d = 16;
    radius = 4;

    mask = bwareaopen(~mask,d*d);
    mask = bwareaopen(~mask,d*d);
    mask = imclose(mask, strel('disk', radius));
    mask = bwareaopen(~mask,d*d);
    mask = bwareaopen(~mask,d*d);
    L(mask) = i; 
end

figure
imshow(labeloverlay(ones(size(orig_image)),L));

new_L = conCompSplitLabel(L, 'descend');

new_L = smoothLabels(new_L, floor(min_distance));

new_L = conCompSplitLabel(new_L, 'ascend');

orig_L = new_L;

num_regions = max(new_L(:));

figure
imshow(labeloverlay(ones(size(orig_image)),new_L));

completed_area = 0;

circles = [];

f = waitbar(0, 'Creating circles');

remaining = false(size(new_L));

for i = 1:(num_regions + 1)
    
    if i <= num_regions
        mask = new_L == i;
        stats = regionprops(mask, 'BoundingBox', 'Area');
        
        completed_area = completed_area + stats.Area;
        
        if length(stats) ~= 1
            disp(length(stats))
        end
        
        BB = ceil(stats.BoundingBox);
        
        [h, w] = size(mask);
        
        BB(3) = clamp(BB(3) + 2, 1, w - BB(1) + 1);
        BB(4) = clamp(BB(4) + 2, 1, h - BB(2) + 1);
        BB(1) = clamp(BB(1) - 1, 1, w);
        BB(2) = clamp(BB(2) - 1, 1, h);
        
        small_mask = mask(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1);
        small_orig_image = orig_image(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1, :);
        offset = [BB(1) - 1, BB(2) - 1];
    else
        small_orig_image = orig_image;
        small_mask = remaining;
        offset = [0, 0];
    end
    
    while true
        
        % Remove the boundary pixels of the region in order to not include
        % these in the resulting radius.
        distance = bwdist(~(small_mask & ~bwmorph(small_mask,'remove')));

        [max_distance, ~] = max(distance(:));
        
        max_region = bwareafilt(distance >= max_distance - 1e-4, 1);
        [row, col] = ind2sub(size(small_mask), find(max_region));
        mean_centroid = [mean(row), mean(col)];
        [~, idx] = min((row - mean(row)).^2 + (col - mean(col)).^2);
        centroid = [col(idx), row(idx)];
        
        if(max_distance < min_distance)
            break;
        end
        
        max_distance = floor(max_distance);

        [small_mask, circles] = addCircle(small_orig_image, circles, centroid, max_distance, small_mask, offset);
    end
    
    if(i <= (num_regions - 1))
        small_new_L = new_L(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1);
        [small_new_L, small_mask] = distributeUnusable(small_mask, small_new_L, i, true);
        new_L(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1) = small_new_L;
    end
    
    if i <= num_regions
        mask(BB(2):BB(2)+BB(4)-1, BB(1):BB(1)+BB(3)-1) = small_mask;
        remaining(mask) = true;
    else
        remaining = small_mask;
    end
    
    waitbar(completed_area / numel(new_L), f, 'Creating circles');
end

% Goal is to maximize coverage while minimizing number of circles, provided
% that the image is also reproduced faithfully
disp(strcat("Uncovered pixels: ", num2str(100*sum(remaining(:)) / numel(remaining)), '%'));
disp(strcat("Number of circles: ", num2str(length(circles))));

close(f)
result = createButtonMosaic(circles, zeros(size(orig_image)), 1, 4);

figure
imshow(result)





