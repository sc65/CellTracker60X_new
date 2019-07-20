
%%

% combines radial average for colonies in a regular dish

masterFolder = '/Volumes/sapnaDrive2/snail_check/experiment2/snail_sox2_nanog';
metadata  = [masterFolder filesep 'metadata.mat'];
load(metadata);
%%
samplesFolder = [masterFolder filesep 'processedData'];
samples = dir(samplesFolder);

toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{samples.name},'UniformOutput',false))); % remove non-named folders
samples = samples(toKeep);
%%
sampleId = 1;
outputFile = [samplesFolder filesep samples(sampleId).name filesep 'output.mat'];
load(outputFile);

%%
%% ----------------------------------------------------------------
%% ----------------------------------------------------------------
%%
badColoniesId = [];
if ~isempty(badColoniesId)
    goodColoniesId = setxor([1:numel(colonies)], badColoniesId);
else
    goodColoniesId = 1:numel(colonies);
end

%% --------------------------
%% -------------------------- plot
%% --------------------------

% std deviation
% dapiNormalized
nBins = size(radialProfile_avg.dapiNormalized.mean,1);
xValues = 0.5*(colonies(2).radialProfile.bins(1:end-1)+colonies(2).radialProfile.bins(2:end));
figure;
for ii = 1:meta.nChannels
    subplot(2,2,ii);
    errorbar(xValues(1:nBins)', radialProfile_avg.dapiNormalized.mean(:,ii), radialProfile_avg.dapiNormalized.std(:,ii));
    title(meta.channelNames{ii});
end

% notNormalized
figure;
for ii = 1:meta.nChannels
    subplot(2,2,ii);
    errorbar(xValues(1:nBins)', radialProfile_avg.notNormalized.mean(:,ii), radialProfile_avg.notNormalized.std(:,ii));
    title(meta.channelNames{ii});
end

%%
% std error
% dapiNormalized
figure;
for ii = 1:meta.nChannels
    subplot(2,2,ii);
    errorbar(xValues(1:nBins)', radialProfile_avg.dapiNormalized.mean(:,ii), radialProfile_avg.dapiNormalized.stdError(:,ii));
    title(meta.channelNames{ii});
end

% notNormalized
figure;
for ii = 1:meta.nChannels
    subplot(2,2,ii);
    errorbar(xValues(1:nBins)', radialProfile_avg.notNormalized.mean(:,ii), radialProfile_avg.notNormalized.stdError(:,ii));
    title(meta.channelNames{ii});
end

%%
% save
xValues = xValues(1:nBins);
save(outputFile, 'radialProfile_avg', 'goodColonies', 'xValues', 'colonyCounter', '-append');

saveInPath = [samplesFolder filesep samples(sampleId).name filesep 'rA_plots'];
saveAllOpenFigures(saveInPath);




















