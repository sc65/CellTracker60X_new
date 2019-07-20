function plotExtentOfCellMovementEachTimePoint(allColoniesCellStats, cellIds, colors, umToPixel)
% -------plot2 - distance moved vs time.
% Does its speed changes with time? => Does the distance travelled in each
% timestep changes in time?

for ii = cellIds
    colonyId = allColoniesCellStats{ii}(1,3);
    positions = allColoniesCellStats{ii}(:,1:2); % all XY coordinates.
    distanceMoved = sqrt(sum(abs(diff(positions)).^2,2));
    distanceMoved = distanceMoved/umToPixel;
    
    % plot distance from the colony center vs time.
    timeInterval = allColoniesCellStats{ii}(1, 6:7);
    timeInterval = (timeInterval).*10/60; %in hrs.
   
    xValues = linspace(timeInterval(1)+1, timeInterval(2), length(distanceMoved));
    plot(xValues, distanceMoved, '-', 'Color', colors(ii,:), 'Linewidth', 2); % parent cell
    hold on;
    
    
    if nKids>0
        for jj = kidsId
            
            timeInterval = allColoniesCellStats{jj}(1, 6:7);
            timeInterval = (timeInterval).*10/60; %in hrs.
            
            positions = allColoniesCellStats{jj}(:,1:2); % all XY coordinates.
            distanceMoved = sqrt(sum(abs(diff(positions)).^2,2));
            
            xValues = linspace(timeInterval(1)+1, timeInterval(2), length(distanceMoved));
            plot(xValues, distanceMoved, '-', 'Color', colors(ii,:), 'LineWidth', 2); % daughter cells
        end
        
    end
    
     if ii == cellIds(end)
      
        xlabel('Time (h)');
        ylabel('Distance Moved (\mum)');
        title([' Colony' int2str(colonyId)]);
        ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';
    end
    counter = counter+1;
end
