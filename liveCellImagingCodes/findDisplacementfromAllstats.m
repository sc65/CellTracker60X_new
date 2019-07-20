function displacement = findDisplacementfromAllstats(data, t1, t2)

%data is the output from the function getCellMigrationStats
%the different columns in data represent 
%[cellId x y Distancefromedge Displacement nuclearIntensity(GFP) nuclearIntensity(RFP)]
%Each row corresponds to a given timepoint. 
%Each third dimension corresponds to a given cell. 

first = squeeze(data(t1,2:3,:))';
if ~ exist('t2', 'var')
    last = squeeze(data(end,2:3,:))';
else
last = squeeze(data(t2,2:3,:))';
end
displacementMatrix = pdist2(last, first, 'Euclidean');
displacement = diag(displacementMatrix);

%%
