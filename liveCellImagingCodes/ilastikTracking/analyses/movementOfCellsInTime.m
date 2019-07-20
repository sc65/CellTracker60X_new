function [distance, displacement, radialDisplacement] = movementOfCellsInTime(allColoniesCellStats, cellIdsTend, colonyCenters, timeInterval, umToPixel, dt)
%% How do - a) distance, b) displacement, c) radial displacement, for a group of cells, change in time?
timeSteps = timeInterval(2)-timeInterval(1) + 1;
timeDivisions = ceil(timeSteps/dt);

displacement = zeros(timeDivisions, numel(cellIdsTend));
distance = displacement;
radialDisplacement = distance;

counter = 1;
for cellId = cellIdsTend
    [~,~,positionList] =  findDistanceMovedByACell(allColoniesCellStats, cellId);
    %% for every dt timesteps, find the displacement and plot
    for ii = 1:timeDivisions
        point1 = (ii-1)*dt+timeInterval(1);
        p1 = positionList(point1,:); % to calculate rms distance/displacement, calculate distance/displacement w.r.t start point.
        
        point2 = point1+dt-1;
        if  point2>timeInterval(2)
            point2 = timeInterval(2);
        end
        
        p2 = positionList(point2,:);
        p3 = positionList(point1:point2,:);
        
        distance(ii,counter) = sum(sqrt(sum(abs(diff(p3)).^2, 2)));
        %distance(ii, counter) = distance(ii,counter)/(point2-point1+1); %per timeStep
        
        displacement(ii, counter) = sqrt((p1(1)-p2(1))^2 + (p1(2) - p2(2))^2);
        %displacement(ii,counter) =  displacement(ii,counter)/(point2-point1+1); %per timeStep
        
        colonyId = allColoniesCellStats{cellId}(1,3);
        colonyCenter = colonyCenters{colonyId};
        startDistance = sqrt((p1(1)-colonyCenter(1))^2 + (p1(2) - colonyCenter(2))^2);
        endDistance = sqrt((p2(1)-colonyCenter(1))^2 + (p2(2) - colonyCenter(2))^2);
        
        radialDisplacement(ii,counter) = endDistance-startDistance;
        %radialDisplacement(ii,counter) = radialDisplacement(ii,counter)/(point2-point1+1); %per timeStep
    end
    counter = counter+1;
end
%%
displacement = displacement./umToPixel;

distance = distance./umToPixel;

radialDisplacement = radialDisplacement./umToPixel;

end
