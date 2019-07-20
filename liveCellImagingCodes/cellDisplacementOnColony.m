function cellDisplacementOnColony(colonyMask, allstats, umtopixel, cellsToUse)
%% plot the absolute positions of cells (start and end) on a plot.

% Make two boundaries - 1)Colony boundary.
colonyBoundary = bwboundaries(colonyMask);

%find the largest cell.
[~, maxcellind] = max(cellfun(@numel,colonyBoundary));
x1 = colonyBoundary{maxcellind}(:,2);
y1 = -colonyBoundary{maxcellind}(:,1);
k = convhull(x1, y1);
figure;
plot(x1(k), y1(k), 'k-', 'LineWidth', 2);
hold on;

% get information corresponding to the cells.
if exist('cellsToUse', 'var')
    allstats(:,:, ~ismember(squeeze(allstats(1,1,:)), cellsToUse')) = [];
else
    cellsToUse = squeeze(allstats(1,1,:))';
end

% plot the start and end position of each cell on the colony.
positionT0= squeeze(allstats(1, 2:3, :))';
positionT1 = squeeze(allstats(end, 2:3, :))';
scatter(positionT0(:,1), -positionT0(:,2), 100, [0 0.5 0], 'filled'); %start point

ncells = size(allstats, 3);
for kk = 1:ncells %displaying the label of the cell in frame 1 , next to it.
    text(positionT0(kk,1)+1, -positionT0(kk,2)+2, int2str(cellsToUse(kk)), 'Fontsize', 10, 'FontWeight', 'bold');
end

plot(positionT1(:,1), -positionT1(:,2), 'r.', 'MarkerSize', 10); %end point
%quiver(positionT0(:,1), -positionT0(:,2),(positionT1(:,1)- positionT0(:,1)),(-positionT1(:,2)- -positionT0(:,2)),0); %connecting line.
%%
% for each cell, plot the trajectories color coded by beta-catenin levels.
for ii = 1:ncells
    xy = squeeze(allstats(:,2:3, ii));
    bcatLevels = squeeze(allstats(:,7,ii))./squeeze(allstats(:,6,ii));
    scatter(xy(:,1), -xy(:,2), 30, bcatLevels, 'filled');
    line(xy(:,1), -xy(:,2));
end
colormap('cool');
colorbar;
caxis([0 3]);

%% Draw boundaries at the region with peak beta-catenin levels. 
% plot a boundary at a distance of 100um from the edge.
    all_dists = bwdist(~colonyMask);
    allIds = find(all_dists < 100.5*umtopixel & all_dists > 99.5*umtopixel);
    im1 = false(1400);
    im1(allIds) = 1;
    stats = regionprops(im1, 'PixelList');
    xy = cat(1, stats.PixelList);
    for jj = 1:size(xy,1)
        plot(xy(jj, 1), -xy(jj,2),'Marker', '.', 'Color', [0.5 0.5 0.5], 'MarkerSize', 2);
    end
     
% plot another boundary at a distance of 182 um from the edge.
    allIds = find(all_dists < 182.5*umtopixel & all_dists > 181.5*umtopixel);
    im1 = false(1400);
    im1(allIds) = 1;
    stats = regionprops(im1, 'PixelList');
    xy = cat(1, stats.PixelList);
    for jj = 1:size(xy,1)
        plot(xy(jj, 1), -xy(jj,2), 'Marker', '.', 'Color', [0 0 0.5], 'MarkerSize', 2);
    end
    
    









end
