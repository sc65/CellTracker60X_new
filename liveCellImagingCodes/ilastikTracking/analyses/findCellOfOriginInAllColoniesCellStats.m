function originCell = findCellOfOriginInAllColoniesCellStats(allColoniesCellStats, cellIds)
%% returns cell Ids corresponding to starting cell - origin cell, of all cells with cellIds listed in the array cellIds.

originCell = zeros(1, numel(cellIds));
counter1 = 1;

for ii = cellIds
    % find cell Ids corresponding to the cell's lineage.
    cellLineageTreeIds = zeros(1,10);
    cellLineageTreeIds(1) = ii;
    
    counter2 = 2;
    motherCelltStart = allColoniesCellStats{ii}(1,6);
    
    while motherCelltStart > 0
        if counter2 == 2
            cellToUse = ii;
        else
            cellToUse = motherCell;
        end
        motherCell = findMotherCellInAllColoniesCellStats(allColoniesCellStats, cellToUse);
        motherCelltStart = allColoniesCellStats{motherCell}(1,6);
        cellLineageTreeIds(counter2) = motherCell;
        counter2 = counter2+1;
    end
    
    cellLineageTreeIds = cellLineageTreeIds(1:find(cellLineageTreeIds,1, 'Last')); %remove trailing zeros
    cellLineageTreeIds = fliplr(cellLineageTreeIds); %start from mother cell and move upto daughter cell
    originCell(counter1) = cellLineageTreeIds(1);
    counter1 = counter1+1;
end
end