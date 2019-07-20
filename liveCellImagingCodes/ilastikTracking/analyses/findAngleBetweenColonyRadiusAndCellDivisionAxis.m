function [theta, d1] = findAngleBetweenColonyRadiusAndCellDivisionAxis(colonyCenters, allColoniesCellStats, parentCellId, daughterCellIds, umToPixel)
%% returns the angle - theta(in degrees), between radius of the colony and the cell division axis for the cell with track Id("cell" no.) in array allColoniesCellStats.
% d1 - distance moved by cell during division.

%% ---------- Inputs ---------
% parentCellId and daughterCellIds refer to ("cell" no.) of the parent and
% daughter cells in the array allColoniesCellStats.
%%%---------------------------
%%
%Position of parent cell during division
parentCellData = allColoniesCellStats{parentCellId};
x0 = parentCellData(end,1);
y0 = parentCellData(end,2);

daughterCellData_1 = allColoniesCellStats{daughterCellIds(1)};
x1 = daughterCellData_1(1,1);
y1 = daughterCellData_1(1,2);

daughterCellData_2 = allColoniesCellStats{daughterCellIds(2)};
x2 = daughterCellData_2(1,1);
y2 = daughterCellData_2(1,2);

colonyId = parentCellData(1,3);
cc_x0 = colonyCenters{colonyId}(1);
cc_y0  = colonyCenters{colonyId}(2);


v1 = [cc_x0, cc_y0] - [x0, y0];
v2 = [x1, y1] - [x2, y2];

theta = atan2d(abs(det([v1;v2])), dot(v1,v2));

positions = [x0 y0; x1 y1];
d1(1) = pdist(positions, 'euclidean');

positions = [x0 y0; x2 y2];
d1(2) = pdist(positions, 'euclidean');

d1 = d1.*umToPixel;
end