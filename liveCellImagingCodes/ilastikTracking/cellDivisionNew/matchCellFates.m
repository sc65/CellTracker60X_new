
function [grandDaughters_in_fate] = matchCellFates(grandDaughters_trackIds, grandDaughters_colonyIds, ...
    grandDaughters_colonyPartIds, colonyId, colonyPartId, outputFile)
%% returns the fate data as a m*4 matrix for m cells with given track Ids. [dapi venus T cdx2]
%% --- each row is a cell. Non-matched cells - null row.
%% -------------------------------------

grandDaughters_in = find(grandDaughters_colonyIds == colonyId & grandDaughters_colonyPartIds == colonyPartId);
grandDaughters_in_trackIds = grandDaughters_trackIds(grandDaughters_in);

grandDaughters_in_fate = zeros(numel(grandDaughters_in), 4);

load(outputFile, 'goodCells', 'matchedCellsfateData');
grandDaughters_in_cellMatch = find(ismember(goodCells, grandDaughters_in_trackIds));
[~,fateId_match,cellId_match] = intersect(matchedCellsfateData(:,1), grandDaughters_in_cellMatch);
grandDaughters_in_fate(cellId_match,:) = matchedCellsfateData(fateId_match,2:5);

