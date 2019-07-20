function dists = getDistanceFromColonyCenter(allColoniesCellStats, colonyCenters, cellId)
%% returns the distance of a cell(in pixels) from the colony center for all time points. 

data = allColoniesCellStats{cellId};
Xdata = data(:,1); % position list of parent cell.
Ydata = data(:,2);
colonyId = data(1,3);
colonyCenter = colonyCenters{colonyId};

dists = sqrt((Xdata - colonyCenter(1)).^2 + (Ydata - colonyCenter(2)).^2);

end