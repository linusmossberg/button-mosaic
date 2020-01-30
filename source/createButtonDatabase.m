function createButtonDatabase(folder, out_folder)
    
    %return; % avoid accidentally running and ruining db

    clear saveImage;
    
    readme_id = fopen(strcat(out_folder, '\README.txt'), 'a');
    addReadmeHeader(readme_id);
    
    attribution_entry = 'Source creator label: %s\nWebsite: %s\nLicense: %s\n\n';
    
    crop_pixels = 5;

    directories = dir(folder);
    for directory = directories'
        
        path = strcat(directory.folder, '\', directory.name);
        info_filename = strcat(path, '\info.json');
        
        if(directory.isdir && isfile(info_filename))
            
            info_json = jsondecode(fileread(info_filename));
            
            fprintf(readme_id, attribution_entry, info_json.name, ...
                    info_json.website, info_json.license);
            
            jpg_files = dir([path '\*.jpg']);
            png_files = dir([path '\*.png']);
            
            prefix = strcat(info_json.name, '_', info_json.license_name);

            for jpeg_file = jpg_files'
                image = imread(strcat(jpeg_file.folder, '\', jpeg_file.name));
                [image, alpha] = cropAndMaskCircle(image, crop_pixels);
                saveImage(image, alpha, prefix, out_folder);
            end
            
            for png_file = png_files'
                image_path = strcat(png_file.folder, '\', png_file.name);
                
                % Twice because reading rgb with alpha can be buggy
                [~,~,alpha] = imread(image_path);
                image = imread(image_path);
                
                if size(image, 3) == 1
                    image = im2uint8(ind2rgb(image, gray));
                end

                mask = alpha >= 128;
                
                CC = bwconncomp(mask, 4);
                BB = regionprops('table', CC, 'BoundingBox').BoundingBox;

                for i = 1:size(BB, 1)
                    cropped_image = imcrop(image, BB(i, :));
                    [cropped_image, alpha] = cropAndMaskCircle(cropped_image, crop_pixels);
                    saveImage(cropped_image, alpha, prefix, out_folder);
                end
            end
        end
    end
    fclose(readme_id);
end

function [image, alpha] = cropAndMaskCircle(image, crop_pixels)

    max_resolution = 1024;

    [height, width, ~] = size(image);
    dim = min(height, width);
    r = centerCropWindow2d(size(image), [dim, dim]);
    image = imcrop(image, r);
    
    if(dim > max_resolution)
        dim = max_resolution;
        image = imresize(image, [dim, dim]);
    end
    
    % Crop off crop_pixels pixels on each side to tighten mask
    dim = dim - crop_pixels * 2;
    r = centerCropWindow2d(size(image), [dim, dim]);
    image = imcrop(image, r);
    
    %dim_l = dim * 4;
    dim_l = dim;
    
    [X, Y] = meshgrid(1:dim_l, 1:dim_l);
    center = (dim_l + 1) / 2;
    radius = dim_l / 2;
    
    center_dist = sqrt((X - center).^2 + (Y - center).^2);
    %feather_radius = radius - feather_pixels;
    
    %alpha = (center_dist - feather_radius) / (radius - feather_radius);
    %alpha = 1 - clamp(alpha, 0, 1);
    %alpha = easeInEaseOut(alpha, 1.5);
    
    alpha = im2uint8(center_dist <= radius);
    %alpha = imresize(alpha, size(image, 1:2), 'bilinear');
    image = im2uint8(image);
end

function saveImage(image, alpha, prefix, folder)
    persistent prefixes;
    
    if isempty(prefixes)
        prefixes = containers.Map;
    end
    
    if(~prefixes.isKey(prefix))
        prefixes(prefix) = 0;
    end
    
    prefixes(prefix) = prefixes(prefix) + 1;
    
    filename = strcat(prefix, '_', num2str(prefixes(prefix), '%04d'), '.png');
    
    imwrite(image, strcat(folder, '\', filename), 'Alpha', alpha);
    
    db_info_filename = strcat(folder, '\buttons.mat');
    
    colors = reshape(image, [], 3);
    mask = alpha > 128;
    colors = im2double(colors(mask(:), :));
    
    entry.dominant_colors = kDominantColors(colors, 3, 20000, 5);
    entry.mean_color_lab = mean(rgb2lab(colors));
    entry.filename = filename;
    entry.diameter = size(image, 1);
    
    if ~isfile(db_info_filename)
        data = entry;
        save(db_info_filename, 'data', '-v7.3');
    else
        m = matfile(db_info_filename, 'Writable', true);
        m.data(end+1,:) = entry;
    end
end

function addReadmeHeader(readme_id)
    header = [
    'This is a database with images of buttons sourced from various places. ', ...
    'All source images were licensed to permit sharing and adaption. ', ... 
    'The source images have been modified by splitting, cropping, masking and resizing them.\n\n', ...
    'The filenames uses the following formatting:\n', ...
    '[source-creator-label]_[licence]_[image-number].png\n\n', ...
    'The file buttons.mat contains information about the 3 dominant colors and the mean colors of each button.\n\n', ...
    '---------------------------------------------------\n\n', ...
    'Attributions:\n\n'
    ];
    
    fprintf(readme_id, header);
end

function y = easeInEaseOut(x, a)
    y = x.^a ./ (x.^a + (1-x).^a);
end


           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           