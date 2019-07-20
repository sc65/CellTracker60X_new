%% saves iLastik Data in the form of a cell array - allCellStats.
% making allCellStats - a cell array, each cell corresponding to one "cell(object)" 
% each cell contains a table with [x y lineageId startTimeStep endTimeStep distanceFromBoundary] 

masterFolderPath = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5';
outputFilesPath = [masterFolderPath filesep 'outputFiles'];
mkdir(outputFilesPath);
%% 1) Make binary movies. 
trackIds = [1 2 4:6];
ilastikMaskPath = [masterFolderPath filesep 'images'];
saveInPath = [masterFolderPath filesep 'binaryMovies'];
makeBinaryMovie(ilastikMaskPath, saveInPath, trackIds);
%% ---------------------------------- Start here!!--------------------------------
colonyId = 10;
suffix = '_1';
%% 2) read output tables
resultTable = readtable([masterFolderPath filesep 'ImageParts/colony' int2str(colonyId) filesep 'part' suffix '-exported_data_table.csv']);

% Depending on the maximum number of merged cells(say n) trained in iLastik, there
% will be n columns corresponding to track Ids in the division table and
% consequently the columns corresponding to cell centers will change. 

% ----- Find column numbers corresponding to cell centers. 
columnNames = resultTable.Properties.VariableNames;
idx = strfind(columnNames, 'RegionCenter_0');
centerX = find(not(cellfun('isempty', idx)));

idx = strfind(columnNames, 'RegionCenter_1');
centerY = find(not(cellfun('isempty', idx)));

resultTable = table2array(resultTable);

divisionsTable = readtable([masterFolderPath filesep 'ImageParts/colony' int2str(colonyId) filesep 'part' suffix '-exported_data_divisions.csv']);
divisionsTable = table2array(divisionsTable);
%% 3) filter non-dying, correctly tracked cells.
mask = logical(imread([masterFolderPath filesep 'binaryMovies/Track' int2str(colonyId) '.tif'],1)); %cells in t = 1.
figure; imshow(mask);
colors = {[1 0.5 0 ], 'c'};
% find data in resultTable corresponding to t=1.
data1 = resultTable(resultTable(:,2) == 1-1,:); %time in table starts from 0.

centers = data1(:,[centerX centerY]);
lineageId = data1(:,4);

for ii = 1:size(data1,1)
    text(centers(ii,1), centers(ii,2), int2str(lineageId(ii)), 'Color', colors{1}, 'FontSize', 12, 'FontWeight', 'bold');
end
%%
oneOutputFilePath = [outputFilesPath filesep 'outputColony' int2str(colonyId) suffix '.mat'];
goodCells = [8 10]; %track Ids of cells present at t0.
umToPixel = 0.8050; %get this from the raw image. 
save(oneOutputFilePath, 'umToPixel', 'goodCells');
%%
% check if it is correct. 
data1 = resultTable(resultTable(:,2) == 1-1,:); %time in table starts from 0.
lineageIdNew = lineageId;
lineageIdNew(~ismember(lineageId, goodCells)) = [];

data1(~ismember(lineageId', goodCells),:) = [];
centers = data1(:,[centerX centerY]);
figure; imshow(mask);
hold on;
for ii = 1:size(data1,1)
    text(centers(ii,1), centers(ii,2), int2str(lineageIdNew(ii)), 'Color', colors{1}, 'FontSize', 12, 'FontWeight', 'bold');
end
%% 4) make a good colony mask. 
colonySegmentationMaskPath = '/Volumes/SAPNA/170221LiveCellImaging/colonyMorphology@tEnd/tend_Track3ch2_Simple Segmentation.h5';
makeColonyMask(colonySegmentationMaskPath, oneOutputFilePath);

%% 5) use that information to make allCellStats - a cell array with important information about movement of cells. 
makeAllStats(resultTable, divisionsTable, centerX, centerY, goodCells, oneOutputFilePath);





