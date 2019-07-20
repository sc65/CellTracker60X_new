%% make trajectories of all 71 cells, grouped by the distance from the center at the starting point.
regions = [0 180 320 400]; % Bounds (in microns) to separate different regions.

masterFolderPath = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5';
outputFile1 = [masterFolderPath filesep 'outputFiles/outputall.mat'];
load(outputFile1);


[cellIdsTend, cellIdsTstart, colonyIdsCellsTend] =  matchParentCellsWithKidCells(allColoniesCellStats, timeSteps);
%returns the parent cell Ids for all cells tracked till end.

[startDistance, ~] = findRadialDisplacement(colonyCenters, allColoniesCellStats, colonyIdsCellsTend, cellIdsTstart);
startDistance = startDistance./umToPixel;

allColonyIds = cellfun(@(x)(x(1,3)), allColoniesCellStats(cellIdsTstart));
allLineageIds = cellfun(@(x)(x(1,4)), allColoniesCellStats(cellIdsTstart));
%%
% filter cells in one colony.
% start analysing cells in the inner and outer region of each colony.

for colonyId = 2
    %cellsInColony = 1:150;
    cellsInColony = find(allColonyIds == colonyId);
    %%
    for ii = 2
        cellsInRegion = find(startDistance(cellsInColony) > regions(ii) & startDistance(cellsInColony) < regions(ii+1) ); %inner region
        cellIdsTstartRegion = cellIdsTstart(cellsInColony(cellsInRegion));
        
        uniqueCellIds = unique(cellIdsTstartRegion);
        uniqueCellsLineageIds = unique(allLineageIds(cellsInRegion));
        
        
         nCells = length(uniqueCellIds);
         %colors = zeros(nCells,3);
         colors = rand(nCells, 3);
         counter = 1;
%         
         figure;
         hold on;
%         
        for jj = 1:nCells
            plot(0,0, '-.', 'Color', colors(jj,:));
        end
        [~, obj] = legend(strsplit(int2str(uniqueCellsLineageIds),' '));
        set(obj, 'LineWidth', 2); %-------- get the correct legend labels.
        %%
        plotDirectionOfCellMovement(allColoniesCellStats, colonyCenters, uniqueCellIds, colors, umToPixel);
    end
end
%%
% -------plot2 - distance moved vs time.

% Does its speed changes with time? => Does the distance travelled in each
% timestep changes in time?
plotExtentOfCellMovementEachTimePoint(allColoniesCellStats, cellIds, umToPixel);
%%



























