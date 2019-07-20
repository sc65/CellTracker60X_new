%% get cells tracked till end
% check if cell division, cell movement data differs significantly across
% regions in a given dataset.
clearvars;
outputFiles = {'/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/outputAll.mat', ...
    '/Volumes/SAPNA/170221LiveCellImaging/outputFiles/outputAll.mat'} ;
coloniesToKeep = {[2:7], [1:6]};

%%
regionBounds = {[0 77.2 194.73 400], [0 54 160 400]};% different density domains in
%dataset2:low density dataset

results1 = cell(1,numel(outputFiles));

for ii = 2
    outputFile = outputFiles{ii};
    colonyIds = coloniesToKeep{ii};
    regionBounds1 = regionBounds{ii};
    [testMatrix, pMatrix] = compareRegionsInOneDataSet(outputFile, colonyIds, regionBounds1); 
    results1{ii} = {testMatrix, pMatrix};
end

%% represent kstest2 results as a heatmap. 
% start with one dataset, one result.
titles = {'daughter cells distribution', 'distance moved', 'displacement', 'radial displacement', 'angular displacement'};
tickLabels = {'Outer', 'Middle', 'Inner'};

dataset = 2;
figure;
for ii = 1:5
    subplot(2,3,ii);
    imagesc(datasetchk2{ii});
   
    if ii == 1
        title(['Dataset' int2str(dataset) ' ' titles{ii}]);
    else
    title(titles{ii});
    end
    ax = gca;
    ax.XTick = 1:3;
    ax.YTick = 1:3;
    ax.XTickLabel = tickLabels;
    ax.YTickLabel = tickLabels;
    ax.FontSize = 14; ax.FontWeight = 'bold';
end
    
%% save kstest2 matrix, pMatrix in an output file.
newOutputFile = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/comparingRegionsWithinOldNewData.mat';
save(newOutputFile, 'outputFiles', 'results');

