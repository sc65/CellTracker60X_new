function [peaks, imgFiles] = ImagesToPeaks(mm_format_folder, files)
% returns peaks and image files information for images in the micro manager
% format.

number_of_images = (length(files.pos_x))*(length(files.pos_y));
peaks = cell(1, number_of_images); %pre-allocate peaks array.
imgfiles = peaks;

%for x = 4
%for y = 2
for x = 0:max(files.pos_x)
    for y = 0:max(files.pos_y)
        tic;
        x
        y
        ilastikNuclearMask = strcat(mm_format_folder, filesep, files.prefix,'Pos', sprintf('_%03d_%03d', x, y), filesep, 'img_000000000_DAPI_000_Simple Segmentation.h5');%separate individual cells.
        %ilastikobjectlabelcheck (filename);
        dapi_image_path = strcat(mm_format_folder, filesep, files.prefix,'Pos', sprintf('_%03d_%03d', x, y), filesep, 'img_000000000_DAPI_000.tif');
        dapi_image = imread(dapi_image_path);
        
        dapi_image = SmoothAndBackgroundSubtractOneImage(dapi_image);
        
        objectlabel = 1;
        mask1 = readIlastikFile(ilastikNuclearMask, objectlabel); %read the ilastik mask.
        mask1 = IlastikMaskPreprocess(mask1); %pre-process ilastik mask.
        
        nuclearMask = mask1;
        nuclearMask = bwlabel(nuclearMask);
        
        
        stats = regionprops(nuclearMask,'Area','Centroid', 'PixelIdxList');
        % remove abnormally big nuclei- false positives
        toKeep = find([stats.Area]<10000);
        if size(toKeep,2)>0
            nuclearMask = ismember(nuclearMask, toKeep);
        end
        
        
        stats = regionprops(nuclearMask,'Area','Centroid', 'PixelIdxList');
        xy = stats2xy(stats);
        [~,idx] = unique(xy, 'rows');
        duplicateIdx = setdiff(1:size(xy,1), idx);
        
        if ~isempty(duplicateIdx)
            nuclearMask(stats(duplicateIdx).PixelIdxList) = 0;
        end
        
        %nuclear_mask = correctOversegmentedNuclearMaskUsingWatershed(mask1, dapi_image);
        
        % if you have a separate colony mask to make sure the end cells do
        % not get very big cytoplasms due to voronoi,  uncomment the part
        % until cytoplasmic_mask
        
        %         ilastik_colony_cytoplasmic_mask = strcat(mm_format_folder, filesep, files.prefix,'Pos', sprintf('_%03d_%03d', x, y), filesep, 'img_000000000_DAPI_000_Probabilities.h5'); %separate colony and background.
        %         mask2 = readIlastikFile(ilastik_colony_cytoplasmic_mask, objectlabel); %read the ilastik mask.
        %         mask2 = IlastikMaskPreprocess(mask2); %pre-process ilastik mask.
        %         cytoplasmic_mask = MakeCytoplasmicMask(nuclear_mask, mask2); % if cells are too crowded, reduce the dilation parameter in this function.
        
        donutSize = 10;
        [nuclearMask, cytoplasmicMask] = MakeCytoplasmicMaskDonut(nuclearMask, donutSize);
        imageIndex = sub2ind([length(files.pos_x) length(files.pos_y)],x+1,y+1); %index appropriate for images in micro manager format.
        [peaks{imageIndex}, imgfiles{imageIndex}] = MasksToPeaks(nuclearMask, cytoplasmicMask, dapi_image, mm_format_folder, files, x, y);
        toc;
    end
end

%% correct the format of variable imgfiles - MasksToPeaks returns a cell array - I need a structure.
s = struct;
for ii = 1:length(imgfiles)
    s(ii).compressNucMask  = imgfiles{ii}.compressNucMask;
    s(ii).nucfile = imgfiles{ii}.nucfile;
    s(ii).errorstr = imgfiles{ii}.errorstr;
    s(ii).smadfile = imgfiles{ii}.smadfile;
end

imgFiles = s;
end