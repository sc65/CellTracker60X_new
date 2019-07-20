%%
clearvars;
%%
figure;
dataDir = '.';
colSize = 400;
DAPIChannel = 4;
[nucAvgAllNormalized, r] = plotAveragesNoSegmentation(dataDir,colSize,DAPIChannel);

%% ----------------------------- radial average runFile
%% ----------------------------- 96 well plate.
%clearvars -except rawImagesPath1 maxRA1;
clearvars;
rawImagesPath = '/Volumes/SAPNA/171017_96wellPlateNew/tiffFiles';
condition_Id = [13 1]; control_condition = 13;
%legendLabels = {'control', '3I', '2I', 'IWP2', 'SB', 'LDN', 'LDN,IWP2', 'LDN, SB'};
legendLabels = {'control', 'with IWP2'};
outputFiles = cell(1,numel(condition_Id)); counter = 1;


for ii = condition_Id
    if ii < 48
        outputFiles{counter} = [rawImagesPath filesep 'Condition' int2str(ii)...
            filesep 'output.mat'];
    else
        outputFiles{counter} = [rawImagesPath filesep  'plate_2ndHalf' filesep 'Condition' int2str(ii)...
            filesep 'output.mat'];
    end
    counter = counter+1;
end

control_outputFile = '/Volumes/SAPNA/171017_96wellPlateNew/controls.mat';
load(control_outputFile);
place = find(conditions == control_condition); % find its place in the controls.
maxRA1 = maxRA(place,:);

%%
oF = dir(['*.mat']);
for ii = 1:4
    outputFiles{ii} = oF(ii).name;
end
%%
cDir = '.';
times = [25 30 35 40]; legendLabels = {'25h', '30h', '35h', '40h'}; 
counter = 1;

controlFile = [cDir filesep '40h/output.mat'];
load(controlFile, 'maxRA1');

for ii = times
    outputFiles{counter} = [cDir filesep int2str(ii) 'h' filesep 'output.mat'];
    counter = counter+1;
end
%% -----------------------------------

%% -----------------------------------
onlyCirclesPlotRadialAveragesInTime (outputFiles, legendLabels,  maxRA1);
%%












