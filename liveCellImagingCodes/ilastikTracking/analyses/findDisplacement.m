function displacement = findDisplacement(allColoniesCellStats, cellIdsTend, cellIdsTstart)
%% get displacement of all cells (start position of parent cell to end position of all kid cells)

xStart = cellfun(@(x)(x(1,1)), allColoniesCellStats(cellIdsTstart));
xEnd = cellfun(@(x)(x(end,1)), allColoniesCellStats(cellIdsTend));

yStart = cellfun(@(x)(x(1,2)), allColoniesCellStats(cellIdsTstart));
yEnd = cellfun(@(x)(x(end,2)), allColoniesCellStats(cellIdsTend));

xStart = xStart'; xEnd = xEnd'; yStart = yStart'; yEnd = yEnd'; %column vectors are more clear.
displacement = sqrt((xEnd-xStart).^2 + (yEnd - yStart).^2);
