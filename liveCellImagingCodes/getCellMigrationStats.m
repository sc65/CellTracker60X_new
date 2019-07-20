
function allstats = getCellMigrationStats(peaks, colony_mask, time_points)

t1 = time_points(1);
t2 = time_points(2);

ncells = size(peaks{t1},1);

n_columns = 7;
allstats = zeros(t2-t1+1, n_columns, ncells);
%[cell_id, x_pos y_pos Distance from edge, Distance covered,
% Intensity(RFP:GFP)]

all_dists = bwdist(~colony_mask);

cell_counter = 1;

for i = 1:size(peaks{time_points(1)},1)
    
    cellstats = zeros(t2-t1+1, n_columns);
    
    cell_num = i;
    time_counter = 1;
    absolute_time = time_points(1)+time_counter-1;
    
    cellstats = makeAllStats(peaks, cell_num, time_counter, absolute_time, cellstats);
    
    cell_in_next_frame = peaks{absolute_time}(i,4);
    
    for j = time_points(1)+1:time_points(2)
        
        if cell_in_next_frame~=-1
            cell_in_current_frame = cell_in_next_frame;
            time_counter = time_counter+1;
            
            cellstats = makeAllStats(peaks, cell_in_current_frame, time_counter, j, cellstats);
            cell_in_next_frame = peaks{j}(cell_in_current_frame,4);
            
        end
    end
    
    if(~ismember(sum(cellstats,2), 0))
        allstats(:,:,cell_counter) = cellstats;
        cell_counter = cell_counter+1;
    end
end





    function cellstats = makeAllStats(peaks, cell_num, time_counter, absolute_time, cellstats)
        
        cellstats(time_counter,1) = cell_num;
        cellstats(time_counter,2:3) = peaks{absolute_time}(cell_num, 1:2);
        
        cellstats(time_counter,4) = all_dists(sub2ind(size(colony_mask), floor(peaks{absolute_time}(cell_num,2)), floor(peaks{absolute_time}(cell_num,1))));
        
        if(time_counter == 1)
            cellstats(time_counter, 5:7) = 0;
        else
            %calculate distnce between this position and position at t1.
            
            previous_xy = cellstats(time_counter-1,2:3);
            current_xy = cellstats(time_counter,2:3);
            cellstats(time_counter, 5) = sqrt((current_xy(2)-previous_xy(2))^2 + (current_xy(1)-previous_xy(1))^2);
            % distance moved between previous timepoint and current timepoint.
        end
        
        cellstats(time_counter, 6:7) =  peaks{absolute_time}(cell_num, 5:6);
        
    end

allstats(:,:,cell_counter:end) = []; %remove the matrices with no cell information.
end
