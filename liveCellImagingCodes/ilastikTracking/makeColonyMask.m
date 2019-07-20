function makeColonyMask(colonySegmentationMaskPath, outputFilePath)
%% ------- saves colonyMask in a separate output file --------- 
% ----colonySegmentationMaskPath - path to ilastik segmentation mask
% corresponnding to full colony.
% ---- newOutputFilePath - path to the outputFile to save colonyMask

colonyMask = readIlastikFile(colonySegmentationMaskPath);
figure; imshow(colonyMask);

stats = regionprops(colonyMask, 'Area');
allAreas = [stats.Area];


colonyMask = bwareaopen(colonyMask, max(allAreas)-1);
colonyMask = imfill(colonyMask, 'holes');
figure; imshow(colonyMask);

save(outputFilePath, 'colonyMask');
