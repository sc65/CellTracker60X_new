
%% ------- SD 10X/20X, consolidated analyses code
% 1) get position ids per well
% 2) specify positions per colony (n)
% 3) align n positions to get the colony image
% 4) save colony images(all channels, nuclear channel) and colony mask
% 5) move to ilastik to make nuclear masks
% 6) get colony radial profiles

%% --------------------------------------------------------------------------------------
masterFolder = '/Volumes/SAPNA/190707_bCAtLDN';
% newFolders = {{'BMP_BMP', 'BMPDkk_BMP', 'BMPLefty_BMPLefty', 'BMP', 'BMPLefty_BMP', 'BMPDkk_BMPDkk',...
%     'BMPLefty_notImaged', 'BMPDkk_notImaged', 'BMP_notImaged'}}; % one folder per well

newFolders = {{'BmpLDN20h', 'BmpLDN10h', 'Bmp'}};

channelNames = {'DAPI', 'betaCatenin', 'Brachyury'};
channelLabels = {'nuclear', 'non-membrane', 'nuclear'}; % nuclear or non-nuclear intensity needs to be quantified
colonyRadius = 350; % in microns

rawImagesFolder = [masterFolder filesep 'rawData'];
oldFolders = dir(rawImagesFolder);
toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{oldFolders.name},'UniformOutput',false)));
oldFolders = oldFolders(toKeep);
saveInFolder = [masterFolder filesep 'processedData'];
mkdir(saveInFolder);
%%
% ----- specify metadata
oldFolder1 = [oldFolders(1).folder filesep oldFolders(1).name];
fileInfo = dir([oldFolder1 filesep 'bCAt3_20190707_43650 PM' filesep sprintf('*_f%04d_z%04d_w%04d.tif', 0,0,0)]);
file1 = [fileInfo.folder filesep fileInfo.name];
meta = MetadataMicropattern(file1);
meta.colRadiiMicron = colonyRadius;
meta.channelNames = channelNames;
meta.channelLabel = channelLabels;
save([masterFolder filesep 'metadata.mat'], 'meta');
%%
% 1) get position ids per well
files.dir = oldFolder1;
files.nWells = 3;
files.imagesPerColony_x = repmat(2,1,15);
files.imagesPerColony_y = ones(1,15);
files.coloniesPerWell = [5 5 5];
imagesPerColony = files.imagesPerColony_x(1)*files.imagesPerColony_y(1);

%%
% ----- read colony files within the rawdata folder
colonyFolders = dir(files.dir);
toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{colonyFolders.name},'UniformOutput',false)));
colonyFolders = colonyFolders(toKeep);
[~, idx] = natsortfiles({colonyFolders.name});
colonyFolders = colonyFolders(idx);
%%
side = 4;
overlap = 1020;
alignmentChannel = 1;
if  imagesPerColony >1
    idx = 1;
    for ii = 1:files.nWells
        colonyCounter = 1;
        newFolders_well = [saveInFolder filesep newFolders{1}{ii}];
        mkdir(newFolders_well);
        for jj = idx:idx+files.coloniesPerWell(ii)-1
            % read images, make maxz projections, align
            filesColony1 = readAndorDirectory([colonyFolders(jj).folder filesep colonyFolders(jj).name]);
            alignedImage = readAlignAndorTwoImagesPerColony(filesColony1, side, overlap, alignmentChannel);
            newImagePath = [newFolders_well filesep 'colony' int2str(colonyCounter)];
            saveColonyImagesColonyMask_new(newImagePath, alignedImage, meta);
            colonyCounter = colonyCounter+1;
        end
        idx = idx+files.coloniesPerWell(ii);
    end
end
%%
% write beta-catenin images
for ii = 1:files.nWells
    newFolders_well = [saveInFolder filesep newFolders{1}{ii}];
    for jj = 1:files.coloniesPerWell
        image1 = imread([newFolders_well filesep 'colony' int2str(jj) '.tif'],2);
        imwrite(image1, [newFolders_well filesep 'colony' int2str(jj) '_ch2.tif']);
    end
end


%%
function alignedImage = readAlignAndorTwoImagesPerColony(filesColony1, side, overlap, alignmentChannel)
% ----- read colony images
colonyImages = cell(1,2);
for jj = filesColony1.p
    % read images - all channels,  all z slices
    % make max z projections
    % smooth, backgroundsubtract
    % align
    for kk = filesColony1.w
        colonyImages{jj+1}(:,:,kk+1) =andorMaxIntensity(filesColony1,jj,0,kk);
        colonyImages{jj+1}(:,:,kk+1) = smoothAndBackgroundSubtractOneImage(colonyImages{jj+1}(:,:,kk+1));
    end
end
% ----- align colony images
[alignedImage, ~, ~]= alignTwoImagesFourier_multiChannel(colonyImages{1}, colonyImages{2},  side, overlap, alignmentChannel);
end











