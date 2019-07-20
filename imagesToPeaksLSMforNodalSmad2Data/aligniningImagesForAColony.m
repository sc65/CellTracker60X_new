%%

load('output.mat');
% a comprehensive code to align all images for a given colony.

image_coordinates = [8:10; 18:20];
new_filename = 'Colony19.tif';

images_path = imagesDirectory;
outputfile = '/Volumes/SAPNA/161911_FISHFinalProtocol/t42_q3_q4/FV10__20161118_204311/output.mat';
load(outputfile);

images_in_row = cell(1,2);
overlap12 = zeros(1,2);

for timepoint = 1
    %%Aligning images horizontally.
    for ii=1:2 %iterating over rows. 
        column_values = image_coordinates(ii, 1:2);
        if timepoint==1
           [images_in_row{ii}, overlap1(ii)] = horizontalAlignmentImages(images_path, outputfile, column_values, timepoint);
        else
            [images_in_row{ii}, ~] = horizontalAlignmentImages(images_path, outputfile, column_values, timepoint, overlap1(ii));
        end
    end
   
    %intermediate step - only for colony2.
    for ii = 1:2
        img1 = images_in_row{ii};
        
        img2_position = image_coordinates(ii,3);
        img2path = [images_path sprintf('/Track%04d/Image%04d', img2_position, img2_position), sprintf('_%02d.oif', timepoint)];
        img2reader = bfGetReader(img2path);
        
        img2 = MakeMaxZmovies(img2reader,1:3, 1);
        img2 = img2 - background_image;
        
        
        
        if timepoint==1
           [images_in_row{ii}, overlap12(ii)] = align2ImagesHorizontally(img1, img2);
        else
            [images_in_row{ii}, ~] = align2ImagesHorizontally(img1, img2, overlap12(ii));
        end
    end
    %%
    
    %%Aligning the horizontally aligned images vertically. 
    if timepoint==1
        [colony_image_maxz, overlap2] = verticalAlignmentImages(images_in_row{1}, images_in_row{2});
    else
        [colony_image_maxz, ~] = verticalAlignmentImages(images_in_row{1}, images_in_row{2}, overlap2); %applying same overlap to all images. 
    end
    colony_image_maxz  = colony_image_maxz(:,:,[2 1 3]); % [RFP betaCatenin bf]
%%
   colony_image_maxz = colony_image_maxz(100:1499, 750:2149,:);
    %save in a new multi tiff file. 
    if timepoint == 1
        imwrite(colony_image_maxz, new_filename, 'Compression','none'); 
    else
    
    imwrite(colony_image_maxz, new_filename, 'writemode', 'append', 'Compression','none'); 
    end
    
end
toc;
