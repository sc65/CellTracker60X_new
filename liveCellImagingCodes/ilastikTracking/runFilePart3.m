%% run this after tracking all colonies.
%% add colony centers information in the output file
outputFiles = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles';
colonyCenters = {[387 567], [375 577], [416 596], [419 603], [430 517], ...
    [405 467], [425 579], [422 535], [432 495]};

for ii = 2:10
    oneOutputFile = [outputFiles filesep 'outputColony' int2str(ii) '_1.mat'];
    load(oneOutputFile);
    colonyCenter = colonyCenters{ii-1};
    save(oneOutputFile, 'colonyCenter', '-append');
end
%% add distance from colony center as the sixth column
trackIds = 2:10;
addDistanceFromColonyCenter (outputFiles, trackIds);
%% one output file with all data
reorderAndCombineOutputFromALLColonies(outputFiles);
%% start analyses
outputFile = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/outputAll.mat';
load(outputFile)
%%
load(outputFile);
timeSteps = 165;
save(outputFile, 'timeSteps', '-append');
%%
%outputFile =
%'/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/outputAll.mat';
%----------------New
%load(outputFile);
outputFile = '/Volumes/SAPNA/170221LiveCellImaging/outputFiles/outputAll.mat'; %----------------Old
%%
%colonyIds = [2:7];
colonyIds = 1:6;
for plotnum = 3
    distance = makeDisplacementHistograms(outputFile, colonyIds, plotnum);
end
%%
saveInPath = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/results/cellDivision';
saveAllOpenFigures(saveInPath);
%%
plotDistanceMovedvsTimePoint(outputFile, colonyIds)












