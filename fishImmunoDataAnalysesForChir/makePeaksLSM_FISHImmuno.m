function makePeaksLSM_FISHImmuno(masterFolder, oneSpotIntensities)
%% Make Peaks array For LSM data, containing both FISH and Immuno values.
%---------- peaks: [x y Area -1 DAPI protein(nuclear) protein(cyto)
%spot1(nuclear) spot1(cyto) spot2(nuclear) spot2(cyto)].

%---------- Inputs: ---------
% --- masterFolderPath :- path to the masterFolder - containing rawData and output files.
% --- oneSpotIntensities :- an array containing spot intensities correspong to a single mRNA
% spot - in the order corresponding to spotFolders (see below).
%-------------------------------------------------%

samplesPath = [masterFolder filesep 'rawData'];
[samplesInfo, start] = startPositionFunctionDir(samplesPath);
samplesInfo(1:start-1) = [];
nSamples = length(samplesInfo);
%% spot channels information - standard - applies to most cases.

%spotChannels = [4 3]; %[Nodal, T] number corresponding to the image in the sequence of images taken.
spotChannels = [4 3];
proteinChannels = [1 2]; % starting with dapi

spotFolders = {'nodalImages', 'leftyImages'};
nuclearMaskFolder = 'dapiImages';
%%
mkdir([masterFolder filesep 'outputFiles']);
tic;

for ii = 1:nSamples
%for ii = 1:nSamples
    ii
    oneSamplePath = [samplesPath filesep samplesInfo(ii).name];
    [oneSampleInfo, start] = startPositionFunctionDir(oneSamplePath);
    oneSampleInfo(1:start-1) = [];
    
    oneSampleInfo = oneSampleInfo([oneSampleInfo.isdir]); %exclude the log file.
    nPositions = length(oneSampleInfo); %returns the number of positions imaged.
    peaks = cell(1, nPositions);
    
    fileNamePrefix =  samplesInfo(ii).name; %get the filename
    nuclearMaskPath = [masterFolder filesep nuclearMaskFolder filesep fileNamePrefix '_Simple Segmentation.h5']; %nuclear mask of the max Z projection.
    nuclearMasks = readIlastikFile(nuclearMaskPath);
    
    areaThresh = 200;
    nuclearMasks = IlastikMaskPreprocess(nuclearMasks, areaThresh);
    
    %%
    for kk = 1:nPositions
        %% Read raw images
        rawImages = getRawImages_allChannels_allz_LSM(oneSamplePath, kk);
        %% Start making peaks. Add  nuclear and cytoplasmic intensities for non-mRNA, channels.
        nuclearMask1 = nuclearMasks(:,:,kk);
        donutSize = 12;
        [nuclearMask1, cytoplasmicMask1] = MakeCytoplasmicMaskDonut(nuclearMask1, donutSize);
        
        peaks1 = MasksToPeaks1(rawImages(:,:,[proteinChannels],:), nuclearMask1, cytoplasmicMask1);
        % only raw images corresponding to protein channels starting with DAPI are passed to the
        % function.
        
        %% Add spot numbers.
        if exist('oneSpotIntensities', 'var')
            spotMasks1 = zeros(size(nuclearMask1, 1), size(nuclearMask1, 2), numel(spotChannels), size(rawImages,4));
            for ch = 1:length(spotChannels) % mRNA channels = [4 3], [Nodal Lefty]
                spotMasksPath = [masterFolder filesep spotFolders{ch} filesep fileNamePrefix ...
                    '_Track' int2str(kk) '_Simple Segmentation.h5']; %spotMasks
                spotMasks1(:,:,ch,:) = readIlastikFile(spotMasksPath);
            end
            peaks1 = addmRNA(peaks1, nuclearMask1, spotMasks1, rawImages(:,:,[spotChannels],:), oneSpotIntensities);
        end
        
        peaks{kk} = peaks1;
    end
    outputFilePath = [masterFolder filesep 'outputFiles' filesep 'output_' int2str(ii) '.mat'];
    save(outputFilePath, 'peaks', 'oneSamplePath');
end

toc;




