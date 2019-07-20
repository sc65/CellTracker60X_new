function [cellIds_lineage, tof_lineage] =  getCellLineage_cellIds_tof(cellIdsTend)
% returns the cell Id's and formation time of all cells in the lineage of 
% all the cell Ids
%% ------ Input -------
% 1) cellIdsEnd: cell index of a cell (in allColoniesCellStats) present at tEnd. 
%% ------ Output ------
% 1) cellIds_lineage - a matrix, each row corresponding to one cell Id
% 2) tof_lineage - same as cellIds_lineage.

%% ---- note: cellIds which seem to have undergone 3 divisions are removed from the output.

%% ------------------------------------
cellIds_lineage = zeros(numel(cellIdsTend), 4);
tof_lineage = cellIds_lineage; %time of formation for all cells in family.

counter = 1;
for ii = cellIdsTend
    [~, cellLineageTreeIds] = findDistanceMovedByACell(allColoniesCellStats, ii);
    nCells = numel(cellLineageTreeIds);
    cellIds_lineage(counter, 1:nCells) = cellLineageTreeIds; 
    tof_lineage(counter, 1:nCells) = cellfun(@(x)(x(1,6)), allColoniesCellStats([cellLineageTreeIds]));    
    counter = counter+1;
end

%% remove cells which appear to have > 3 divisions
lastColumn = cellIds_lineage(:,4);
toRemove = find(lastColumn>0); 

cellIds_lineage([toRemove],:) = [];
tof_lineage([toRemove],:) = [];
