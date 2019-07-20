%% ---- classify colony shapes

outputFile = 'output1.mat';
load(outputFile);
%%
plotnum = 1;
figure;
for ii = goodColonies
    subplot(10,7, plotnum);
    plotnum = plotnum+1;
    plot(plate1.colonies(ii).data(:,1), -plate1.colonies(ii).data(:,2), 'k.');
    title(['Colony' int2str(ii)]);
end
%%
toRemove = [2 13 58 74 83 84 93 103 113];
goodColonies = setxor(goodColonies, toRemove);
%%
save(outputFile, 'goodColonies',  '-append');

%%
manualClassifierGoodColonies(outputFile);

%% ---------------- make colony images


masterFolder = '/Volumes/sapnaDrive2/180628_shapesChip1';
saveInPath = [masterFolder filesep 'colonyImages'];
mkdir(saveInPath);

samples = strcat('MMdirec', strsplit(int2str([1 3:8])), ' ');
colonyPrefices = strcat('mm', strsplit(int2str([1 3:8])), '_');

counter = 1;
%%
for ii = 4:numel(samples)
    colonyPrefix = colonyPrefices{counter};
    samplesPath = [masterFolder filesep  'mmImages' filesep samples{counter}];
    
    outputFile = [samplesPath filesep 'output1.mat'];
    load(outputFile, 'plate1', 'acoords');
    
    for shapeNum = [1 6 13:18]
        makeColonyImages_mm_separateChannels(samplesPath, saveInPath, plate1, acoords, shapeNum, colonyPrefix);
    end
    counter = counter+1;
end


%% --------------------- combine outputfiles
outputFiles = strcat(masterFolder, '/mmImages/MMdirec', strsplit(int2str([1:8])), '/output1.mat');

newOutputFile = [masterFolder filesep 'output.mat'];
makeMasterOutputFile(outputFiles, newOutputFile);

%% -------------------- 
circles = find([plate1.colonies.shape] == 18);

plotnum = 1;
figure;
for ii = circles
    subplot(5,5, plotnum);
    plotnum = plotnum+1;
    plot(plate1.colonies(ii).data(:,1), -plate1.colonies(ii).data(:,2), 'k.');
    title(['Colony' int2str(ii)]);
end


