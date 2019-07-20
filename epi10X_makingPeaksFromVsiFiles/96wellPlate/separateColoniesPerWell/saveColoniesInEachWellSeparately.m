%%
clearvars;
masterFolder = '/Volumes/sapnaDrive2/181113_leftyMediaChange_18_32h';
rawImagesPath = [masterFolder filesep 'rawImages'];
alignedImagesPath = [masterFolder filesep 'colonyImages/'];

alignedImagesPath2 = [masterFolder filesep 'colonyImages'];
mkdir(alignedImagesPath2);

%%
samples = dir([rawImagesPath]);
samples(1:2) = [];
%samples([1:4 6]) = [];

%% define newfolders in the order of wells imaged
newFolder1 =     strcat('top', strsplit(int2str(([1 2])), ' '));
%newFolder2 = 'bottom4';
%newFolder2=  strcat('ldn_', strsplit(int2str(fliplr([0 10:5:25])), ' '), 'h');
%newFolder3 =  strcat('sb_', strsplit(int2str(fliplr([0 10:5:40])), ' '), 'h');

newFolders = [newFolder1]; %, newFolder2]; %, newFolder3];

for ii = 1:length(newFolders)
    mkdir([alignedImagesPath2 filesep newFolders{ii}]);
end
%%
newFolderCounter = 1;
%%
for ii = 2
%for ii = 1:length(samples)
    newFolderCounter
    logFile = [rawImagesPath filesep samples(ii).name filesep 'MATL_Mosaic.log'];
    colonyIds_start = findColoniesInEachWell(logFile);
    colonyIds_start = [0; colonyIds_start];
    %%

    
    for jj = 1:numel(colonyIds_start)-1
        
        fileCounter = 1;
        %fileCounter = numel(dir([alignedImagesPath2 filesep newFolders{newFolderCounter} filesep '*_ch1.tif'])) + 1;
       
        for kk = colonyIds_start(jj)+1:colonyIds_start(jj+1)
            moveFile1 = [alignedImagesPath filesep samples(ii).name filesep 'Colony_' int2str(kk) '.tif'];
            moveFile2 = [alignedImagesPath filesep samples(ii).name filesep 'Colony_' int2str(kk) '_ch2.tif'];
            
            newFile1 = ['Colony_' int2str(fileCounter) '.tif'];
            newFile2 = ['Colony_' int2str(fileCounter) '_ch3.tif'];
            
            copyTo = [alignedImagesPath2 filesep newFolders{newFolderCounter}];
            
            copyfile(moveFile1, [copyTo filesep newFile1]);
            copyfile(moveFile2, [copyTo filesep newFile2]);
            
            fileCounter = fileCounter+1;
        end
        newFolderCounter = newFolderCounter+1;
    end
    
end  
    
