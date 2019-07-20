%% images to peaks data for images taken at 30X LSM and aligned such that one file represents one colony.
%%
% make two peaks array:
%%
% channel order multi-channel images:- [DAPI, Venus, T, CDX2].
% peaks columns - [x y Area -1 DAPI nucVenus nucT, nucCDX2]
clearvars;
masterFolder = '/Volumes/SAPNA/170825_smad2_bestSeeding_Idse/LsmData_30X/alignedImages';
channels = 1:4;
%%
[files, start] = postart(masterFolder);
files(1:start-1) = [];
%%
tic;
%for ii = 3
for ii = 1:numel(files)
    ii
    rawImagesFolder = [masterFolder filesep files(ii).name];
    
    rawImages = dir([rawImagesFolder filesep '*.tif']); %aligned colony files
    masks = dir([rawImagesFolder filesep '*.h5']); %nuclear masks
    
    outputFile = [rawImagesFolder filesep 'output_' files(ii).name '.mat']; %
    %%
    peaks1 = cell(1, numel(rawImages));
    dapiMasks = peaks1;
    
    for jj = 1:numel(rawImages)
        jj
        for kk = channels
            image1 = imread([rawImages(jj).folder filesep rawImages(jj).name], kk);
            image1 = SmoothAndBackgroundSubtractOneImage(image1);
            
            if kk == 1
                images = zeros([size(image1), numel(channels)]);
            end
            images(:,:,kk) = image1;
        end
        objectlabel = 1;
        nuclearMaskPath = [masks(jj).folder filesep masks(jj).name];
        nuclearMask = readIlastikFile(nuclearMaskPath, objectlabel); %read the ilastik mask.
        nuclearMask = IlastikMaskPreprocess(nuclearMask); %pre-process ilastik mask.
        nuclearMask = imerode(nuclearMask, strel('disk', 1));
        
        
        dapiMasks{jj} = nuclearMask;
        donutSize = 2;
        [nuclearMask, cytoplasmicMask] = MakeCytoplasmicMaskDonut(nuclearMask, donutSize);
        peaks1{jj} =  MasksToPeaks1(images, nuclearMask, cytoplasmicMask);
    end
    %%
    save(outputFile, 'peaks1', 'rawImages', 'dapiMasks');
end
toc;
%%
for ii = 1:size(peaks1,2)
    plate1.colonies(ii).data = peaks1{ii};
    plate1.colonies(ii).shape = 2;
end
%%
colonyId = 1:size(peaks1,2);
plate1 = removeCellsNotInColony(outputFile, plate1, colonyId);
%%
for ii = 1:3
    peaks1{ii} = plate1.colonies(ii).data;
    plate1.colonies(ii).shape = 2;
end
%%
umToPixel = 2.32;
save(outputFile, 'peaks1', 'plate1', 'rawImages', 'dapiMasks', 'umToPixel');
%%













