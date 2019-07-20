%%  check if cell division, cell movement data in the two datasets differ significantly.
outputFiles = {'/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/outputAll.mat', ...
    '/Volumes/SAPNA/170221LiveCellImaging/outputFiles/outputAll.mat'} ;
coloniesToKeep = {[2:7], [1:6]};
regionBounds = {[0 77.2 194.73 400], [0 54 160 400]};% different density domains in
%dataset2:low density dataset
%%
[testMatrix, pMatrix] = compareRegionsAcrossTwoDataSets(outputFiles, coloniesToKeep, regionBounds);
%%
%% represent kstest2 results as a heatmap. 
% start with one dataset, one result.
titles = {'daughter cells distribution', 'distance moved', 'displacement', 'radial displacement', 'angular displacement'};
tickLabels = {'Outer', 'Middle', 'Inner'};


figure;
for ii = 1:5
    subplot(2,3,ii);
    imagesc(testMatrix{ii});
   
    
    title(titles{ii});
    ax = gca;
    ax.XTick = 1:3;
    ax.YTick = [];
    ax.XTickLabel = tickLabels;
    %ax.YTickLabel = tickLabels;
    ax.FontSize = 14; ax.FontWeight = 'bold';
end
%%
newOutputFile = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/comparingRegionsAcrossOldNewData.mat';
save(newOutputFile, 'outputFiles', 'testMatrix', 'pMatrix');
%%
clearvars;
newOutputFile = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/comparingRegionsWithinOldNewData.mat';
load(newOutputFile);






