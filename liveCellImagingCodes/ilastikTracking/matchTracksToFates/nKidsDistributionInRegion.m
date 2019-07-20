function [uniqueParentCellIds, nKids] = nKidsDistributionInRegion(regionBounds, allColoniesCellStats, startDistance, cellIdsTstart)
%% returns number of daughter/granddaughter cells of all cells present in a region.

cellsInRegion = find(startDistance > regionBounds(1) & startDistance < regionBounds(end));
cellsInRegionIds = cellIdsTstart(cellsInRegion);
%
uniqueParentCellIds = unique(cellsInRegionIds);
nParents = length(uniqueParentCellIds);
nKids = zeros(1, nParents);

%find all daughter cells of that parent cell.
counter = 1;
for ii = uniqueParentCellIds
    kidsId = findCellIdsOfKids(allColoniesCellStats, ii);
    kidsTstart = cellfun(@(x) x(1,6), allColoniesCellStats(kidsId));
    kidsId = kidsId(kidsTstart<140); 
    % only include kids which are present before in the first 23 hrs - to compare with previous data.
    
    nKids(counter) = length(kidsId);
    counter = counter+1;
end

end
