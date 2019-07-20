
%% ------------------ 96 well plate
% a) filter colonies
% b) radial average plots
% c) colored scatter plots, overlayed for all colonies
clearvars;
rawImagesPath = '/Volumes/SAPNA/180314_96wellPlates/plate1/tiffFiles';

condition1 = 5;

control_condition = 13;
if condition1 < 108
    outputFile = [rawImagesPath filesep 'Condition' int2str(condition1)...
        filesep 'output.mat'];
else
    outputFile = [rawImagesPath filesep  'plate_2ndHalf' filesep 'Condition' int2str(condition1)...
        filesep 'output.mat'];
end
load(outputFile);
%
% control_outputFile = '/Volumes/SAPNA/171017_96wellPlateNew/controls.mat';
% load(control_outputFile);

% place = find(conditions == control_condition); % find its place in the controls.
% maxRA1 = maxRA(place,:);

%% --------------------- other datasets
% outputFile = 'output.mat';
% load(outputFile);
%% --------------------filter colonies
figure;
for ii = 1:size(peaks,2)
    subplot(5,5,ii);
    imshow(masks{ii});
    title(['Colony' int2str(ii)]);
end

%%
nCells = zeros(1, size(peaks,2));

for ii = 1:size(peaks,2)
    data = peaks{ii};
    nCells(ii) = size(data,1);
    xy = data(:,1:2);
    xy = xy-mean(xy);
    subplot(5,5,ii);
    plot(xy(:,1), xy(:,2), 'k.');
    title(['Colony' int2str(ii)]);
end
%%
figure;
plot([1:size(peaks,2)], nCells, 'k.', 'MarkerSize', 20);
%%
toCorrect = 1:size(peaks,2);
peaks = removeCellsNotInColony(peaks, toCorrect);
%%
mask1 = masks{7};
figure; imshow(mask1);
%%
toRemove = [3 9];
peaks(toRemove) = [];
rawImages1(toRemove) = [];
masks(toRemove) = [];
%% --------------------filter cells
nChannel1 = 0;
binSize = 100;
coloniesToUse = 1:size(peaks,2);
figure;

%channels = {'dapi', 'smad1', 'smad2', 'sox17'};
channels = {'dapi', 'cdx2', 'sox2', 'T'};

xLimits = [12e3, 3e3, 8e3, 8e3];
yLimits = [0.07, 0.85, 0.35, 0.8];

counter = 1;
for channel = [5 6 8 10]
    subplot(2,2, counter);
    plotHistogramOfExpressionLevelsGivenColonies (peaks, coloniesToUse, channel, nChannel1, binSize);
    xlim([0 xLimits(counter)]); ylim([0 yLimits(counter)]);  title(channels{counter}); counter = counter+1;
end

%% ------------------- check dapi expression
ch1 = 5;
figure;

for ii = coloniesToUse
    subplot(4,5,ii);
    data = peaks{ii};
    xy = data(:,1:2);
    xy = xy-mean(xy);
    cData = data(:,ch1);
    scatter(xy(:,1), xy(:,2), 20, cData, 'filled');
    colorbar; title(['Colony' int2str(ii)]);
end
%% ---------------- remove very bright dapi cells
goodColonies = 1:size(peaks,2);
columnNum= ch1;
fluorescence = 2500;

peaks = removeCellsAboveFluorescence(peaks, goodColonies, columnNum, fluorescence);
%% ---------------------run radial average functions
% 1) individual colonies
onlyCircles_radialAvergeOneColony(peaks, maxRA1);
%%
% 2) all colonies average
maxRA1 = onlyCirclesRadialAverage (peaks);
title([Condition ' n =' int2str(size(peaks,2))]);
%%
saveInPath = ['./rAPlots'];
saveAllOpenFigures(saveInPath);
%%
save(outputFile,'peaks',  'rawImages1', 'masks', 'maxRA1', '-append');
