function showCells(peaks, nuclear_masks, time_points, cell_indices)



% are the cells tracked real?

t1 = time_points(1);
t2 = time_points(2);


figure;
imshowpair(nuclear_masks(:,:,t1), nuclear_masks(:,:,t2));
hold on;


for jj = cell_indices
    
    plot(peaks{t1}(jj,1), peaks{t1}(jj,2), 'r*');
    text(peaks{t1}(jj,1), peaks{t1}(jj,2), int2str(jj), 'FontSize', 12, 'Color', [1 1 0]);
end

hold off;