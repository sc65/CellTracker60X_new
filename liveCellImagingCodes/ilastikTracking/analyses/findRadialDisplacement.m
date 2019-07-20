
function [startDistance, endDistance] = findRadialDisplacement(colonyCenters, allColoniesCellStats, colonyIdsCellsTend, cellIdsTstart, cellIdsTend)
%% returns the distance of parent cells from the colony center at t0 and distance of kid cells from the same center at tEnd.

colonyCenters = cell2mat(colonyCenters');
colonyCentersX = colonyCenters(:,1);
colonyCentersY = colonyCenters(:,2);

xStart = cellfun(@(x)(x(1,1)), allColoniesCellStats(cellIdsTstart));
yStart = cellfun(@(x)(x(1,2)), allColoniesCellStats(cellIdsTstart));

xStart = xStart'; yStart = yStart';

startDistance = sqrt((yStart - colonyCentersY(colonyIdsCellsTend)).^2 + (xStart - colonyCentersX(colonyIdsCellsTend)).^2);


if exist('cellIdsTend', 'var')
    
    xEnd = cellfun(@(x)(x(end,1)), allColoniesCellStats(cellIdsTend));
    yEnd = cellfun(@(x)(x(end,2)), allColoniesCellStats(cellIdsTend));
    xEnd = xEnd';
    yEnd = yEnd';
    
    endDistance = sqrt((yEnd - colonyCentersY(colonyIdsCellsTend)).^2 + (xEnd - colonyCentersX(colonyIdsCellsTend)).^2);
else
    endDistance = 0;
end

end