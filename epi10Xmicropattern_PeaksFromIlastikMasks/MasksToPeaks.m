
function [peaks, imgfiles] = MasksToPeaks(nuclear_mask, cytoplasmic_mask, dapi_image, mm_format_folder, files, x_pos, y_pos)
%% returns the peaks and imgfiles array for an image.
% use this function, if making plate later. 
%--------------------------------------------------
cell_stats = regionprops(nuclear_mask, 'Centroid', 'Area', 'PixelIdxList');

if numel(cell_stats) >0
    channels = numel(files.chan)-1; %number of channels other than DAPI.
    
    channel_order = files.chan;
    columns_in_peaks = 5+2*channels;
    
    peaks = zeros(numel(cell_stats), columns_in_peaks);
    
    peaks(:,1:2) = cat(1,cell_stats.Centroid);
    peaks(:,3) = [cell_stats.Area]';
    peaks(:,4) = -1;
    
    dapi_intensity = regionprops(nuclear_mask, dapi_image, 'MeanIntensity');
    peaks(:,5) = [dapi_intensity.MeanIntensity]';
    
    column_to_add = 6; % the index of column in peaks where the nuclear intensity of I channel is stored.
    
    for ii = 1:channels
        image_path= strcat(mm_format_folder, filesep, files.prefix,'Pos', sprintf('_%03d_%03d', x_pos, y_pos), filesep,'img_000000000_', channel_order{ii+1}, '_000.tif');
        raw_image = imread(image_path);
        clean_image = SmoothAndBackgroundSubtractOneImage(raw_image);
        
        
        nuclear_intensity = regionprops(nuclear_mask, clean_image, 'MeanIntensity');
        peaks(:,column_to_add) = [nuclear_intensity.MeanIntensity]';
        column_to_add = column_to_add+1;
        
        cytoplasmic_intensity = regionprops(cytoplasmic_mask, clean_image, 'MeanIntensity');
        peaks(:,column_to_add) = [cytoplasmic_intensity.MeanIntensity]';
        column_to_add = column_to_add+1;
    end
    
    imgfiles.compressNucMask = compressBinaryImg(cat(1,cell_stats.PixelIdxList), size(nuclear_mask));
    
else
    peaks = [];
    imgfiles.compressNucMask = [];
end
imgfiles.nucfile = mkMMfilename(files, x_pos, y_pos, [], [], 1); %add some strings in imgfiles order to prevent the function peaks to colonies from crashing. 
imgfiles.errorstr = imgfiles.nucfile;

for jj = 2:length(files.chan)
    imgfiles.smadfile{jj-1} = mkMMfilename(files,x_pos,y_pos,[], [],jj);
end
end

