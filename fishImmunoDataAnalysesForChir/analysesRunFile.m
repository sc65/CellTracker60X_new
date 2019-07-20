%% run file
clearvars;
outputFilePath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/withMiki/170914_WntLowHighDensity_timeCourse/outputFiles';
cd (outputFilePath);
%%
outputFilesInfo = dir([outputFilePath filesep 'output*']);
nSamples = numel(outputFilesInfo);
combineAllSamplesData(nSamples);
%%
load('allSamplesData.mat');
%%
dapiChannel = 5;
allSamplesData = normaliseDapi(allSamplesData, dapiChannel);
%%
sampleNames = cell(1,nSamples);
for ii = 1:nSamples
    namePart = strsplit(imagesPath{ii}, '/');
    sampleNames{ii} = namePart{end};
    %sampleNames{ii} = namePart{1};
end
sampleNames
%% possible variations to compare across different samples. - assign a value to functionToUse
% 1 -'DAPI', check if the dapi range across different samples is similar. If
% not, call the function normaliseDapi.
% 2 - 4 'nuclear smad2', 'total smad2', 'nuclear/cytoplasmic smad2',  ...
% 5 - 7 'nuclear nodal', 'total nodal', 'nuclear/cytoplasmic nodal', ...
% 8 - 10 'nuclear T', 'total T', 'nuclear/cytoplasmic T'} ...
%% sample Names
% 'chir12h'    'chir18h'    'chir24h'    'chir30h'
%
%   Columns 5 through 8
%
%     'chir36h'    'chir6h'    'control'    'wnt12'
%
%   Columns 9 through 13
%
%     'wnt18h'    'wnt24h'    'wnt30h'    'wnt36h'    'wnt6h'

%%
%samplesToCompare = {[3 1], [5 4], [7 6], [9 8]};
samplesToCompare = {[1 4], [6 10]};
functionsToUse = [2];
colors = {[1 0.7 0.7], [1 0 0]};
compareDataDistributionsNodalLeftySmad2(allSamplesData, functionsToUse, sampleNames, samplesToCompare, colors);
%%
% How do nuclear Brachyury levels vary in time? - normalize to the mean of
% the control sample.
colors = {[0 0 1], [1 0 0],  [0 0.5 0], [0 0 0.5], [0 0.5 0.5]};
samplesToCompare = {[1:5], [6:10]};
legendLabels = {'HighDensity', 'LowDensity'};
%legendLabels = sampleNames;
samplesToUse = [1 2];
xTickLabels = {'0h', '2h', '4h', '6h', '8h'}; 
%xTickLabels = {'Control', 'Treatment'};

samplesToCompare = samplesToCompare(samplesToUse);

titles = {'smad2'};
counter = 1;
for ff = 2
    figure;
    hold on;
    
    for jj = 1:size(samplesToCompare,2)
        plot(0,0,'Color',colors{samplesToUse(jj)});
    end
    [~,objh] = legend(legendLabels(samplesToUse));
    set(objh,'linewidth',2);
         
    [~, functions] = defineFunctions();
    fun = functions{ff};
    
      
    for ii = 1:length(samplesToCompare)
         data = allSamplesData{samplesToCompare{ii}(1)}; % mean value of the control sample
         normaliseTo = mean(fun(data));
         %normaliseTo = 1;
        plotTrends(allSamplesData, ff, samplesToCompare{ii}, colors{samplesToUse(ii)}, normaliseTo, xTickLabels);
    end
    title(titles{counter});
    counter = counter+1;
end

%%
for samplesToUse = 5
    samples = sampleNames(samplesToUse);
    plotCorrelationsSmad2NodalLefty (allSamplesData, samplesToUse, samples);
end

