
%% ----------------------------------------------------------------------
masterFolder = '/Volumes/SAPNA/190522_sox2ReporterCells/imaging2';
rawImagesFolder = [masterFolder filesep 'rawData'];

oldFolders = dir(rawImagesFolder);
toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{oldFolders.name},'UniformOutput',false)));
oldFolders = oldFolders(toKeep);


saveInFolder = [masterFolder filesep 'processedData'];
mkdir(saveInFolder);
%%
newFolders = {{'betaCateninCells'}};
%newFolders = {{'bmp_45h_1',  'bmp_45h_2', 'lefty_4', 'lefty_3', 'lefty_2', 'lefty_1'}};
    
    %{'III_bmp', 'IV_bmp', 'III_SB', 'IV_SB', 'III_IWP2', 'IV_IWP2'};
   % {'V_bmp', 'V_SB', 'V_IWP2'}}; % subfolders within each folder
%%
% ----- get metadata
oldFolder1 = [oldFolders(1).folder filesep oldFolders(1).name];
fileInfo = dir([oldFolder1 filesep sprintf('Track%04d', 1) filesep '*oif']);
file1 = [fileInfo.folder filesep fileInfo.name];
meta = MetadataMicropattern(file1);

meta.colRadiiMicron = 350;
meta.channelNames = {'DAPI', 'T'};
% add if nuclear(N) or non-nuclear intensity(NN) be quantified
meta.channelLabel = {'nuclear', 'nuclear', 'nuclear', 'nuclear'};
save([masterFolder filesep 'metadata.mat'], 'meta');

%%
% ------ find colony ids corresponding to each well
for ii = 1:size(newFolders,1)
    close all;
%for ii = 2:size(newFolders,1)
    logFile = [oldFolders(ii).folder filesep oldFolders(ii).name filesep 'MATL_Mosaic.log'];
    [~, colonySeparation] = findColoniesInEachWell(logFile);
    figure; plot([1:numel(colonySeparation)], colonySeparation);
    %%
    threshold = 4820;
    colonyIds = (find(colonySeparation>threshold))';
    nColonies = length(colonySeparation)+1;
    
    if numel(colonyIds) > 1
        lastID = colonyIds(end);
    else
        lastID = 0;
    end
    if lastID < nColonies
        colonyIds = [colonyIds nColonies];
    end
    
    colonyIds = [0 colonyIds];
    %%
    
    oldFolder1 = [oldFolders(ii).folder filesep oldFolders(ii).name];
    oldFolder1_files = dir(oldFolder1);
    toKeep = find(cell2mat(cellfun(@(c)strcmp(c(1),'T'),{oldFolder1_files.name},'UniformOutput',false))); % keep only tracks
    oldFolder1_files = oldFolder1_files(toKeep);
    

    
    %for jj = 1:3
    for jj = 1:numel(colonyIds)-1
        close all;
        newFileFolder = [saveInFolder filesep newFolders{ii}{jj}];
        mkdir(newFileFolder);
        
        ids = colonyIds(jj)+1:colonyIds(jj+1);
        colonyCounter = 1;
        
        for kk = ids
            fileInfo = dir([oldFolder1_files(kk).folder filesep oldFolder1_files(kk).name filesep '*oif']);
            file1 = [fileInfo.folder filesep fileInfo.name];
            
            saveColonyImagesColonyMask(file1, newFileFolder, colonyCounter, meta);
            colonyCounter = colonyCounter+1;
        end
        
        
    end
end

