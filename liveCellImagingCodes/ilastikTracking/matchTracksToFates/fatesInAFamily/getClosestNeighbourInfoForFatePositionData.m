function neighbourInfo = getClosestNeighbourInfoForFatePositionData(allCellStats, matchedCellsfateData, ltCheck, selfId, sisterId, fate11, fate12, umToPixel) 
%% returns information on the similarity between fate levels of the cell and its closest neighbour, 
% except its sister.
%% ---------------------- Inputs ----------------------
% 1) ltCheck:lineage-divisionTime Matrix, output from function makeLineageDivisionTimeMatrix
% [trackId lineageId startTime endTime distanceFromEdge]
% 2) fate11: T/venus levels of the cell
% 3) fate21: CDX2/venus levels of the cell
%%
cellIds = ltCheck(:,1)';
xAll = cellfun(@(x)(x(end,1)), allCellStats(cellIds)); 
yAll = cellfun(@(x)(x(end,2)), allCellStats(cellIds));
% x and y positions of the cells at the end of the the imaging
xy1 = allCellStats{selfId}(end,1:2);

distanceMatrix = distmat(xy1, [xAll' yAll']); % distance of the cell from all other track-matched cells.
%%
% find closestNeighbour , except the sister.
cellPosition = find(cellIds == selfId);
sisterPosition = find(cellIds== sisterId);
distanceMatrix(1, cellPosition) = Inf; % excluding the cell
distanceMatrix(1, sisterPosition) = Inf; % excluding the sister.
[~,idx] = sort(distanceMatrix); 

% neighbour metrics
position = idx(1);
trackId = cellIds(position);
distanceFromCell = distanceMatrix(1, position)/umToPixel;
sameLineage = (ltCheck(position,2) == ltCheck(cellPosition,2)); % Do they come from same family?

fateData = matchedCellsfateData(matchedCellsfateData(:,1) == trackId,:);
fate21 = fateData(:,4)/fateData(:,3); % T/Venus
fate22 = fateData(:,5)/fateData(:,3); % cdx2/Venus
        

f1 = abs(fate21-fate11); % fate11, fate12 - fate data for the self-cell.
f2 = abs(fate22-fate12);


neighbourInfo = [f1 f2 sameLineage distanceFromCell trackId];

end