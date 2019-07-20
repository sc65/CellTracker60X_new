function rmsDistance = findRMSdistance(allColoniesCellStats, cellIdsTend,  timeInterval, umToPixel, dt)
%% How does root mean square distance change in time?
timeSteps = timeInterval(2)-timeInterval(1) + 1;
timeDivisions = ceil(timeSteps/dt);

rmsDistance = zeros(timeDivisions, numel(cellIdsTend));

counter = 1;
for cellId = cellIdsTend
    [~,~,positionList] =  findDistanceMovedByACell(allColoniesCellStats, cellId);
    %% for every dt timesteps, find the displacement and plot
    for ii = 1:timeDivisions
        point1 = (ii-1)*dt+timeInterval(1);
        point11 = timeInterval(1);
        
        point2 = point1+dt;
        if  point2>timeInterval(2)
            point2 = timeInterval(2);
        end
 
        pointsToConsider = [point11:dt:point2];
        if pointsToConsider(end)<point2
            pointsToConsider = [pointsToConsider point2];
        end
        p3 = positionList([pointsToConsider],:);
        
        x1 = sqrt(sum(abs(diff(p3)).^2,2)); % distance moved.
        x12 = x1.^2;
        nSteps = numel(x12);
        rmsDistance(ii,counter) = sqrt(sum(x12)/nSteps);
    end
    counter = counter+1;
end
%%

rmsDistance = rmsDistance./umToPixel;

end
