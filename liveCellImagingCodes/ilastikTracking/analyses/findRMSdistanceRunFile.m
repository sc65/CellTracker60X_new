%% plot the cell displacement trajectory of one cell tracked till the end.
% pick a colony, pick a cell - start random.
% check the displacement trajectory to make sure you're doing it right.

outputFile = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/outputAll.mat';
coloniesToKeep = 2:7; % select for colonies with radius 800um.
%%
load(outputFile);
[cellIdsTend, cellIdsTstart, colonyIdsCellsTend] =  matchParentCellsWithKidCells(allColoniesCellStats, timeSteps);

cellsToKeep = ismember(colonyIdsCellsTend, coloniesToKeep);
if exist('cellIds', 'var')
    cellsToKeep = ismember(cellIdsTstart, cellIds);
end
cellIdsTend = cellIdsTend(cellsToKeep);
cellIdsTstart = cellIdsTstart(cellsToKeep);
colonyIdsCellsTend = colonyIdsCellsTend(cellsToKeep);

%% divide cells by region and see if the displacement metrics differ.
regionBounds = [0 77.2 194.73 400];
[startDistance, ~] = findRadialDisplacement(colonyCenters, allColoniesCellStats, colonyIdsCellsTend, cellIdsTstart);
startDistance = startDistance./umToPixel;
startDistance = 400-startDistance;%Distance of cells from the edge at t0.

%%
nRegions = numel(regionBounds) - 1;
distance = cell(nRegions,2);
displacement = distance;
radialDisplacement = distance;
%%
dt = 15;
timeIntervals = {[1 56], [57 165]};
timeIntervals = {[1 165]};

rmsDistance = cell(nRegions,1);

for ii= 1:nRegions
    cellIdsTend1 = cellIdsTend(startDistance>regionBounds(ii) & startDistance <regionBounds(ii+1));
    for jj = 1:length(timeIntervals)
        timeInterval = timeIntervals{jj};
        rmsDistance{ii,1} = findRMSdistance(allColoniesCellStats, cellIdsTend1,timeInterval, umToPixel, dt);
        [distance{ii, jj}, displacement{ii, jj}, radialDisplacement{ii, jj}] = movementOfCellsInTime(allColoniesCellStats, cellIdsTend1, colonyCenters, timeInterval, umToPixel, dt);
    end
end
%%

toPlot = {distance, displacement, radialDisplacement};
labels = {'Distance/timeStep', 'Displacement', 'RadialDisplacement/timeStep'};
yLimits = {[0.7 2.2], [0.5 1.2], [-0.5 0.3]};

toPlot = {rmsDistance};
labels = {'Root mean square Displacement(\mum)'};

for ii = 1:numel(toPlot)
    figure;
    values = toPlot{ii};
    for jj = 1:nRegions
       %values1 = values{jj};
        
        for kk = 1:length(timeIntervals)
            value1 = values{jj,kk};
            value1 = value1.^2;
            avgValue = mean(value1,2);
            stdValue = std(value1, 0, 2);
            stdError = stdValue/numel(cellIdsTend);
            
            timeInterval = timeIntervals{kk};
            xValues = timeInterval(1):dt:timeInterval(2);
            
            if xValues(end)~=timeInterval(2)
                xValues = [xValues timeInterval(2)];
            end
            
            xValues = mean([xValues(1:end-1);xValues(2:end)]);
            xValuesHrs = 20+ xValues/6;
            %each timeStep is 10 minutes long. Imaging started after 20hrs.
            
            subplot(1,3,jj);
            hold on;
            plot(xValuesHrs, avgValue, 'Color', [0.6 0 0], 'LineWidth', 4);
                    hold on;
                    errorbar(xValuesHrs, avgValue, stdValue, 'Color', [0.6 0 0], 'LineWidth', 1);
            xlabel('Time (in hrs)');
            ylabel(labels(ii));
            %ylim([yLimits{ii}(1) yLimits{ii}(2)]);
            %ylim([9.5 14]);
            %ylim([0 24]);
            title(['Region' int2str(jj)]);
            ax = gca; ax.FontSize = 12; ax.FontWeight = 'bold';
        end
        
    end
end

%%