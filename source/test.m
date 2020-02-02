orig_image = imread("..\input_images\madagascar_oli_2017018_lrg.png");
orig_image = im2single(orig_image);
%orig_image = imresize(orig_image, 1/2);
image = smoothColor(orig_image);

[height, width, ~] = size(image); 

warning('off','images:bwfilt:tie');

lab_image = rgb2lab(image);

%num_colors = findNumClusters(lab_image);

% American Gothic, Wheat Field, Hilma
%num_colors = 8;
%min_distance = 1;

% Wave
% num_colors = 6;
% min_distance = 1;

% Scream
%num_colors = 8;
%min_distance = 1;

num_colors = 4;
min_distance = 1;

[L, centers] = imsegkmeans(image, num_colors);

L = smoothLabels(L, floor(min_distance));

%min_distance = 1.1;

figure
imshow(labeloverlay(ones(size(image)),L));

circles = [];

f = waitbar(0, 'Creating circles');

remaining = false(size(L));

for i = 1:(num_colors + 1)
    
    if i <= num_colors
        mask = L == i;
        mask(1,:) = false;
        mask(:,1) = false;
        mask(end,:) = false;
        mask(:,end) = false;
    else
        mask = remaining;
    end
    
    while true
        
        % Remove the boundary pixels of the region in order to not include
        % these in the resulting radius.
        distance = bwdist(~(mask & ~bwmorph(mask,'remove')));

        [max_distance, ~] = max(distance(:));
        
        %[row, col] = ind2sub(size(mask), idx);
        %centroid = [col, row];
        
        max_region = bwareafilt(distance >= max_distance - 1e-4, 1);
        [row, col] = ind2sub(size(mask), find(max_region));
        mean_centroid = [mean(row), mean(col)];
        [~, idx] = min((row - mean(row)).^2 + (col - mean(col)).^2);
        centroid = [col(idx), row(idx)];
        
        if(max_distance < min_distance)
            break;
        end
        
        max_distance = floor(max_distance);
        
        waitbar(((i - 1) + min_distance / max_distance) / (num_colors + 1), f, 'Creating circles');

        [mask, circles] = addCircle(orig_image, circles, centroid, max_distance, mask);
    end
    
    if(i ~= num_colors)
        [L, mask] = distributeUnusable(mask, L, i, true);
    end
    
    if i <= num_colors
        remaining(mask) = true;
    else
        remaining = mask;
    end
end

% Goal is to maximize coverage while minimizing number of circles, provided
% that the image is also reproduced faithfully
disp(strcat("Uncovered pixels: ", num2str(100*sum(remaining(:)) / numel(remaining)), '%'));
disp(strcat("Number of circles: ", num2str(length(circles))));

% figure
% imshow(remaining)

%remaining_color = mean(reshape(orig_image(~repmat(remaining, 1, 1, 3)), [], 3));
base_image = zeros(size(orig_image));

close(f)
result = createButtonMosaic(circles, base_image, 4, 4);

figure
imshow(result)

% figure
% drawCircles(circles)
% xlim([0 width])
% ylim([0 height])
% 
% set ( gca, 'ydir', 'reverse' )
% pbaspect([width height 1])
% set(gca,'Color','k')
% 
%figure
%imshow(labeloverlay(ones(size(image)),L));





