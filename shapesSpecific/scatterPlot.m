                                                    %%
% get the distance of cells from each edge.
% color code the cells according to marker levels.

shape_num = 14;
colonies_to_use = find([plate1.colonies.shape] == shape_num);
figure;

channel = 10; %[10 8 6] [CDX2 Sox17 Eomes]
norm_channel = 5;

pointer_size = 100;
figure;
for ii = colonies_to_use
    
    cells_data = plate1.colonies(ii).data;
    
    rotmat = [-1 0; 0 -1]; %rotates the figure by 180 degrees.
    
    if plate1.colonies(ii).rotate
        cells_data(:,1:2) = cells_data(:,1:2)*rotmat;
    end
    
    x_values = cells_data(:,1);
    y_values = cells_data(:,2);
    
    %%
    boundary_points_positions = boundary(x_values, y_values);
    boundary_points = [x_values(boundary_points_positions), y_values(boundary_points_positions)];
    
    
    %
    %segregate boundary_points as those on edge 1 and edge 2.
    
   
    lowest_point = min(y_values);
    dists = boundary_points(:,2)-lowest_point; %just find distance in y direction
    
    edge_1 = boundary_points(dists<50, :);
    edge_2 = boundary_points(~(dists<50), :);
    %%
%     figure;
%     plot(x_values, y_values, 'r*');
%     
%     hold on;
%     plot(edge_1(:,1), edge_1(:,2), 'g*');
%     
%     hold on;
%     plot(edge_2(:,1), edge_2(:,2), 'b*');
    %%
    %compute the minimum distance of each cell from the two edges.
    
    cell_positions = [x_values y_values];
    
    edge1_distmat = distmat(cell_positions, edge_1);
    distance_from_edge1 = min(edge1_distmat,[],2);
    
    edge2_distmat = distmat(cell_positions, edge_2);
    distance_from_edge2 = min(edge2_distmat,[],2);
    
    all_distances = [distance_from_edge1 distance_from_edge2];
    
    %% 
    cdx2_values = (cells_data(:,channel) + cells_data(:,channel+1))./ cells_data(:,norm_channel) ;
    
     
    
    hold on;
    scatter(all_distances(:,1), all_distances(:,2), pointer_size, cdx2_values, 'filled');
    
    pointer_size = pointer_size-4;
    
    
end

















