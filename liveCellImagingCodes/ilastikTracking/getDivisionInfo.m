function [divisionTime, childrenId, nDivisions] = getDivisionInfo(divisionTable, trackId)
% returns the time a cell divides and trackIds of daughter cells.

allTrackIds = divisionTable(:,4);
divisionTimeRow = find(allTrackIds == trackId); %row number corresponding to cell division

if ~isempty(divisionTimeRow)
    childrenId = divisionTable(divisionTimeRow(1), [6 8]);
    divisionTime = divisionTable(divisionTimeRow(1), 1);
    nDivisions =  length(divisionTimeRow);
else
    childrenId = 0;
    divisionTime = 0;
    nDivisions = 0;
end
end
