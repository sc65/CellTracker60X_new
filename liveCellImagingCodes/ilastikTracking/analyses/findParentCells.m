function [cellIdsTstart, colonyIds] =  findParentCells(allColoniesCellStats)
%% get cell Ids of parent cells for all the cells along with the colony Id.


colonyIds = cellfun(@(x)(x(1,3)), allColoniesCellStats); %to get the distance from colony center, colonyIds are important.
lineageIds = cellfun(@(x)(x(1,4)), allColoniesCellStats);

cellIdsTstart = zeros(1, numel(colonyIds)); %parentCells.

trackIds = cellfun(@(x)(x(1,5)), allColoniesCellStats);

for jj = 1:numel(cellIdsTstart)
    matchedCells = find(trackIds == lineageIds(jj));
    
    cellColonyId  = allColoniesCellStats{jj}(1,3);
    matchedCellsColonyId = cellfun(@(x)(x(1,3)), allColoniesCellStats(matchedCells));
    
    correctMatch = find(matchedCellsColonyId == cellColonyId);
    cellIdsTstart(jj) = matchedCells(correctMatch);
end
