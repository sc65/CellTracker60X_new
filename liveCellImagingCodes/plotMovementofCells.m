function plotMovementofCells(peaks, nuclear_masks, time_points, dist)
% from dists, get the distances of cells that are tracked for all 30 time
% points.

[a,~] = find(dist==0);
cell_number = (size(peaks{time_points(1)},1));
tracked_cell_indices  = setxor(1:cell_number, a);
tracked_cell_distances = dist(tracked_cell_indices,:);

%%
umtopixel = 1.55;
territories = [0 100 250 400];
%
figure(1);

plotnum = 1;

%cells in territory1:
for ii = 1:3
    mindistance = territories(ii)*umtopixel;
    maxdistance = territories(ii+1)*umtopixel;
    d1 = tracked_cell_distances(tracked_cell_distances(:,1)>mindistance & tracked_cell_distances(:,1)<maxdistance,:);
    
    cells_in_territory = tracked_cell_indices(tracked_cell_distances(:,1)>mindistance & tracked_cell_distances(:,1)<maxdistance,1);
    
    subplot(1,3,plotnum);
    hold on;
    
    for i = 1:length(cells_in_territory)
        values = (d1(i,:)./d1(i,1))/umtopixel;
        plot((1:29)./3, values, '-', 'LineWidth', 3);
    end
    
    xlabel('Time after Differentiation(hrs)');
    ylabel('Distance from the edge at t / Distance from the edge at t0');
    title(['Territory ' int2str(ii)]);
    
    ax = gca;
    ax.FontSize = 12;
    hold off;
    
    ylim([0 13]);
    plotnum = plotnum+1;
    
    %showCells(peaks, nuclear_masks, time_points, cells_in_territory);
   
end



