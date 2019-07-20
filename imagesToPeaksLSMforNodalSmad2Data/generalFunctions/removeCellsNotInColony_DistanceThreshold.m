function plate1 = removeCellsNotInColony_DistanceThreshold(plate1, colonynum)


distlimit = 650;  %in pixels 

for i = colonynum
    clear xyvalues alldata rowstodelete coord;
    alldata = plate1.colonies(i).data;
    xyvalues = alldata(:,1:2);
    
    c_center = mean(xyvalues);
    
    figure;
    plot(xyvalues(:,1), xyvalues(:,2), 'k.');
    hold on;
    plot(c_center(1), c_center(2), 'r*');
    title(sprintf('Colony%01d', i));
    
    coord=bsxfun(@minus,xyvalues,c_center);
    dists=sqrt(sum(coord.*coord,2));
    
    rowstodelete = find(dists>distlimit);
    %rowstodelete = find(xyvalues(:,1) > 2300);
    
    xyvalues(rowstodelete,:) = [];
    alldata(rowstodelete,:) = [];
   
    plot(xyvalues(:,1), xyvalues(:,2), 'b.');
    plot(c_center(1), c_center(2), 'r*');
    title(sprintf('Colony%01d', i));
   
    
    plate1.colonies(i).data = alldata;
    
end

