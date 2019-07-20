%%
% save the colony morphologies at the beginning of the imaging.

newFilePath = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/colonyMorphology@tend';
mkdir(newFilePath);

timePoint = 165;

for ii = 1:10
    im1 = imread(['Track' int2str(ii) 'ch2.tif'], timePoint); %read only the first time point.
    %figure; imshow(im1,[]);
    %title(['Track' int2str(ii)]);
    %hold on;
    %plot(centers{ii}(1), centers{ii}(2), 'r.');
    newFileFullPath = [newFilePath filesep 'Track' int2str(ii) 'ch2_tend.tif'];
    imwrite(im1, newFileFullPath);
end

%%
% save information about the centers of the colony in respective output
% files.
centers = {[354, 371], [366, 375], [358, 385], [364, 373], [358, 379], [360, 365]}; 
%got these from matlab images - roughly correspond to the centers of
%colony.

for ii = 1:6
    colonyCenter = centers{ii};
    outputFilePath = ['/Volumes/SAPNA/170221LiveCellImaging/outputFiles/outputTrack' int2str(ii) '.mat'];
    save(outputFilePath, 'colonyCenter', '-append');
end

%%
ii = 1;
outputFilePath = ['/Volumes/SAPNA/170221LiveCellImaging/outputFiles/outputTrack' int2str(ii) '.mat'];
load(outputFilePath, 'allCellStats', 'colonyCenter');

allXY = allCellStats(:,1:2);
allDists = sqrt((allXY(:,1)-colonyCenter(1)).^2 + (allXY(:,2) - colonyCenter(2)).^2);

newColumn = size(allCellStats,2) + 1;
allCellStats(:,newColumn) = allDists;
























