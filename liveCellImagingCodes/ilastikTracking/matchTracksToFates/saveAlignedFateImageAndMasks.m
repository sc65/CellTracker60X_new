%%

%%
% make two peaks array:
% -> one with information for tracked cells, one with information for all cells
%%
% channel order multi-channel images:- [DAPI, Venus, T, CDX2].
% peaks columns - [x y Area -1 DAPI nucVenus nucT, nucCDX2]
rawImagesFolder = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/finalFateData/allChannelImages';
rawImages = dir([rawImagesFolder filesep 'fate*.tif']);

masks1Folder = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/finalFateData/dapi';
masks1 = dir([masks1Folder filesep '*.h5']);

masks2Folder = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/finalFateData/venus';
masks2 = dir([masks2Folder filesep '*.h5']);
%%
ch = 1:4;
peaks1 = cell(1, numel(rawImages));
peaks2 = peaks1; % initialize.
venusMasks = peaks2;
dapiMasks = peaks2;

for ii = 1:numel(rawImages)
    for jj= 1:4
        image1 = imread([rawImages(ii).folder filesep rawImages(ii).name], jj);
        image1 = SmoothAndBackgroundSubtractOneImage(image1);
        
        if jj== 1
            images = zeros([size(image1), numel(ch)]);
        end
        images(:,:,jj) = image1;
    end
    
    
    objectlabel = 1;
    mask1Path = [masks1(ii).folder filesep masks1(ii).name];
    mask1 = readIlastikFile(mask1Path, objectlabel); %read the ilastik mask.
    mask1 = IlastikMaskPreprocess(mask1); %pre-process ilastik mask.
    dapiMasks{ii} = mask1;
    peaks1{ii} =  MasksToPeaks1(images, mask1);
     
    mask2Path = [masks2(ii).folder filesep masks2(ii).name];
    mask2 = readIlastikFile(mask2Path, objectlabel); %read the ilastik mask.
    mask2 = IlastikMaskPreprocess(mask2); %pre-process ilastik mask.
    venusMasks{ii} = mask2;
    peaks2{ii} =  MasksToPeaks1(images, mask2);   
end
%%
% remove those cells from peaks2 for which fate can't be determined, or
% which are merged, such that they can't be identified
save('output.mat', 'peaks1', 'peaks2', 'dapiMasks', 'rawImages', 'venusMasks');




