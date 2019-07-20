%%
% load output file containing peaks array for individual frames.
outputfile = 'colony2output.mat';
load(outputfile);
%%
% track cells.
L_value = 50;
time_points = [1 size(peaks,2)];
for ii = time_points(1)+1 : time_points(2)
    peaks = MatchFrames(peaks, ii, L_value);
end
%%
%save the changes
save(outputfile, 'peaks', '-append');

%%
% load the nuclear masks and the colony mask.
nuclei_mask_path = '/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616/fullColonies/ilastik_segmentation/Colony2new_Simple Segmentation.h5';
nuclei_mask = readIlastikFile(nuclei_mask_path);

colony_mask_path = '/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616/fullColonies/ilastik_segmentation/Colony2_colonymask.tif';
colony_mask = imread(colony_mask_path);

% take the intersection of nuclear mask with colony_mask to remove
% non-cells outside the colony.

for i = 1:size(nuclei_mask,3)
    nuclei_mask(:,:,i) = nuclei_mask(:,:,i) & colony_mask;
end
%%
tic;
time_points = [1 100];
checkTrackingInTimepoints(peaks, nuclei_mask,  time_points);
allstats = getCellMigrationStats(peaks, colony_mask, time_points);
toc;

%%
% for all cells that are tracked for time_points 1:30, plot the distance
% from the boundary as a function of time. 

colmax=ceil(max(peaks{t1}(:,1:2)));
new_colony_mask=false(colmax(1)+10,colmax(2)+10);

all_dists = bwdist(~new_colony_mask);
%%
timepoints = [1 133];
checkTrackingInTimepoints(peaks, nuclei_mask,  timepoints);
%%
plotMovementofCells(peaks, nuclear_masks, time_points, dist);


