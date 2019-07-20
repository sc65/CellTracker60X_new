%% 4) Plot Trajectory Gallery.
for colonyId = 5
    for jj = 1:2
        outputFilePath = ['/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/outputColony' ...
            int2str(colonyId) '_' int2str(jj) '.mat'];
        load(outputFilePath);
        plotTrajectoryGallery(allCellStats); % Do the cells move around a lot?
        title(['Colony' int2str(colonyId) ' Part:' int2str(jj)]);
    end
end
%%
plotnum = 1;
colonyId = 9;
suffix = {'_1', '_2'};
colonyFigure = [1 0];

for ii = 1:2
    colonyImagePath = ['/Volumes/SAPNA/170325LivecellImagingSession1_8_5/colonyMorphology@tend/Track' int2str(colonyId) 'ch2_tend.tif'];
    outputFilePath = ['/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/outputColony' int2str(colonyId) suffix{ii} '.mat'];
    plotTrajectoriesOnColony(colonyImagePath, outputFilePath, plotnum, colonyFigure(ii));
    title(['Track' int2str(colonyId)]);
end
%% Scatter Plots
plotCellStatistics(allCellStats, colonyMask, goodCells, umToPixel, 2);
