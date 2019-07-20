function plotTrajectoriesOnColony(colonyImagePath, outputFile, plotnum, colonyFigure)
% colonyImagePath - path corresponding to colony morphology at the end of differentiation.
colonyImage = imread(colonyImagePath);

load(outputFile, 'allCellStats', 'colonyCenter', 'goodCells');
%% plotting full Trajectories, treating each cell separately.
if plotnum == 1
    if colonyFigure
        figure; imshow(colonyImage,[300 3500]);
        hold on;
    end
    hold on;
    for ii = 1:length(allCellStats)
        cellXY = allCellStats{ii}(:, 1:2);
        plot(cellXY(:,1), cellXY(:,2), 'w-', 'LineWidth', 1);
        plot(cellXY(1,1), cellXY(1,2), 'g.', 'MarkerSize', 12);
        plot(cellXY(end,1), cellXY(end,2), 'r.', 'MarkerSize', 15);
    end
    
else
    %% plotting only start and end points.
    % An arrow linking the ancestor cells and daughter cells.
    if colonyFigure
        figure; imshow(colonyImage,[]);
        hold on;
    end
    
    lineageIds = cellfun(@(x)(x(1,3)), allCellStats);
    tEnd = cellfun(@(x)(x(1,5)), allCellStats); %last timePoint when cell is tracked.
    lastTimePointImaged = max(tEnd); % assuming at least one cell is tracked till the last time point.
    cellstEnd = find(tEnd == lastTimePointImaged); %index of cells in the cell array, for cells that are present at the last time point.
    lineageIdstEnd = lineageIds(tEnd ==  lastTimePointImaged);
    
    for ii = 1:length(cellstEnd)
        daughterCellPosition = allCellStats{cellstEnd(ii)}(end,1:2);
        plot(daughterCellPosition(1,1), daughterCellPosition(1,2), 'r.', 'MarkerSize', 10);
        
        %scatter(daughterCellPosition(1,1), daughterCellPosition(1,2), 50,
        %); % color by CDX2 or T values. 
        
        lineageId =  lineageIdstEnd(ii);
        parentCell = find(goodCells == lineageId); %The ancestor cell has track Id = lineageId.
        
        parentCellPosition = allCellStats{parentCell}(1,1:2);
        plot(parentCellPosition(1,1), parentCellPosition(1,2), 'g.', 'MarkerSize', 14);
        arrow(parentCellPosition(1,1:2), daughterCellPosition(1,1:2), 6, 'Color', 'y');
        
        %text(parentCellPosition(1,1)+5, parentCellPosition(1,2), int2str(lineageId), 'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
    end
    
    
    
end
%%


















