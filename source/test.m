orig_image = imread("..\input_images\The_Scream_proc.png");
orig_image = im2single(orig_image);
orig_image = imresize(orig_image, 1/2);
image = smoothColor(orig_image);

[height, width, ~] = size(image); 

warning('off','images:bwfilt:tie');

lab_image = rgb2lab(image);

%num_colors = findNumClusters(lab_image);
num_colors = 5;

[L, centers] = imsegkmeans(lab_image, num_colors);

L = smoothLabels(L);

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
        distance = bwdist(~mask);

        max_distance = max(distance(:));
        
        if(max_distance < 2)
            break;
        end
        
        waitbar(((i - 1) + 5 / max_distance) / num_colors, f, 'Creating circles');

        mask2 = bwareafilt(distance >= max_distance - 1e-4, 1);

        centroid = regionprops(mask2, 'Centroid').Centroid;

        [mask, circles] = addCircle(orig_image, circles, centroid, max_distance, mask);
    end
end

close(f)

result = createButtonMosaic(circles, zeros(size(orig_image)));
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
figure
imshow(labeloverlay(ones(size(image)),L));





