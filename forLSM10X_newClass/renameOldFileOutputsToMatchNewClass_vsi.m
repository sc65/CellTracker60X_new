
%% change all file outputs to match new file output.

%%
masterFolder = '/Volumes/SAPNA/180314_96wellPlates/plate1';

samplesFolder = [masterFolder filesep 'processedData'];
samples = dir(samplesFolder);
toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{samples.name},'UniformOutput',false))); % remove non-named folders
samples = samples(toKeep);
[~, idx] = natsortfiles({samples.name});
samples = samples(idx);

%%
for ii = [1 25:31]
    %for idx = 1:numel(samples)
    % update metadata
    %     metadataFile = [samplesFolder filesep samples(ii).name filesep 'metaData.mat'];
    %     load(metadataFile);
    %     meta.channelNames = {'DAPI', 'brachyury', 'sox2', 'cdx2'};
    %     % add if nuclear(N) or non-nuclear intensity(NN) be quantified
    %     meta.channelLabel = {'nuclear', 'nuclear', 'nuclear', 'nuclear'};
    %     save(metadataFile, 'meta');
    
    % rename old outputfile
    oldFile = [samplesFolder filesep samples(ii).name filesep 'output.mat'];
    newFile = [samplesFolder filesep samples(ii).name filesep 'output1.mat'];
    movefile(oldFile, newFile);
    %%
    oldFolder = [samplesFolder filesep samples(ii).name filesep 'colonies'];
    newFolder = [samplesFolder filesep samples(ii).name];
    %movefile(oldFolder, newFolder);
    
    %% rename masks
    files = dir([oldFolder filesep '*.h5']);
    for jj = 1:numel(files)
        idx1 = strfind(files(jj).name, 'id');
        idx2 = strfind(files(jj).name, '_c');
        idx = files(jj).name(idx1+2:idx2-1);
        newName = ['colony' idx '_ch1_Simple Segmentation.h5'];
        movefile([files(jj).folder filesep files(jj).name], [newFolder filesep newName]);
    end
    
    %% delete _c1 tif files
    files = dir([oldFolder filesep '*c1.tif']);
    for jj = 1:numel(files)
        delete([files(jj).folder filesep files(jj).name]);
    end
    
    %% process images, save with new names
    files = dir([oldFolder filesep 'col_*.tif']);
    for jj = 1:numel(files)
        idx1 = strfind(files(jj).name, 'id');
        idx2 = strfind(files(jj).name, '.');
        idx = files(jj).name(idx1+2:idx2-1);
        
        for kk = 1:4
            image1 = imread([files(jj).folder filesep files(jj).name], kk);
            image1 = smoothAndBackgroundSubtractOneImage(image1);
            
            if kk == 1
                imwrite(image1, [newFolder filesep 'colony' idx '_ch1.tif']);
                imwrite(image1, [newFolder filesep 'colony' idx '.tif']);
                colonyMask = makeColonyMaskUsingDapiImage(image1, meta);
                %figure; imshowpair(image1, colonyMask); title(idx);
                imwrite(colonyMask, [newFolder filesep 'colony' idx '_colonyMask.tif']);
            else
                imwrite(image1, [newFolder filesep 'colony' idx '.tif'], 'WriteMode', 'append');
            end
        end
        
    end
    
    %% delete old files
    files = dir([oldFolder filesep 'col_*.tif']);
    for jj = 1:numel(files)
        delete([files(jj).folder filesep files(jj).name]);
    end
    rmdir(oldFolder, 's');
end