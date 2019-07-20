%%
tic;
clearvars
% a comprehensive code to align all images for a given colony.
images_path = '/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616';
%
image_coordinates = [1 2;6 7];
new_filename = 'Colony1.tif';

images_in_row = cell(1,2);
overlap1 = zeros(1,2);

channel_order  = [2 1]; %[RFP(2) betaCat(1)]%make the I(Red) channel with RFP cells.

for timepoint = 1:134
    %%Aligning images horizontally.
    for ii=1:2 %iterating over rows. 
        column_values = image_coordinates(ii, :);
        if timepoint==1
           [images_in_row{ii}, overlap1(ii)] = horizontalAlignmentImages(images_path, column_values(1), column_values(2), timepoint);
        else
            [images_in_row{ii}, ~] = horizontalAlignmentImages(images_path, column_values(1), column_values(2), timepoint, overlap1(ii));
        end
    end
    
    %%Aligning the horizontally aligned images vertically. 
    if timepoint==1
        [colony_image_maxz, overlap2] = verticalAlignmentImages(images_in_row{1}, images_in_row{2});
    else
        [colony_image_maxz, ~] = verticalAlignmentImages(images_in_row{1}, images_in_row{2}, overlap2); %applying same overlap to all images. 
    end
    
 
   
   % get the intensity limits corresponding to the first timepoint. 
   
    if timepoint==1
        intensity_limits = cell(1, length(channel_order));
        for jj = 1:length(channel_order)
            intensity_limits{jj} = stretchlim(colony_image_maxz(:,:,jj));
        end
    end
    
    
    % adjust contrast based on first time point. 
    ch_images = uint16(zeros(2048, 2048, 3));
    
    
    ch = 1;
    for jj = channel_order
        ch_images(:,:,ch) = imadjust(colony_image_maxz(:,:,jj),[intensity_limits{jj}(1) intensity_limits{jj}(2)], []);
        ch = ch+1;
    end
    
    
    ch_images = imresize(ch_images, 0.25);
    %save in a new multi tiff file. 
  
    if timepoint== 1
        imwrite(ch_images, new_filename, 'Compression','none'); 
    else
    
    imwrite(ch_images, new_filename, 'writemode', 'append', 'Compression','none'); 
    end
    
end
toc;
