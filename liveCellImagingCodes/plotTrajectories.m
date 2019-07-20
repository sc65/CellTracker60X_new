function plotTrajectories(allstats, cellsToUse)

%%
if exist('cellsToUse', 'var')
    allstats(:,:, ~ismember(squeeze(allstats(1,1,:)), cellsToUse')) = [];
end
ncells = size(allstats,3);
cellIds = squeeze(allstats(1,1,:));
im1 = zeros(1024);

for ii = 1:ncells 
    figureNum = ceil(ii/25);
    if mod(ii-1,25)==0
        figure; imshow(im1);
        hold on;
    end
    cellXY = allstats(:,2:3,ii);
    cellXY = cellXY - [min(cellXY(:,1)), min(cellXY(:,2))];
    startPoint = cellXY(1,:);
    endPoint = cellXY(end,:);
    
    %cell walks right?
    right = (endPoint(1) - startPoint(1))>0;
    
    %cell walks up?
    up = (endPoint(2) - startPoint(2)) < 0; %(In image coordinates, going up = going low in y). 
    
    %decide the plotting of the startpoint based on the the direction the
    %cell moves. 
    relativePosition = ii-(figureNum-1)*25;
    if right > 0 
        addX = 40+200*(mod(relativePosition-1,5));
    else
        addX = 120+200*(mod(relativePosition-1,5));
    end
    
    if up>0
        addY = 120+200*(ceil(relativePosition/5)-1);
    else
        addY = 40+200*(ceil(relativePosition/5)-1);
    end
    
    cellXY = cellXY + [addX addY];   
    plot(cellXY(:,1), cellXY(:,2), 'w-', 'LineWidth', 2);  
    plot(cellXY(1,1), cellXY(1,2), 'g.', 'MarkerSize', 14);
    plot(cellXY(end,1), cellXY(end, 2), 'r.', 'MarkerSize', 14);
    text(cellXY(1,1)+15, cellXY(1,2)+10, int2str(cellIds(ii)), 'Color', 'c', 'FontSize', 12);
end
    
    
    
    
    
    
    
    
    