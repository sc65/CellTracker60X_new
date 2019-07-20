function makePeaksForTiffFiles_96wellPlate(rawImagesPath, outputFilesPath, condition, dapiChannel, nChannels)
%% after getting tiff files from Idse's code and Ilastik segmentation, run this file.
% saves fluorescent data per cell per colony in the array peaks. 
% The array peaks, masks and condition information saved in output.mat
%% -------------------Inputs
% rawImagesPath - path to the folder that contains tiff files
% outputFilePath: path to the folder that saves outputFiles
% condition -  well number in the 96 well plate.
%---- refer runProcessVsiFile.m
%%----------------------------------------
%%
%% file paths, images, masks
% remove the files with just the dapi channel '_c4'
rawImages1 = dir([rawImagesPath filesep '*.tif']);
rawImages1_names = {rawImages1(:).name}; %converts structure field into cell array

dapiSuffix = ['c' int2str(dapiChannel)];
onlyDapiImages = regexp(rawImages1_names, dapiSuffix);
onlyDapiImagesPosition = ~cellfun('isempty', onlyDapiImages);

rawImages1(onlyDapiImagesPosition) = [];

%% making peaks from masks
peaks = cell(1, size(rawImages1,1));
masks = peaks;
channelOrder = [dapiChannel setxor([1:nChannels], dapiChannel)]; %start with dapi

tic;
for ii = 1:size(rawImages1,1) 
    ['Colony' int2str(ii)]
    
    image1 = imread([rawImages1(ii).folder filesep rawImages1(ii).name],channelOrder(1));
    images1 = uint16(zeros(size(image1,1), size(image1,2), numel(channelOrder)));
    images1(:,:,1) = image1;
    
    counter =2;
    for jj = channelOrder(2:end)
        images1(:,:,counter) = imread([rawImages1(ii).folder filesep rawImages1(ii).name],jj);
        images1(:,:,counter) = SmoothAndBackgroundSubtractOneImage(images1(:,:,counter));
        counter = counter+1;
    end
    
    imagePrefix = strsplit(rawImages1(ii).name, '.');
    maskName = [imagePrefix{1} '_' dapiSuffix '_Simple Segmentation.h5'];
    nuclearMask1 = readIlastikFile([rawImages1(ii).folder filesep maskName]);
    nuclearMask1 = bwareaopen(nuclearMask1, 20);
    
    donutSize = 2;
    [nuclearMask1, cytoplasmicMask1] = MakeCytoplasmicMaskDonut(nuclearMask1, donutSize);
    
    peaks1 = MasksToPeaks1(images1, nuclearMask1, cytoplasmicMask1);
    peaks{ii} = peaks1;
    masks{ii} = nuclearMask1;
end
toc;
%%
outputFile1 = [outputFilesPath filesep 'output.mat'];
Condition = ['Condition' int2str(condition)];
save(outputFile1, 'peaks', 'masks', 'Condition', 'rawImages1'); 
end