%% angle between consecutive displacement vectors

%% load output files
clearvars;
outputFile = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/outputAll.mat';
load(outputFile, 'allColoniesCellStats', 'colonyCenters', 'timeSteps', 'umToPixel');
[cellIdsTend, cellIdsTstart, colonyIdsCellsTend] =  matchParentCellsWithKidCells(allColoniesCellStats, timeSteps);
%%
colonyIds = 2:7;
cellsToKeep = ismember(colonyIdsCellsTend, colonyIds);
if exist('cellIds', 'var')
    cellsToKeep = ismember(cellIdsTstart, cellIds);
end
cellIdsTend = cellIdsTend(cellsToKeep);
cellIdsTstart = cellIdsTstart(cellsToKeep);
colonyIdsCellsTend = colonyIdsCellsTend(cellsToKeep);

%% ------------------------ get lineage Ids of all cells and their positions at all timepoints
counter = 1;
cellLineageTreeIds = cell(1,length(cellIdsTend));
for ii = cellIdsTend
    [~,cellLineageTreeIds{1,counter}, xy(:,:,counter)] =  findDistanceMovedByACell(allColoniesCellStats, ii);
    counter = counter+1;
end

%% ------------------------ remove the cells which are a result of three cell divisions
cellIds_family = zeros(numel(cellIdsTstart), 4);
for ii = 1:numel(cellIdsTstart)
    tof = cellfun(@(x)(x(1,6)), allColoniesCellStats([cellLineageTreeIds{ii}])); %generation time for all cells in family.
    cellIds_family(ii, 1:numel(tof)) = cellLineageTreeIds{ii};
end

lastColumn = cellIds_family(:,4);
toRemove = find(lastColumn>0);

cellIds_family([toRemove],:) = [];
toKeep = max(cellIds_family,[],2);
[~,toKeep_idx] = intersect(cellIdsTend, toKeep);
%%
cellIdsTend = cellIdsTend(toKeep_idx);
cellIdsTstart = cellIdsTstart(toKeep_idx);
colonyIdsCellsTend = colonyIdsCellsTend(toKeep_idx);
%%
xy = xy(:,:,toKeep_idx);

%% turning angles of all cells, all timepoints
turningAngles = zeros(163, numel(cellIdsTend));
displacementVectors = diff(xy);

displacementVectors(:,3,:) = 0; % cross and dot products need 3 components

for ii = 1:163
    a1 = atan2d(cross(displacementVectors(ii,:,:),displacementVectors(ii+1,:,:)), ...
        dot(displacementVectors(ii,:,:),displacementVectors(ii+1,:,:)));
    turningAngles(ii,:) = a1(1,3,:);
end

%%
turningAngles_avgCell = mean(turningAngles,1);
turningAngles_avgT = mean(turningAngles,2);
%%
figure; histogram(turningAngles); title('turning angle');
%%
figure;
subplot(1,3,1); histogram(turningAngles); title('turning angle');
subplot(1,3,2); histogram(turningAngles_avgCell); title('Mean turning angle per cell');
subplot(1,3,3); histogram(turningAngles_avgT);title('Mean turning angle per time point');

%%
[startDistance, ~] = findRadialDisplacement(colonyCenters, allColoniesCellStats, colonyIdsCellsTend, cellIdsTstart, cellIdsTend);
startDistance = startDistance./umToPixel;
startDistanceEdge = 400-startDistance;
%%
% what is the mean speed of every cell across timepoints?
displacement = displacementVectors(:,1:2,:);
speed = squeeze(sqrt(sum((displacement.^2),2)));
%%
avg_speed_per_time = mean(speed,2);
avg_speed_per_cell = mean(speed, 1);

figure;
subplot(1,2,1);
plot([1:numel(avg_speed_per_time)], avg_speed_per_time');
subplot(1,2,2);
plot([1:numel(avg_speed_per_cell)], avg_speed_per_cell);
%%
% remove outlier from avg_speed_per_time
outlier = find(avg_speed_per_time > 2);
avg_speed_per_time(outlier) = [];
figure;
subplot(1,2,1);
plot([1:numel(avg_speed_per_time)], avg_speed_per_time'); ylim([0.8 2]); title('avg speed/time');
subplot(1,2,2);
plot([1:numel(avg_speed_per_cell)], avg_speed_per_cell); ylim([0.8 2]); title('avg speed/cell');
%%
speed = speed/umToPixel; % convert to microns
figure; histogram(speed);

%%
newOutputFile = ['/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles' filesep 'output2.mat'];
save(newOutputFile, 'speed', 'turningAngles');

%%
t1 = randi(163,4,1);
figure;
counter = 1;
for ii = t1'
    subplot(2,2,counter);
    histogram(turningAngles(ii,:), 'BinWidth', 20);
    counter = counter+1;
end












