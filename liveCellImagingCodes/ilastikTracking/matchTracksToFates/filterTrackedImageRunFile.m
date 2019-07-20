%%
% get the tracking image
% 1) composite image, outputFile
% 2) Remove the non-tracked cells
% 3) Highlight merged cells
% 4) Possible to watershed, easy to identify which is which in the fate
% image - go ahead.
% 5) Else, remove those cells
% 6) Match the remaining
% 7) Add fate information in the output files.

%% 1) Composite Image
close all; clearvars;

colonyId = 5;
colonyPart = 2;
trackingEndTimePoint = 165;

maskPath = ['/Volumes/SAPNA/170325LivecellImagingSession1_8_5/images/Track' int2str(colonyId) 'ch1_Simple Segmentation.h5'];
trackedImage  = readIlastikFile(maskPath);
trackedImage = trackedImage(:,:,trackingEndTimePoint);
trackedImage = IlastikMaskPreprocess(trackedImage,20);
figure; imshow(trackedImage);
%%
% tracked cells information
outputFile = ['/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/outputColony'...
    int2str(colonyId) '_' int2str(colonyPart) '.mat'];
load(outputFile);
%%

[filteredImage, ~, falseObjectsInCellStats] = filterTrackedImage(trackedImage, allCellStats);
%% remove false positives from the cell stats data.
removeFalsePositives(allCellStats, goodCells, outputFile, falseObjectsInCellStats);

%% remove the cells that can't be tracked correctly - merged cells that can't be separated, false positives.
% 1) Tracked Image
trackingEndTimePoint = 165;
[cellsPresentAtEndTimePoint, xy1] = getIdAndPositionOfCellsTrackedTillEnd(allCellStats, trackingEndTimePoint);
%%
figure; imshow(trackedImage); hold on;
plot(xy1(:,1), xy1(:,2), 'b*');
for ii = 1:size(xy1,1)
    text(xy1(ii, 1)+5, xy1(ii, 2), int2str((ii)), 'FontSize', 12, 'Color', [0 0.8 0], 'FontWeight', 'bold');
end
title('trackedImage');
%%
toRemove = [5];
xy1([toRemove],:) = []; %remove troublesome cells
cellsPresentAtEndTimePoint(toRemove) =[];

%% -------------------------Fate Image-------------------------

%% get the similar part - top/bottom (1/2) from fate image
fateOutputFile = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/finalFateData/output.mat';
load(fateOutputFile);
%%
fateData =peaks2{colonyId};
fateImage1 = venusMasks{colonyId};

colonyPart = 2; %1 - above colonyCenter2; 2 - below colonyCenter2.
colonyCenter2 = [1024 1395]; % dividing point.
fateImage1 = getPartFateImage(fateImage1, colonyCenter2, colonyPart);

fateImage1 = imerode(fateImage1, strel('disk',1));
figure; imshow(fateImage1); hold on;
stats1 = regionprops(fateImage1, 'Centroid');
xy2 = cat(1, stats1.Centroid);
plot(xy2(:,1), xy2(:,2), 'b*');
for ii = 1:size(xy2,1)
    text(xy2(ii, 1)+10, xy2(ii, 2), int2str((ii)), 'FontSize', 20, 'Color', [0 0.8 0], 'FontWeight', 'bold');
end
title('fateImage');
%%
% toKeep = [2 3 6:16];
% toRemove = setxor(1:size(xy2,1), toKeep);

toRemove = [14];
 %remove troublesome objects
fateImage1 = bwlabel(fateImage1);
fateImage1(ismember(fateImage1, toRemove)) = 0; 
fateImage1 = imbinarize(fateImage1);
%%
figure; imshow(fateImage1); hold on;
stats1 = regionprops(fateImage1, 'Centroid');
xy2 = cat(1, stats1.Centroid);
plot(xy2(:,1), xy2(:,2), 'b*');
for ii = 1:size(xy2,1)
    text(xy2(ii, 1)+5, xy2(ii, 2), int2str((ii)), 'FontSize', 20, 'Color', [0 0.7 0], 'FontWeight', 'bold');
end
title('fateImage');
%%

%% ------------------------Match--------------------------
umToPixel1 = 0.80; %LSM 10X - Live cell imaging
umToPixel2 = 2.4; %LSM 30X - 
matchId  = matchCellTracksToFates(filteredImage, xy1, umToPixel1, xy2, umToPixel2);
%%
% given match id, xy2, extract fate information from peaks2
xy3 = fateData(:,1:2);
% due to image processing on fateImage, it is possible that xy3 has
% slightly different centroids. But the difference should not be very high.

dists = distmat(xy2, xy3);
[~, matchInFateData] = min(dists,[], 2);

matchId2 = matchInFateData([matchId]);
intensityInfo = fateData([matchId2'], 5:8);

matchedCellsfateData= [(cellsPresentAtEndTimePoint)', intensityInfo];
%%
x1 = cellfun(@(x)(x(end,1)), allCellStats((cellsPresentAtEndTimePoint)));
y1 = cellfun(@(x)(x(end,2)), allCellStats((cellsPresentAtEndTimePoint)));
figure; scatter(x1', -y1', 50, matchedCellsfateData(:,5)./matchedCellsfateData(:,3), 'filled'); 
%--CDX2/Venus levels - check if this makes sense!
%%
save(outputFile, 'matchedCellsfateData', '-append');






