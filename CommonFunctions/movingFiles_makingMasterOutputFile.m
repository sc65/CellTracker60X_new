%% LSM data moving output files, making a master output file.

clearvars -except outputFiles
%%
masterFolder = '/Volumes/SAPNA/170703_FISH_nodal_IF_t_bCat/25_29_33_37_47h/20X_LSM/rawData';
samples = {'t25_q1', 't29_q1_2', 't33_q1', 't33_q4', 't37_q3', 't37_q4'};
%%
newFolder = '/Volumes/SAPNA/170703_FISH_nodal_IF_t_bCat/25_29_33_37_47h/20X_LSM/rawData/masterOutputFiles';
for ii = 1:length(samples)
    outputFiles = dir([masterFolder filesep samples{ii} filesep 'outputFiles' filesep  '*.mat']);
    for jj = 1:numel(outputFiles)
        oldFile = [masterFolder filesep samples{ii} filesep 'outputFiles' filesep outputFiles(jj).name];
        newFile = [newFolder filesep 'output_' samples{ii} '_' int2str(jj) '.mat'];
        copyfile(oldFile, newFile);
    end
end
%%
files = dir(['./*.mat']);
newDapiMasks = cell(1,4);
newPeaks = newDapiMasks;

newRawImages = newDapiMasks;
counter = 1;
counter2 = 1;


for ii = 1:numel(files)
    load(files(ii).name);
    nColonies = size(peaks1,2);
    
    newDapiMasks(counter:counter+nColonies-1) = dapiMasks;
    newRawImages{counter2} = rawImages;
    newPeaks(counter:counter+nColonies-1) = peaks1;
    
    counter = counter+nColonies;
    counter2 = counter2+1;
end
%%
newOutputFile = '/Volumes/SAPNA/170703_FISH_nodal_IF_t_bCat/25_29_33_37_47h/30X_LSM/outputFiles/output_t37.mat';
dapiMasks = newDapiMasks;
peaks1 = newPeaks;


save(newOutputFile,'dapiMasks', 'peaks1', 'newRawImages');
%%
outputFiles1 = {'output_t25.mat', 'output_t29.mat', 'output_t33.mat', 'output_t37.mat'};































