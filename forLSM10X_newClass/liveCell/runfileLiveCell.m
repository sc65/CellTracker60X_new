
%% ---- runfile for lsm live cell imaging data
% for every well, align all colonies for all timepoints 
% save one aligned file for each channel


%% --------------------------------------------------------------------------------------
%% ---------- 1) from raw data to aligned movies
%% --------------------------------------------------------------------------------------
masterFolder = '/Volumes/sapnaDrive2/190605_bCatLiveCell';
newFolders = {'BMP_BMP', 'BMPDkk_BMP', 'BMPLefty_BMPLefty', 'BMP', 'BMPLefty_BMP', 'BMPDkk_BMPDkk'}; % one folder per well

channelNames = {'betaCatenin', 'nuclearMarker'};
channelLabels = {'nonMembrane', 'nuclear'}; % nuclear or non-nuclear intensity needs to be quantified
colonyRadius = 350; % in microns
alignmentChannel = 2;

rawImagesFolder = [masterFolder filesep 'rawData'];
imagingSessions = dir(rawImagesFolder);
toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{imagingSessions.name},'UniformOutput',false)));
imagingSessions = imagingSessions(toKeep);
saveInFolder = [masterFolder filesep 'processedData'];
mkdir(saveInFolder);
%%
% ----- specify metadata
oldFolder1 = [imagingSessions(1).folder filesep imagingSessions(1).name];
fileInfo = dir([oldFolder1 filesep sprintf('Track%04d', 1) filesep '*oif']);
file1 = [fileInfo(1).folder filesep fileInfo(1).name];
meta = MetadataMicropattern(file1);
meta.colRadiiMicron = colonyRadius;
meta.channelNames = channelNames;
meta.channelLabel = channelLabels;
save([masterFolder filesep 'metadata.mat'], 'meta');
%%
% --------------------- for each imaging session
sessionFiles = cell(1, numel(imagingSessions)); timepoints = zeros(1, numel(imagingSessions));
for ii = 1:numel(imagingSessions)
    oldFolder1 = [imagingSessions(ii).folder filesep imagingSessions(ii).name];
    logFile = [imagingSessions(ii).folder filesep imagingSessions(ii).name filesep 'MATL_Mosaic.log'];
    sessionFiles{ii} = readLSMmontageDirectory(oldFolder1, logFile);
    timepoints(ii) = sessionFiles{ii}.timepoints;
end

%%
% ---- align all colonies, all timepoints, save separately
% well->colony->all timepoints (switch from session1 to session2 when
% needed

% file Id array
fileIdx = [ones(1, timepoints(1)), repmat(2, timepoints(2)), repmat(3, 1, timepoints(3))];
files1 = sessionFiles{1}; % well, colony, imagex,y information is same in both sessions
%%
colonyCounter = 1; % colony id overall
for ii = 1:files1.nWells
    % make new output folder
    cIdx = 1; %colony Id in well
    wellPath = [saveInFolder filesep newFolders{ii}];
    mkdir(wellPath);
    
    %for jj = 20:21
    for jj = colonyCounter:colonyCounter+files1.coloniesPerWell(ii)-1
        % align each colony for all timepoints, save
        
        colonyPath = [wellPath filesep 'colony' int2str(cIdx)];
        tIdx = 1;
        
        %for kk = 1:timepoints(3)
        for kk = [1:timepoints(1) 1:timepoints(2) 1:timepoints(3)]
            kk
            tIdx
            colonyImage = align3by3LSMImage(sessionFiles{fileIdx(tIdx)}, jj, alignmentChannel, kk); % align
            
            if tIdx  == 1
                imageSize = [size(colonyImage,1)+50, size(colonyImage,2)+50];
            end
            for ch = 1:size(colonyImage,3)
                newImage = makeImageSizeX(colonyImage(:,:,ch), imageSize);
                if tIdx == 1
                    imwrite(newImage, [colonyPath '_ch' int2str(ch) '.tif']);
                else
                    imwrite(newImage, [colonyPath '_ch' int2str(ch) '.tif'], 'WriteMode', 'append');
                end
            end
            tIdx = tIdx+1; 
        end
        cIdx = cIdx+1;
    end
    colonyCounter = colonyCounter+files.coloniesPerWell(ii);
end
%% ---------------------------------------------------------------------
%% ---------------------------------------------------------------------
%% ------ 2) use ilastik to make membraneMasks -------------------------
%% ---------------------------------------------------------------------
%% ---------------------------------------------------------------------------------------
%% ------ 3) use ilastik masks to make colonyMasks for first timepoint in each session ---

% specify the imaging transition timepoints where colony slightly moves
timepoints_idx = [1 timepoints(1)+1];

for ii = 1:files1.nWells
    wellPath = [saveInFolder filesep newFolders{ii}];
    masks = dir([wellPath filesep '*.h5']);
    for jj = 1:numel(masks)
        masks1 = readIlastikFile([masks(1).folder filesep masks(jj).name]);
        for kk = timepoints_idx
            mask1 = masks1(:,:,kk);
            mask11 = imopen(mask1, strel('disk', 2));
            mask12 = imclose(mask11, strel('disk', 14));
            mask13 = imfill(mask12, 'holes');
            mask13 = bwareafilt(mask13, 1, 'largest');
            mask13 = bwconvhull(mask13);
            
            figure; imshowpair(mask13, mask1);
            imwrite(mask13, [wellPath filesep 'colony' int2str(jj) '_colonyMask' int2str(kk) '.tif']);
            
        end
    end
end
%%




















