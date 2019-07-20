function [distance, displacement, radialDisplacement, angularDisplacement, startDistanceEdge, endDistanceEdge] = makeDisplacementHistograms(outputFile, colonyIds, plotnum, cellIds)
%% statistical analyses
%% ----- Inputs-----------
% outputFile: File containing cell information from all colonies.
% colonyIds: colonies for which analyses needs to be done.
% cellIds: If you want data only for specific cells. 
%% ---------------------------------------------------
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
%% 1) Displacement
displacement = findDisplacement(allColoniesCellStats, cellIdsTend, cellIdsTstart);
timeInHrs = timeSteps*10/60;

timeInHrs = timeInHrs'; %column vectors are more clear.
displacement = displacement./umToPixel;
mean(displacement)

velocity = displacement/timeInHrs; %uM/hr
mean(velocity)
%% 2) Radial Displacement
% startDistance, endDistance refer to distance of cells from the center of the colony 
% at the start and end of tracking period.

[startDistance, endDistance] = findRadialDisplacement(colonyCenters, allColoniesCellStats, colonyIdsCellsTend, cellIdsTstart, cellIdsTend);
endDistance = endDistance./umToPixel;
startDistance = startDistance./umToPixel;
radialDisplacement = endDistance-startDistance;
radialVelocity = radialDisplacement./timeInHrs; %uM/hr

colonyRadius = zeros(1, numel(cellIdsTend));
colonyRadius(colonyIdsCellsTend<8) = 400;
colonyRadius(colonyIdsCellsTend>=8) = 500;
startDistanceEdge = colonyRadius'-startDistance; % distance of cells from colony edge at the start of imaging session.
endDistanceEdge = colonyRadius'-endDistance;
%% 3) Angular Displacement
angularDisplacement =  findAngularDisplacement(colonyCenters, allColoniesCellStats, cellIdsTstart, cellIdsTend, colonyIdsCellsTend);
angularDisplacement = deg2rad(angularDisplacement).*startDistance; % Distance moved along the arc is a better measure of how far the cells move.
angularVelocity = angularDisplacement./timeInHrs; %uM/hr

%% 4) Distance Moved
counter = 1;
distance = zeros(length(cellIdsTend),1);
cellLineageTreeIds = cell(length(cellIdsTend),1);
for ii = cellIdsTend
    [distance(counter), cellLineageTreeIds{counter}] = findDistanceMovedByACell(allColoniesCellStats, ii);
    counter = counter+1;
end
distance = distance./umToPixel;
mean(distance)
%%
if plotnum == 1
    data = [displacement, radialDisplacement, angularDisplacement, distance];
    binWidths = [15, 20, 20, 20];
    ylimits = [0.5, 0.5, 0.5, 0.5];
    
        
    toPlot = 4;
    
    labels = {'Displacement (\mum)', 'Radial Displacement(\mum)', 'angularDisplacement', 'distance (\mum)', 'velocity', 'radialVelocity', 'angularVelocity'};
 
    for ii = toPlot
        figure;
        histogram(data(:,ii), 'BinWidth', binWidths(ii), 'Normalization', 'Probability', 'FaceColor', [0.5 0 0]);
        xlabel(labels{ii});
        ylabel('Fraction of cells');
        ax = gca; ax.FontSize = 14; ax.FontWeight = 'Bold';
    end
    
end
%%
if plotnum == 2
    yData = [displacement, radialDisplacement, angularDisplacement, distance, velocity, radialVelocity, angularVelocity];
    yData = yData./timeSteps; % compare per time step response of two datasets.
    yLabels = {'Displacement (\mum)', 'Radial Displacement(\mum)', 'Angular Displacement(\mum)', 'Distance (\mum)', 'velocity', 'radialVelocity', 'angularVelocity'};
    yLimits = {[0 140]./165, [-150 150]./165, [-120 120]./165, [150 500]./165};
    
    %xData = startDistance;
    xData = startDistance;
    
    if sum(ismember(colonyIds, 3))
        xData = 400-xData;
    else
        xData = 500-xData;
    end
    
    toPlot = [1:4];
    yData = yData(:,toPlot);
    yLabels = yLabels(toPlot);
    
    figure;
    hold on;
    for ii = 1:size(yData,2)
        subplot(1,size(yData,2),ii);
        plot(xData, yData(:,ii), '.', 'Color', [0.5 0 0], 'MarkerSize', 25);
        hold on;
        plot([54 54], [yLimits{ii}], 'k:', 'LineWidth', 2); % Separating outer region
        plot([160 160], [yLimits{ii}], 'k:', 'LineWidth', 2); % Separating middle and inner regions.
        
%                 for jj = 1:size(yData,1)
%                     text(xData(jj,1)+5, yData(jj,ii), int2str(colonyIdsCellsTend(jj)), 'Color', 'k', 'FontSize', 10);
%                 end
        
        xlabel('Distance from the edge at t0 (\mum)');
        ylabel(yLabels{ii});
        ylim(yLimits{ii});
        ax = gca; ax.FontSize = 12; ax.FontWeight = 'Bold';
    end
    hold off;
    
    
    % scatter plot radial displacement vs angular displacement color coded
    % by distance from edge at t0.
%      figure;
%      scatter(abs(yData(:,2)), abs(yData(:,3)), 50, xData, 'filled');
%      xlim([0 120]);
%      ylim([0 120]);
%    % plot(abs(yData(:,2)), abs(yData(:,3)), '.', 'Color', [0.5 0 0], 'MarkerSize', 25);
%     xlabel('Radial Displacement (\mum)');
%     ylabel('Angular Displacement (degrees)');
%     ax = gca; ax.FontSize = 12; ax.FontWeight = 'Bold';    
%     
    % plot distance vs displacement
    figure;
     scatter(abs(yData(:,4)), abs(yData(:,1)), 50, xData, 'filled');
     %plot(abs(yData(:,4)), abs(yData(:,1)), '.', 'Color', [0.5 0 0], 'MarkerSize', 25);
     xlabel('distance (\mum)');
     ylabel('displacement (\mum)');
    
    ax = gca; ax.FontSize = 12; ax.FontWeight = 'Bold';    
end

%% 4) Cell Division Information -
% a) Barplot :- No. of cells vs No. of divisions.
% b) Scatter Plot :- No. of divisions vs Distance from the center at t0.
% c) Scatter Plot :- No. of divisions vs displacement of cells.

endDistanceEdge = 400-endDistance;
startDistanceEdge = endDistanceEdge;
if plotnum == 3
    separateRegions = 1; %to separate cell division information for outer, middle and inner regions
   plotCellDivisionInfo(allColoniesCellStats, cellIdsTstart,cellLineageTreeIds, startDistanceEdge, timeSteps, separateRegions)
end




