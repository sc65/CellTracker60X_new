function angularDisplacement =  findAngularDisplacement(colonyCenters, allColoniesCellStats, cellIdsTstart, cellIdsTend, colonyIdsCellsTend)
%% returns angular displacement. 

xStart = cellfun(@(x)(x(1,1)), allColoniesCellStats(cellIdsTstart));
xEnd = cellfun(@(x)(x(end,1)), allColoniesCellStats(cellIdsTend));

yStart = cellfun(@(x)(x(1,2)), allColoniesCellStats(cellIdsTstart));
yEnd = cellfun(@(x)(x(end,2)), allColoniesCellStats(cellIdsTend));

xStart = xStart'; xEnd = xEnd'; yStart = yStart'; yEnd = yEnd';

colonyCenters = cell2mat(colonyCenters');
colonyCentersX = colonyCenters(:,1);
colonyCentersY = colonyCenters(:,2);

startTheta = atan2d(yStart - colonyCentersY(colonyIdsCellsTend), xStart - colonyCentersX(colonyIdsCellsTend));
startTheta(startTheta<0) = 360+startTheta(startTheta<0); %converts angles in the range [0-360].

endTheta = atan2d(yEnd-colonyCentersY(colonyIdsCellsTend), xEnd-colonyCentersX(colonyIdsCellsTend));
endTheta(endTheta<0) = 360+endTheta(endTheta<0);

angleFromTheCenter = [startTheta endTheta];
angularDisplacement = endTheta-startTheta;

%%  % if the cell moves across Quadrants IV and I
from4to1 = find(angleFromTheCenter(:,1)>270 & angleFromTheCenter(:,2)<90);
from1to4 = find(angleFromTheCenter(:,1)<90 & angleFromTheCenter(:,2)>270); 
angularDisplacement(from4to1) = 360-angleFromTheCenter(from4to1,1) + angleFromTheCenter(from4to1,2);
angularDisplacement(from1to4) = -(360-angleFromTheCenter(from1to4,2) + angleFromTheCenter(from1to4,1));
%movement in the clockwise direction taken as negative.

angularDisplacement(abs(angularDisplacement) > 80) = 0; %To remove outliers. Remove later.
end
%%
