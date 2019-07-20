%%
% reading a vsi file.
fileToRead = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/finalFateData/vsiFiles/Process_2177.vsi';
fileReader = bfGetReader(fileToRead);
channels = 1:fileReader.getSizeC;

fileToWrite = 'Colony4';
filePath = ['/Volumes/SAPNA/170325LivecellImagingSession1_8_5/finalFateData/tiffFiles' filesep fileToWrite];

zslice = 11; %one with all the cells in focus

timePoint = 1;

for ii = channels
    iplane = fileReader.getIndex(zslice-1, ii-1, timePoint-1)+1;
    image1 = bfGetPlane(fileReader, iplane);
    image1 = flip(image1,2);
    figure; imshow(image1,[]);  
    imwrite(image1, [filePath  '_' int2str(ii) '.tif']);
end

%%
% make Peaks - one cell for each colony.
nuclearMask = readIlastikFile('/Volumes/SAPNA/170325LivecellImagingSession1_8_5/finalFateData/masks/Colony4_4_Simple Segmentation.h5');
areaThreshold = 30;

cleanMask = IlastikMaskPreprocess(nuclearMask, areaThreshold);
%%
rawFileNames = {'Colony4_4.tif', 'Colony4_1.tif', 'Colony4_2.tif'};
rawFilePath = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/finalFateData/tiffFiles';

rawImages = zeros(2048, 2048, 3);

for ii = 1:length(rawFileNames)
    rawImages(:,:,ii) = imread([rawFilePath filesep rawFileNames{ii}]);
    rawImages(:,:,ii) = SmoothAndBackgroundSubtractOneImage(rawImages(:,:,ii));   
end
%%
peaks = MasksToPeaks1(rawImages, cleanMask);
%%
cdx2 = peaks(:,6)./peaks(:,5);
brachyury = peaks(:,7)./peaks(:,5);

figure; 
subplot(1,2,1);
scatter(peaks(:,1), -peaks(:,2), 50, cdx2, 'filled');
colorbar;

subplot(1,2,2);
scatter(peaks(:,1), -peaks(:,2), 50, brachyury, 'filled');
colorbar;

%%
toRemove = find(peaks(:,1) > 1800);
peaks(toRemove,:) = [];
%%
% get colony Boundary.
colonyMask = readIlastikFile('Colony4_3_Simple Segmentation.h5');
areaThreshold =5000;

colonyMask = IlastikMaskPreprocess(colonyMask, areaThreshold);
%%
figure; imshow(colonyMask);
%%
stats = regionprops(colonyMask, 'Area');
allArea = [stats.Area];

colonyMask = bwareaopen(colonyMask, max(allArea));
figure; imshow(colonyMask);
%%
b1 = bwboundaries(colonyMask);
%%
stats = regionprops(colonyMask, 'Centroid');
colonyCenter = stats.Centroid;
%%
figure; imshow(colonyMask); 
hold on;
plot(colonyCenter(1), colonyCenter(2), 'k*');
%%
save('output_4.mat', 'peaks', 'colonyMask', 'colonyCenter');
%%
figure; imshow(colonyMask);
hold on;
plot(colonyCenter(1), colonyCenter(2), 'k*');
plot(peaks(:,1), peaks(:,2), 'r*');






