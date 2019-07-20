
%% change all file outputs to match new file output.

%%
masterFolder = '/Volumes/SAPNA/180314_96wellPlates/Lsm20X/allConditionsMoreImages/smad2_data/plate2/imaging2';
file1 = [masterFolder filesep 'rawData/plate2_30_35_40h_2/Track0001/Image0001_01.oif'];
meta = MetadataMicropattern(file1);

meta.colRadiiMicron = 350;
meta.channelNames = {'DAPI', 'brachyury', 'smad1', 'smad2'};
% add if nuclear(N) or non-nuclear intensity(NN) be quantified
meta.channelLabel = {'nuclear', 'nuclear', 'nuclear', 'nuclear'};
save([masterFolder filesep 'metadata.mat'], 'meta');

%%
% rename colonies, colony, nuclear masks

samplesFolder = [masterFolder filesep 'processedData'];
samples = dir(samplesFolder);

toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{samples.name},'UniformOutput',false))); % remove non-named folders
samples = samples(toKeep);

%%
for idx = 1:numel(samples)
    %% remname old outputFile
    outputFile = [samples(idx).folder filesep samples(idx).name filesep 'output.mat'];
    movefile(outputFile, [samples(idx).folder filesep samples(idx).name filesep 'output1.mat']);
    
    %% rename masks
    files = dir([samples(idx).folder filesep samples(idx).name filesep '*.h5']);
    for ii = 1:numel(files)
        newName = ['colony' int2str(ii) '_ch1_Simple Segmentation.h5'];
        movefile([files(ii).folder filesep files(ii).name], [files(ii).folder filesep newName]); 
    end
    
    files = dir([samples(idx).folder filesep samples(idx).name filesep 'maskColony*']);
    for ii = 1:numel(files)
        newName = ['Colony_' int2str(ii) '_colonyMask.tif'];
        movefile([files(ii).folder filesep files(ii).name], [files(ii).folder filesep newName]);
    end
    
    files = dir([samples(idx).folder filesep samples(idx).name filesep 'maskNuclear*']);
    for ii = 1:numel(files)
        newName = ['Colony_' int2str(ii) '_nuclearMask.tif'];
        movefile([files(ii).folder filesep files(ii).name], [files(ii).folder filesep newName]);
    end
    
    %% rename images
    files = dir([samples(idx).folder filesep samples(idx).name filesep 'Colony_*']);
    for ii = 1:numel(files)
        % remove first underscore
        % de-capitalize C.
        newName = files(ii).name;
        idx1 = strfind(newName, '_');
        newName(idx1(1)) = '';
        idx1 = strfind(newName, 'C');
        newName(idx1(1)) = 'c';
        movefile([files(ii).folder filesep files(ii).name],[files(ii).folder filesep newName]);
    end
end