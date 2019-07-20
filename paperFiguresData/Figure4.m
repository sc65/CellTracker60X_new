
%% Figure 4

outputFile = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/outputAll.mat';
load(outputFile)
%%

outputFile = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/finalFateData/output.mat';
load(outputFile);
%%
goodColonies = [2:7];
peaks1 = peaks1(goodColonies);

%%
binSize = 100; %in pixels
rollSize = 50;
dapiNorm = 0;
umToPixel = 1.6;
column = 7;
ncolumn = 5;
tooHigh = [3e3, 8e3,8e3];


for ii = 1:numel(peaks1)
    [coloniesRA1(ii,:), ~, dmax]=radialAverageFromPeaksOneColony(peaks1, ii,column,ncolumn,binSize, rollSize, dapiNorm); %BRA
    [coloniesRA2(ii,:), ~, dmax]=radialAverageFromPeaksOneColony(peaks1, ii,column+1,ncolumn,binSize, rollSize, dapiNorm); %CDX2
end
%%
xlimit = dmax/umToPixel; 
xstart = binSize/(2*umToPixel);
xValues = linspace(xstart,xlimit, numel(coloniesRA{ii}));
%%
figure; plot(xValues, coloniesRA2(3,:));
%%
Fig4A.cellMovementStats = allColoniesCellStats;
Fig4C.radialAverage.cdx2 = coloniesRA2;
Fig4C.radialAverage.brachyury = coloniesRA1;
Fig4C.radialAverage.xValues = xValues;
%%
saveInFile ='/Volumes/sapnaDrive2/190713_FiguresData/Figure4.mat';
save(saveInFile, 'Fig4A', 'Fig4C');