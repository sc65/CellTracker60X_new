function plotDirectionOfCellMovement(allColoniesCellStats, colonyCenters, cellIds, colors, umToPixel)
%% plots distance from the center vs time for cells with the given cellId.

%%
counter = 1;
for ii = cellIds
    colonyId = allColoniesCellStats{ii}(1,3);
    
    distanceFromCenter = getDistanceFromColonyCenter(allColoniesCellStats, colonyCenters, ii);
    distanceFromCenter = distanceFromCenter/umToPixel; %convert to microns.
 
    % plot distance from the colony center vs time.
    timeInterval = allColoniesCellStats{ii}(1, 6:7);
    timeInterval = (timeInterval).*10/60; %in hrs.
    
    
    xValues = linspace(timeInterval(1), timeInterval(2), length(distanceFromCenter));
    plot(xValues, distanceFromCenter, '-.', 'Color', colors(counter,:), 'Linewidth', 2); % parent cell
    kidsId = findCellIdsOfKids(allColoniesCellStats, ii); % find all daughter cells of that parent cell.
    nKids = length(kidsId);
    
    if nKids>0
        for jj = kidsId
            
            timeInterval = allColoniesCellStats{jj}(1, 6:7);
            timeInterval = (timeInterval).*10/60; %in hrs.
            distanceFromCenter = getDistanceFromColonyCenter(allColoniesCellStats, colonyCenters, jj);
            distanceFromCenter = distanceFromCenter/umToPixel;
            
            xValues = linspace(timeInterval(1), timeInterval(2), length(distanceFromCenter));
            plot(xValues, distanceFromCenter, '-.', 'Color', colors(counter,:), 'LineWidth', 2); % daughter cells
        end
    end
    
    if ii == cellIds(end)
        %legend(strsplit(int2str(uniqueCellsLineageIds),' '));
        xlabel('Time (h)');
        ylabel('Distance from the center (\mum)');
        title([' Colony' int2str(colonyId)]);
        ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';
    end
    counter = counter+1;
end