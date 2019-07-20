function motherCell = findMotherCellInAllColoniesCellStats(allColoniesCellStats, cellId)
%% returns the cell Id of the mother cell - immediate parent, of the cell with a given cell Id.
% --------------------- Inputs -------------------
% allColoniesCellStats: cell array with information on all tracked cells in
% all the colonies
% cellId : Id - position of cell in the cell array allColoniesCellStats

%%
colonyId = allColoniesCellStats{cellId}(1,3);
if size(allColoniesCellStats{1},2) == 9
    colonyPartId = allColoniesCellStats{cellId}(1,9);
else
    colonyPartId = colonyId;
end
lineageId = allColoniesCellStats{cellId}(1,4);
tStart = allColoniesCellStats{cellId}(1,6);

% all cells metrics
coloniesId = cellfun(@(x)(x(1,3)), allColoniesCellStats);

if size(allColoniesCellStats{1},2) == 9
    coloniesPartId = cellfun(@(x)(x(1,9)), allColoniesCellStats);
else
    coloniesPartId = coloniesId;
end

lineagesId = cellfun(@(x)(x(1,4)), allColoniesCellStats);
tEnds = cellfun(@(x)(x(1,7)), allColoniesCellStats);

motherCell = find(coloniesId==colonyId & coloniesPartId == colonyPartId ...
    & lineagesId == lineageId & tEnds+1 == tStart);

if isempty(motherCell)
    motherCell = cellId;
end
