function regionWithCell = findColonyRegionWithCell(regionBounds, cellDistance)
%% returns the region of the colony that contains the cell.
%% ----------------------- Inputs ----------------------
% 1) regionBounds: boundaries of different regions, expressed as distance from the
% edges.
% 2) distance1: distance of the cell from the colonyEdge

%%
if cellDistance < 0
    cellDistance = 0;
end

nRegions = numel(regionBounds)-1;
for ii = 1:nRegions
    if (cellDistance>=regionBounds(ii) && cellDistance<=regionBounds(ii+1))
        regionWithCell = ii;
    end
end
end
