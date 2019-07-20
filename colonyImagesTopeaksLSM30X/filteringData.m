
%%
clearvars;
masterFolder = '/Volumes/SAPNA/170825_smad2_bestSeeding_Idse/LsmData_30X/alignedImages';

timePoints = 24:4:48;
outputFiles = cell(1, numel(timePoints));

counter = 1;
for ii = timePoints
    outputFiles{counter} = [masterFolder filesep int2str(ii) 'h/output_', int2str(ii) 'h.mat'];
    counter = counter+1;
end

%% troubleshoot!
% check if the nuclear masks for 44h, 48h are correct.
sampleNum = 4;
outputFile = outputFiles{sampleNum};
load(outputFile);
%%
% for imageNum = 1:size(peaks1,2)
%     rawImage = imread([rawImages(imageNum).folder filesep rawImages(imageNum).name]);
%     figure; imshowpair(dapiMasks{imageNum}, rawImage);
% end

%% --------------------- remove cells outside the colony
figure;
for ii = 1:size(peaks1,2)
    data = peaks1{ii}(:,1:2);
    data = data-mean(data);
    subplot(4,2,ii);
    plot(data(:,1), data(:,2), 'k.');
end

%%
for ii = 1:size(peaks1,2)
    plate1.colonies(ii).data = peaks1{ii};
    plate1.colonies(ii).shape = 2;
end
%%
colonyId = 1:size(peaks1,2);
plate1 = removeCellsNotInColony(plate1, colonyId);
%%

%% ------------------- dapi values across samples

% removing cells above a given fluorescence.
shapeNum  = 2
for columnNum = [5 6 8 10]
    plotHistogramOfExpressionLevelsAllColonies(plate1, shapeNum, columnNum)
end

%%
fluorescence = [3000 5000 6000 5000];
counter = 1;
for columnNum = [5 6 8 10]
    plate1 = removeCellsAboveFluorescence(plate1, coloniesInShape, columnNum, fluorescence(counter));
    counter = counter+1;
end
%%
for ii = 1:size(peaks1,2)
    peaks1{ii} = plate1.colonies(ii).data;
    plate1.colonies(ii).shape = 2;
end
%%
umToPixel = 2.32;
save(outputFile1, 'peaks1', 'umToPixel', '-append');
%%












