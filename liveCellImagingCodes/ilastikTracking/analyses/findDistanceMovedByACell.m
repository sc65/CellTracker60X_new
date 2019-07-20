function [distance, cellLineageTreeIds, positionList] =  findDistanceMovedByACell(allColoniesCellStats, cellId)
%% returns the distance moved by a cell defined by a given cell Id.

% find cell Ids corresponding to the cell's lineage.
cellLineageTreeIds = zeros(1,10);
cellLineageTreeIds(1) = cellId;

counter = 2;
motherCelltStart = allColoniesCellStats{cellId}(1,6);

while motherCelltStart > 0
    if counter == 2
        cellToUse = cellId;
    else
        cellToUse = motherCell;
    end
    motherCell = findMotherCellInAllColoniesCellStats(allColoniesCellStats, cellToUse);
    motherCelltStart = allColoniesCellStats{motherCell}(1,6);
    cellLineageTreeIds(counter) = motherCell;
    counter = counter+1;
end

cellLineageTreeIds = cellLineageTreeIds(1:find(cellLineageTreeIds,1, 'Last')); %remove trailing zeros
cellLineageTreeIds = fliplr(cellLineageTreeIds); %start from mother cell and move upto daughter cell
%%
xy = cellfun(@(x)(x(:,1:2)), allColoniesCellStats(cellLineageTreeIds), 'UniformOutput', 0);
xy = vertcat(xy{:}); % all xy positions, starting from grandma cell to daughter cell
%%
positionList = xy;
distance = sum(sqrt(sum(abs(diff(xy)).^2, 2)));
end