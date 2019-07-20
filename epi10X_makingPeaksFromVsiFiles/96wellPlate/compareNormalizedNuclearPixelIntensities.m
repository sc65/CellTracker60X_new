%% compare normalized NuclearPixelIntensities

%%
clearvars; close all;
masterFolder = '/Volumes/SAPNA/180314_96wellPlates/plate1/tiffFiles';
conditionsToConsider = 24:31;

controlCondition = 31; % to compute intensities threshold

%% --- compute maximum intensity for different channels
outputFile = [masterFolder filesep 'Condition' int2str(controlCondition) filesep 'output.mat'];
load(outputFile, 'nuclearPixels_norm', 'colonyIds_good');

fields = fieldnames(nuclearPixels_norm);
pixels_max = zeros(1,4);

allPixels_control = cell(1,4);
for ii = 1:4
    for jj = colonyIds_good
        allPixels_control{ii} = cat(1, allPixels_control{ii}, nuclearPixels_norm(jj).(fields{ii}));
    end
end

for ii = 1:numel(fields)
    pixels_max(ii) = mean(allPixels_control{ii}) + 3*std(allPixels_control{ii});
end

%% ------------------------ plot histograms
%% ---- across colonies
channelLabels = {'Brachyury', 'sox2', 'cdx2', 'dapi'};

for condition = conditionsToConsider
    outputFile = [masterFolder filesep 'Condition' int2str(condition) filesep 'output.mat'];
    load(outputFile, 'nuclearPixels_norm', 'colonyIds_good');
    
    legendLabels = strcat('Colony', strsplit(int2str(colonyIds_good), ' '));
    figure;
    for ii = 1:4
        subplot(2,2,ii); hold on; title([channelLabels{ii} 'C' int2str(condition)]);
        if ii <4
            edges = [0:0.02:pixels_max(ii)];
        else
            edges = [0:100:pixels_max(ii)];
        end
        for jj = colonyIds_good
            histogram(nuclearPixels_norm(jj).(fields{ii}), edges, 'DisplayStyle', 'stairs',...
                'Normalization', 'probability');
        end
        if ii == 1
            legend(legendLabels);
        end
    end
end

%% ---- across conditions

allPixels = cell(4, numel(conditionsToConsider));
counter = 1;

for condition = conditionsToConsider
    outputFile = [masterFolder filesep 'Condition' int2str(condition) filesep 'output.mat'];
    load(outputFile, 'nuclearPixels_norm', 'colonyIds_good');
    
    for ii = 1:4
        for jj = colonyIds_good
            allPixels{ii, counter} = cat(1, allPixels{ii, counter}, nuclearPixels_norm(jj).(fields{ii}));
        end
    end
    counter = counter+1;
end

%%
conditionsToPlot = [1 3 4 5 8];
legendLabels = strcat('c', strsplit(int2str(conditionsToConsider(conditionsToPlot)), ' '));


for ii = 1:4
    figure; hold on;
    if ii == 1
        %edges = [0:0.01:0.2];
        edges = [0:0.001:pixels_max(ii)];
    elseif ii <4
        edges = [0:0.005:pixels_max(ii)];
    else
        edges = [0:100:pixels_max(ii)];
    end
    %subplot(2,2,ii); hold on;
    
    for jj = conditionsToPlot
        histogram(allPixels{ii, jj}, edges, 'DisplayStyle', 'stairs',...
                'Normalization', 'probability');
    end
    
    legend(legendLabels);
    title(channelLabels{ii});
end
%%
saveInPath = '/Volumes/SAPNA/180314_96wellPlates/plate1/intensityHistograms/iwp2';
saveAllOpenFigures(saveInPath);






