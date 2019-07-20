function nCellsRegion = findNumberOfCellsInRegionsAtTimePoint(allColoniesCellStats, colonyCenters,regionBounds, t1, umToPixel)
%% returns an array containing number of cells present in different regions, as defined by regionBounds at timeStep t1.
%% ---------------------------------- Inputs ------------------------------------
% 1) allColoniesCellStats: a cell array containing information about all
% tracked cells in all colonies.
% 3) regionBounds: boundaries of different regions, expressed as distance from the
% edges.
% 4) t1: timeStep used to classify cells in different regions 
%% 
t0 = cellfun(@(x) x(1,6), allColoniesCellStats); % start times of all cells.
tEnd = cellfun(@(x) x(1,7), allColoniesCellStats);
%%
% find cells present at time step t1.
cellIds = 1:numel(allColoniesCellStats);
cellsPresent = cellIds(t0>=t1 & tEnd<=t1);
%%
% find distance of all those cells at t=0, from the colony edge.
distance = zeros(1, numel(cellsPresent));
counter = 1;
for ii = cellsPresent
    dists = getDistanceFromColonyCenter(allColoniesCellStats, colonyCenters, ii);
    cell_t0 = t0(ii);
    tStep = t1-cell_t0+1;
    distance(counter) = 400 - dists(tStep)/umToPixel; %distance from the edge in pixels.
    counter = counter+1;
end
%%
% divide cells into regions - 1,2 or 3.
region1 = distance>=regionBounds(1) & distance<=regionBounds(2);
region2 = distance>regionBounds(2) & distance<=regionBounds(3);
region3 = distance>regionBounds(3) & distance<=regionBounds(4);

cellsInRegion1 = cellsPresent(region1);
cellsInRegion2 = cellsPresent(region2);
cellsInRegion3 = cellsPresent(region3);
nCellsRegion = [numel(cellsInRegion1), numel(cellsInRegion2), numel(cellsInRegion3)];

end






