orig_image = imread("..\input_images\apples_proc.png");
orig_image = im2single(orig_image);
%orig_image = imresize(orig_image, 1/2);
image = smoothColor(orig_image);
%image = orig_image;

[height, width, ~] = size(image); 

warning('off','images:bwfilt:tie');

lab_image = rgb2lab(image);

%num_colors = findNumClusters(lab_image);
num_colors = 5;
min_distance = 10;

[L, centers] = imsegkmeans(image, num_colors);

L = smoothLabels(L, min_distance);

% figure
% imshow(labeloverlay(ones(size(image)),L));
% figure
% imshow(orig_image);

%[L, num_colors] = superpixels(image,num_colors);

circles = [];

f = waitbar(0, 'Creating circles');

for i = 1:num_colors
    mask = L == i;

    mask(1,:) = false;
    mask(:,1) = false;
    mask(end,:) = false;
    mask(:,end) = false;
    
    while true
        
        % Remove the boundary pixels of the region in order to not include
        % these in the resulting radius.
        distance = bwdist(~(mask &  ~bwperim(mask,8)));

        [max_distance, idx] = max(distance(:));
        
        [row, col] = ind2sub(size(mask), idx);
        
        centroid = [col, row];
        
        if(max_distance < min_distance)
            break;
        end
        
        max_distance = floor(max_distance);
        
        waitbar(((i - 1) + min_distance / max_distance) / num_colors, f, 'Creating circles');

%         mask2 = bwareafilt(distance >= max_distance - 1e-4, 1);
%         centroid = regionprops(mask2, 'Centroid').Centroid;

        [mask, circles] = addCircle(orig_image, circles, centroid, max_distance, mask);
    end
end

%bg_color = mean(reshape(orig_image, [], 3), 1);
%base_image = reshape(repmat(bg_color, width*height, 1), size(orig_image));
base_image = zeros(size(orig_image));

close(f)
result = createButtonMosaic(circles, base_image, 8);
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





