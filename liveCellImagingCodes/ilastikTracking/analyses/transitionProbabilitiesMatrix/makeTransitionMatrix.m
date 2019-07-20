function [transitionMatrix, cellsInRegion] = makeTransitionMatrix(allColoniesCellStats, colonyCenters, umToPixel, regionBounds, timePoints)
%% returns transition matrix(TM) for timePoints - [t1 t2].
% represents cellmovement across different regions in a matrix.
% Each value(TM(i,j)) represents the number of cells that moved from region
% i to region j.
% ---- 1) RegionBounds:  boundaries of different regions, expressed as distance from the
% edges.

%% Make transition matrix
% 1) find Cells that are present at the last time Point. (tEnd > timePoints(2))
% 2) find the lineage of cell
% 3) find their position (includes mother cell if cell divides in between) at first and last timePoint.
% 4) determine whether they stay in the same region as they start or they
% move around.
% 5) Update counter in the transition matrix accordingly

%% Using the same data, find total number of cells in a region.
nRegions = numel(regionBounds)-1;

%% 1)
cellIds = 1:numel(allColoniesCellStats);
tStart = cellfun(@(x) x(1,6), allColoniesCellStats);
tEnd = cellfun(@(x) x(1,7), allColoniesCellStats);
cellsToKeep = cellIds(tStart<timePoints(2)& tEnd>=timePoints(2)); %cells which are present in the colony in the interval [t1-t2].

%% 2)
transitionMatrix = zeros(nRegions);

for ii = cellsToKeep
    [~, cellLineageTreeIds] =  findDistanceMovedByACell(allColoniesCellStats, ii);
    %%
    if length(cellLineageTreeIds) == 1
        dists = getDistanceFromColonyCenter(allColoniesCellStats, colonyCenters, ii);
        cell_t0 = allColoniesCellStats{ii}(1,6);
        tStep = timePoints(1)-cell_t0+1; %position of cell at timePoint 1.
        distance1 = 400 - dists(tStep)/umToPixel; %distance from the edge in pixels.
        
        tStep = timePoints(2)-cell_t0+1; %position of cell at timePoint 2.
        distance2 = 400 - dists(tStep)/umToPixel; %distance from the edge in pixels.
        
    else
        % get the end position - distance from the edge at start timePoint. of the daughter cell.
        dists = getDistanceFromColonyCenter(allColoniesCellStats, colonyCenters, cellLineageTreeIds(end));
        cell_t0 = allColoniesCellStats{cellLineageTreeIds(end)}(1,6);
        tStep = timePoints(2)-cell_t0+1; %position of cell at timePoint 2.
        distance2 = 400 - dists(tStep)/umToPixel; %distance from the edge in pixels.
        
        % get the id of the mother cell present at the start timePoint.
        motherCells_tStart = cellfun(@(x) x(1,6), allColoniesCellStats(cellLineageTreeIds));
        candidates = cellLineageTreeIds(motherCells_tStart<=timePoints(1));
        if numel(candidates) > 1
            goodCandidate = candidates(end);
            
        else
            goodCandidate = candidates;
        end
        
        dists = getDistanceFromColonyCenter(allColoniesCellStats, colonyCenters, goodCandidate);
        cell_t0 = allColoniesCellStats{goodCandidate}(1,6);
        tStep = timePoints(1)-cell_t0+1; %position of cell at timePoint 1.
        distance1 = 400 - dists(tStep)/umToPixel; %distance from the edge in pixels.
        
    end
    
    startRegion = findColonyRegionWithCell(regionBounds, distance1);
    endRegion = findColonyRegionWithCell(regionBounds, distance2);
    % increment values in transitionMatrix
    transitionMatrix(startRegion, endRegion) = transitionMatrix(startRegion, endRegion) +1;
 
end

cellsInRegion = sum(transitionMatrix,2);

