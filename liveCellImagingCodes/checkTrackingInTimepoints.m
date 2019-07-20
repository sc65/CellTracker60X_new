function checkTrackingInTimepoints(peaks, nuclear_masks,  time_points)
% overlays nuclear_masks of both the timepoints with the cell number of the
% cells tracked from timepoint1 to timepoint2.

t1 = time_points(1);
t2 = time_points(2);
figure; imshowpair(nuclear_masks(:,:,t1), nuclear_masks(:,:,t2));
hold on;


for i = 1:size(peaks{time_points(1)},1)

    %text(peaks{t1}(i,1), peaks{t1}(i,2), int2str(i), 'Color', [0 0.5 1], 'FontSize', 12);
    cell_in_current_frame = peaks{t1}(i,4);
  
    for j = time_points(1)+1:time_points(2)-1
        
        if cell_in_current_frame~=-1
            cell_in_next_frame = peaks{j}(cell_in_current_frame,4);
            cell_in_current_frame = cell_in_next_frame;  
        end
        
 
    end
    
    if cell_in_current_frame ~= -1
        text(peaks{t1}(i,1), peaks{t1}(i,2), int2str(i), 'Color', [0 0.5 1], 'FontSize', 12); %bluish --- tstart
        text(peaks{t2}(cell_in_current_frame, 1)+1, peaks{t2}(cell_in_current_frame, 2)+10, int2str(i), 'Color', [1 0.5 0], 'FontSize', 12); %orangish --- tend
    end
    
end