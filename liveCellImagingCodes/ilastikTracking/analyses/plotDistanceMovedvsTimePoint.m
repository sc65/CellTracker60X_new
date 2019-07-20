function plotDistanceMovedvsTimePoint(outputFile, colonyIds)


load(outputFile, 'allColoniesCellStats', 'colonyCenters', 'timeSteps', 'umToPixel');
[cellIdsTend, cellIdsTstart, colonyIdsCellsTend] =  matchParentCellsWithKidCells(allColoniesCellStats, timeSteps);
%%
cellsToKeep = ismember(colonyIdsCellsTend, colonyIds);
if exist('cellIds', 'var')
    cellsToKeep = ismember(cellIdsTstart, cellIds);
end
cellIdsTend = cellIdsTend(cellsToKeep);
cellIdsTstart = cellIdsTstart(cellsToKeep);
colonyIdsCellsTend = colonyIdsCellsTend(cellsToKeep);

%% ----------------- extract cells in region1: near the colony edges
% startDistance, endDistance refer to distance of cells from the center of the colony 
% at the start and end of tracking period.

[startDistance, ~] = findRadialDisplacement(colonyCenters, allColoniesCellStats, colonyIdsCellsTend, cellIdsTstart, cellIdsTend);
startDistance = startDistance./umToPixel;

colonyRadius = zeros(1, numel(cellIdsTend));
colonyRadius(colonyIdsCellsTend<8) = 400;
colonyRadius(colonyIdsCellsTend>=8) = 500;

startDistanceEdge = colonyRadius'-startDistance; % distance of cells from colony edge at the start of imaging session.
%cellsRegion1 = cellIdsTend(startDistanceEdge<75);
cellsRegion1 = cellIdsTend;

vMean = zeros(1,numel(cellsRegion1));
xValues = 20+ [1:164]./6;

counter = 1;
for ii = cellsRegion1
    [~, ~, xy(:,:,counter)] =  findDistanceMovedByACell(allColoniesCellStats, ii);
    counter = counter+1;
end

%% ------ plot distance moved per timepoint

jump = 6;
xValues = xValues([1:jump:timeSteps]);
xValues = xValues(2:end);
%%
figure; hold on;
for ii = 1:numel(cellsRegion1)
    distanceMoved = sqrt(sum(abs(diff(xy([1:jump:timeSteps],:,ii))).^2, 2));
    vMean(1,ii) = mean(distanceMoved);
   
    subplot(12,12,ii);
    plot(xValues, distanceMoved);
    ylim([0 20]);
end
 %% ------- histogram of speed (um/h)
 figure; 
 h = histogram(vMean, 'Normalization', 'Probability');
 h.FaceColor = [0.6 0 0];
 xlabel('Speed (\mum/h)');
 ylabel('Fraction of cells');
 ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';
 
    
    