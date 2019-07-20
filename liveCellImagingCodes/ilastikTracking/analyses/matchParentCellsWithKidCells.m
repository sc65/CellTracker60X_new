function [cellIdsTend, cellIdsTstart, colonyIdsCellsTend] =  matchParentCellsWithKidCells(allColoniesCellStats, lastTimeStep)
%% get cell Ids of parent cells and their daughter cells, along with the colony Id.

tEnd = cellfun(@(x)(x(1,7)), allColoniesCellStats); %last timePoint when cell is tracked.
cellIdsTend = find(tEnd == lastTimeStep-1); %daughter cells, ilastik numbering starts from 0.
%index of cells in the cell array, for cells that are present at the last time point.
colonyIdsCellsTend = cellfun(@(x)(x(1,3)), allColoniesCellStats(cellIdsTend)); %to get the distance from colony center, colonyIds are important.

lineageIdstEnd = cellfun(@(x)(x(1,4)), allColoniesCellStats(cellIdsTend));

cellIdsTstart = zeros(1, numel(cellIdsTend)); %parentCells.

trackIds = cellfun(@(x)(x(1,5)), allColoniesCellStats);

for jj = 1:numel(cellIdsTend)
    matchedCells = find(trackIds == lineageIdstEnd(jj));
    
    cellColonyId  = allColoniesCellStats{cellIdsTend(jj)}(1,3); %same colony
    matchedCellsColonyId = cellfun(@(x)(x(1,3)), allColoniesCellStats(matchedCells));
    match1 = find(matchedCellsColonyId == cellColonyId); 
   
    if size(allColoniesCellStats{1},2) == 9 % if colony is divided into parts, make sure matched cells belong to the same part.
        cellColonyPartId = allColoniesCellStats{cellIdsTend(jj)}(1,9); 
        matchedCellsColonyPartId = cellfun(@(x)(x(1,9)), allColoniesCellStats(matchedCells));
        match2 = find(matchedCellsColonyPartId == cellColonyPartId);%same colonypart
        correctMatch = intersect(match1, match2);
    else
        correctMatch = match1;
          
    end

    cellIdsTstart(jj) = matchedCells(correctMatch);
end
