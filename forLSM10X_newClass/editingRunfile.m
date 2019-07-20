
%% ------- LSM 10/20X, consolidated analyses code
% 1) get position ids per well
% 2) specify positions per colony (n)
% 3) align n positions to get the colony image
% 4) save colony images(all channels, nuclear channel) and colony mask
% 5) move to ilastik to make nuclear masks
% 6) get colony radial profiles

%% --------------------------------------------------------------------------------------
masterFolder = '/Volumes/SAPNA/190719_wntDuration';
% newFolders = {{'BMP_BMP', 'BMPDkk_BMP', 'BMPLefty_BMPLefty', 'BMP', 'BMPLefty_BMP', 'BMPDkk_BMPDkk',...
%     'BMPLefty_notImaged', 'BMPDkk_notImaged', 'BMP_notImaged'}}; % one folder per well

newFolders = {{'Bmp', 'BmpIwp2_0h', 'BmpIwp2_20h', 'BmpDkk_20h', ...
    'BmpIwp2_28h', 'BmpDkk_28h', 'BmpDkk_0h'}};

channelNames = {'DAPI', 'T', 'smad2' 'smad1'};
channelLabels = {'nuclear', 'nuclear', 'nuclear', 'nuclear'}; % nuclear or non-nuclear intensity needs to be quantified
colonyRadius = 350; % in microns
alignmentChannel = 1;

rawImagesFolder = [masterFolder filesep 'rawData'];
oldFolders = dir(rawImagesFolder);
toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{oldFolders.name},'UniformOutput',false)));
oldFolders = oldFolders(toKeep);
saveInFolder = [masterFolder filesep 'processedData'];
mkdir(saveInFolder);
%%
% ----- specify metadata
oldFolder1 = [oldFolders(1).folder filesep oldFolders(1).name];
fileInfo = dir([oldFolder1 filesep sprintf('Track%04d', 1) filesep '*oif']);
file1 = [fileInfo.folder filesep fileInfo.name];
meta = MetadataMicropattern(file1);
meta.colRadiiMicron = colonyRadius;
meta.channelNames = channelNames;
meta.channelLabel = channelLabels;
save([masterFolder filesep 'metadata.mat'], 'meta');
%%
% 1) get position ids per well
logFile = [oldFolders(1).folder filesep oldFolders(1).name filesep 'MATL_Mosaic.log'];
files = readLSMmontageDirectory(oldFolder1, logFile);
imagesPerColony = files.imagesPerColony_x(1)*files.imagesPerColony_y(1);
% check if imagesPercolony makes sense. If not, play with distance threshold
% current distance threshold = 5000 pixels

%%
if  imagesPerColony >1
    idx = 1;
    for ii = 1:files.nWells
        colonyCounter = 1;
        newFolders_well = [saveInFolder filesep newFolders{1}{ii}];
        mkdir(newFolders_well);
        for jj = idx:idx+files.coloniesPerWell(ii)-1
            finalImage = align3by3LSMImage(files, jj, alignmentChannel); % align
            newImagePath = [newFolders_well filesep 'colony' int2str(colonyCounter)];
            saveColonyImagesColonyMask_new(newImagePath, finalImage, meta);
            colonyCounter = colonyCounter+1;
        end
        idx = idx+files.coloniesPerWell(ii);
    end
end
%%

