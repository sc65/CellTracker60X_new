
%% combine output from multiple conditions
% recalculate good colony indices, radialAverages,
% plot, save

%%
masterFolder = '/Volumes/sapnaDrive2/190210_dkk_timing';
outputfilesFolder = '/Volumes/sapnaDrive2/190210_dkk_timing/combinedOutputFiles';

metadata  = [masterFolder filesep 'metadata.mat'];
load(metadata);

samplesFolder = [masterFolder filesep 'processedData'];
samples = dir(samplesFolder);
toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{samples.name},'UniformOutput',false))); % remove non-named folders
samples = samples(toKeep);

%%
counter = 1;
for ii = 1:2:numel(samples)
    ii
    outputFile1 = [samples(1).folder filesep samples(ii).name '/output.mat'];
    load(outputFile1, 'colonies', 'goodColoniesId');
    colonies1 = colonies;
    gIdx = goodColoniesId;
    
    outputFile2 = [samples(1).folder filesep samples(ii+1).name '/output.mat'];
    load(outputFile2, 'colonies', 'goodColoniesId');
    colonies2 = colonies;
    gIdx = [gIdx goodColoniesId+numel(colonies1)];
    
    colonies3 = [colonies1, colonies2];
    radialProfile_avg = computeCombinedRadialAverage(colonies3, gIdx);
    size(radialProfile_avg.dapiNormalized.mean,2)
    
    colonies = colonies3; goodColoniesId = gIdx;
    sampleNames = {samples(ii).name, samples(ii+1).name};
    save([outputfilesFolder '/output' int2str(counter) '.mat'], 'sampleNames', 'colonies', 'goodColoniesId', 'radialProfile_avg');
    counter = counter+1;
end


%%
% chek if radial averages make sense
outputfiles = dir([outputfilesFolder filesep '*.mat']);

for ii = 1:numel(outputfiles)
    load([outputfiles(ii).folder filesep outputfiles(ii).name]);
    figure; title(sampleNames{1});
    for jj = 1:meta.nChannels
        subplot(2,2,jj);
        errorbar(xValues, radialProfile_avg.dapiNormalized.mean(jj,:), radialProfile_avg.dapiNormalized.stdError(jj,:));
        %title(meta.channelNames{jj});
        title(sampleNames{1});
    end
end
%%



