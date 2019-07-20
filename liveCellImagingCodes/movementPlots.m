function movementPlots(colonyMask, allstats)
%% plot the absolute positions of cells (start and end) on a plot.

% Make two boundaries - 1)Colony boundary.  2)Dense region boundary.
% Do the cells from 1 enter 2?
colonyBoundary = bwboundaries(colonyMask);

%find the largest cell.
[~, maxcellind] = max(cellfun(@numel,colonyBoundary));

%------ Just to check if boundary actually represents the colony boundary.
% figure;
% imshow(colonyMask);
% hold on;
% plot(colonyBoundary{maxcellind}(:,2), colonyBoundary{maxcellind}(:,1), 'b', 'LineWidth', 2);
%%
x1 = colonyBoundary{maxcellind}(:,2);
y1 = -colonyBoundary{maxcellind}(:,1);
k = convhull(x1, y1);
territories = [0 100 252 400];
umtopixel = 1.55;
figure;
for ii = 1:3
   
    plot(x1(k), y1(k), 'k-', 'LineWidth', 2);
    hold on;
    mindistance = territories(ii)*umtopixel;
    maxdistance = territories(ii+1)*umtopixel;
    
    %select cells whose distance from the edge fall between mindistance and
    %maxdistance at t0.
    distance_from_edge_t0 = squeeze(allstats(1,4,:));
    condition_to_satisfy = distance_from_edge_t0 > mindistance & distance_from_edge_t0 < maxdistance;
    cells_in_territory = allstats(:,:, condition_to_satisfy);
    
    % plot the start and end position of each cell on the colony.
    positionT0= squeeze(cells_in_territory(1, 2:3, :))';
    positionT1 = squeeze(cells_in_territory(end, 2:3, :))';
    
    scatter(positionT0(:,1), -positionT0(:,2), 30, [0 0.5 0], 'filled'); %start point
    
    ncells = size(cells_in_territory, 3);
    
    for kk = 1:ncells %displaying the label of the cell in frame 1 , next to it. 
        text(positionT0(kk,1)+1, -positionT0(kk,2)+2, int2str(cells_in_territory(1,1,kk)), 'Fontsize', 12, 'FontWeight', 'bold');
    end
    
    plot(positionT1(:,1), -positionT1(:,2), 'r.', 'MarkerSize', 14); %end point
    quiver(positionT0(:,1), -positionT0(:,2),(positionT1(:,1)- positionT0(:,1)),(-positionT1(:,2)- -positionT0(:,2)),0); %connecting line.
    
%     % plot a boundary at a distance of 57um from the edge.
%     all_dists = bwdist(~colonyMask);
%     allIds = find(all_dists < 71.5*umtopixel & all_dists > 70.5*umtopixel);
%     im1 = false(1400);
%     im1(allIds) = 1;
%     stats = regionprops(im1, 'PixelList');
%     xy = cat(1, stats.PixelList);
%     
%     for jj = 1:size(xy,1)
%         plot(xy(jj, 1), -xy(jj,2),'Marker', '.', 'Color', [0.5 0.5 0.5], 'MarkerSize', 2);
%     end
%     
%     %plot another boundary at a distance of 180 um from the edge.
%     allIds = find(all_dists < 252.5*umtopixel & all_dists > 251.5*umtopixel);
%     im1 = false(1400);
%     im1(allIds) = 1;
%     stats = regionprops(im1, 'PixelList');
%     xy = cat(1, stats.PixelList);
%     
%     for jj = 1:size(xy,1)
%         plot(xy(jj, 1), -xy(jj,2), 'Marker', '.', 'Color', [0 0 0.5], 'MarkerSize', 2);
%     end
%     
%     
    
end




