function [cellsPresentAtEndTimePoint, xy1] = getIdAndPositionOfCellsTrackedTillEnd(allCellStats, trackingEndTimePoint)
%% Get the positions of cells tracked till the end.

cellsEndTimePoint =  cellfun(@(x)(x(1,5)), allCellStats); % last time point at which that cell occurs.
cellsPresentAtEndTimePoint = find(cellsEndTimePoint == trackingEndTimePoint-1); %ilastik numbering starts from 0.

xValue = cellfun(@(x)(x(end,1)), allCellStats(cellsPresentAtEndTimePoint));
yValue = cellfun(@(x)(x(end,2)), allCellStats(cellsPresentAtEndTimePoint));
xy1 = floor([xValue' yValue']);