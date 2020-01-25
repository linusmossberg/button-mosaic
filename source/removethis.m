buttons = load('..\buttons\buttons.mat');

%%
DC1 = buttons.data(1).dominant_colors;
DC2 = buttons.data(2).dominant_colors;

similarity = dominantColorsSimilarity(DC1, DC2, 10)

%%
idxx = 1534;
for matching_index = idxx:idxx%length(buttons.data)

    DC1 = buttons.data(matching_index).dominant_colors;

    highest_similarity = -1e10;
    highest_similarity_index = 1;
    
    tic
    for i = 1:length(buttons.data)

        if matching_index == i
            continue;
        end

        DC2 = buttons.data(i).dominant_colors;
        
        similarity = dominantColorsSimilarity(DC1, DC2, 30);

        if(similarity > highest_similarity)
            highest_similarity = similarity;
            highest_similarity_index = i;
        end
    end
    toc
    
    figure(1)
    subplot(1,2,1)
    image1 = imread(strcat('..\buttons\', buttons.data(matching_index).filename));
    imshow(image1);
    subplot(1,2,2)
    image2 = imread(strcat('..\buttons\', buttons.data(highest_similarity_index).filename));
    imshow(imresize(image2, size(image1, 1:2)));
end
