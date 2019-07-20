function plotCellStatistics(allCellStats, colonyMask, goodCells, umToPxl, plotnum)
%% plot some statistics on cell movement.
% 1) Velocity
% 2) Radial Velocity
% 3) Angular Velocity
%% 1) Velocity
xStart = cellfun(@(x)(x(1,1)), allCellStats);
xEnd = cellfun(@(x)(x(end,1)), allCellStats);

yStart = cellfun(@(x)(x(1,2)), allCellStats);
yEnd = cellfun(@(x)(x(end,2)), allCellStats);

timeSteps = cellfun(@(x)(x(1,5)-x(1,4) + 1), allCellStats);
timeInHrs = timeSteps*10/60;

xStart = xStart'; xEnd = xEnd'; yStart = yStart'; yEnd = yEnd'; timeInHrs = timeInHrs'; %column vectors are more clear.

displacement = sqrt((xEnd-xStart).^2 + (yEnd - yStart).^2);
displacement = displacement./umToPxl;

velocity = displacement./timeInHrs;
%% 2) Radial Velocity.
% Radial Displacement - distance from the center at last timePoint-
% distance from Center at first timePoint.

stats = regionprops(colonyMask, 'Centroid');
colonyCenter = [stats.Centroid];

startDistance = sqrt((yStart - colonyCenter(2)).^2 + (xStart - colonyCenter(1)).^2);
startDistance = startDistance/umToPxl;

endDistance = sqrt((yEnd - colonyCenter(2)).^2 + (xEnd - colonyCenter(1)).^2);
endDistance = endDistance./umToPxl;

radialDisplacement = endDistance-startDistance;

radialVelocity = radialDisplacement./timeInHrs; %uM/hr
%% 3) Angular velocity ---- theta/hr.
startTheta = atan2d(yStart - colonyCenter(1), xStart - colonyCenter(2));
startTheta(startTheta<0) = 360+startTheta(startTheta<0); %convert angles in the range [0-360].

endTheta = atan2d(yEnd-colonyCenter(1), yStart-colonyCenter(2));
endTheta(endTheta<0) = 360+endTheta(endTheta<0);

angleFromTheCenter = [startTheta endTheta];
angularDisplacement = endTheta-startTheta;

from4to1 = find(angleFromTheCenter(:,1)>270 & angleFromTheCenter(:,2)<90); % if the cell moves from Quadrant IV to Quadrant I.
angularDisplacement(from4to1) = 360-angleFromTheCenter(from4to1,1) + angleFromTheCenter(from4to1,2);

angularVelocity = angularDisplacement./timeInHrs;
%%
% Scatter Plots
%1) Does the displacement - radial, angular or total, correlate with the start position?
%2) Does the radial position - start or end correlate with change in b-cat
%levels?

lineageIds = cellfun(@(x)(x(1,3)), allCellStats);

if plotnum == 1
    yData = [endDistance, displacement, radialDisplacement, angularDisplacement, velocity, radialVelocity, angularVelocity];
    xLabels = {'EndDistance', 'displacement', 'radialDisplacement', 'angularDisplacement', 'velocity', 'radialVelocity', 'angularVelocity'};
    
    xData = endDistance;
    
    toPlot = 2:5;
    yData = yData(:,toPlot);
    xLabels = xLabels(toPlot);
    
    figure;
    hold on;
    for ii = 1:size(yData,2)
        subplot(1,size(yData,2),ii);
        plot(xData, yData(:,ii), 'b.', 'MarkerSize', 14);
        
        for jj = 1:size(yData,1)
            text(xData(jj,1), yData(jj,ii), int2str(lineageIds(jj)), 'Color', 'k', 'FontSize', 10);
        end
        
        xlabel('Distance from the center at t0');
        ylabel(xLabels{ii});
        ax = gca; ax.FontSize = 12; ax.FontWeight = 'Bold';
    end
    hold off;
    
end

%% Does the ending position affect the number of times a cell divides? Do the cells that end up in the high density region divide more often?
if plotnum == 2
    lineageIds = unique(lineageIds);
    nDivision = zeros(numel(lineageIds),1); % number of times a particular cell divides
    
    [~, idx, ~] = intersect(goodCells, lineageIds);
    nDivision(1:numel(idx)-1,1) = (diff(idx)-1)/2;
    nDivision(nDivision == 3) = 2;
    nDivision(numel(lineageIds),1) = numel(goodCells) - idx(end);
    
    startDistanceParentCell = startDistance(idx);
    endDistanceDaughterCell = endDistance(idx+nDivision);
    xData = [startDistanceParentCell endDistanceDaughterCell];
    xLabels = {'Distance from the center at t0', 'Distance from the center at tEnd'};
    yData = nDivision;
    
    figure;
    hold on;
    for ii = 1:size(xData,2)
        subplot(1,2,ii);
        plot(xData(:,ii), yData, 'b.', 'MarkerSize', 14);
        
        for jj = 1:size(xData,1)
            text(xData(jj,ii), yData(jj,1), int2str(lineageIds(jj)), 'Color', 'k', 'FontSize', 10);
        end
        
        ylabel('No. of cell divisions');
        xlabel(xLabels{ii});
        ax = gca; ax.FontSize = 12; ax.FontWeight = 'Bold';
    end
    hold off;
    
end


























