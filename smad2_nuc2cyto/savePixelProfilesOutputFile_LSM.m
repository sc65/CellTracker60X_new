%% saves radial average profiles for all channels over colonies in an output file

clearvars;
samplesPath = '/Volumes/sapnaDrive2/181113_leftyMediaChange_18_32h/colonyImages';

samples = dir([samplesPath]);
[~, startPosition] = startPosition_folder(samplesPath);
samples = samples(startPosition:end);
%%
nuclearChannel = 2;
colonyMaskChannel = 3;
%% -------------------------- make colony masks,
% save colony, nuclear masks as images.
for ii = 3
%for ii = 1:numel(samples)
    %for ii = 14:numel(samples)
    ii
    colonyImages = dir([samplesPath filesep  samples(ii).name filesep 'Colony*.tif']);
    colonyImages = colonyImages([1:2:end]);
    
    for jj = [4]
    %for jj = numel(colonyImages)
        colony1_colonyMask_image = imread([colonyImages(jj).folder filesep colonyImages(jj).name], colonyMaskChannel);
        
        colony1_prefix = strsplit(colonyImages(jj).name, '.');
        colony1_nuclearMask = readIlastikFile([colonyImages(jj).folder filesep colony1_prefix{1} '_ch' int2str(nuclearChannel) '_Simple Segmentation.h5']);
        colony1_nuclearMask = bwareaopen(colony1_nuclearMask, 50);
        saveInPath = [colonyImages(jj).folder filesep 'maskNuclear_' colony1_prefix{1} '.tif'];
        imwrite(colony1_nuclearMask, saveInPath);
        
        %colony1_deadCellsMask = readIlastikFile([colonyImages(jj).folder filesep colony1_prefix{1} '_ch1_Simple Segmentation_dead.h5']);
        saveInPath = [colonyImages(jj).folder filesep  'maskColony_' colony1_prefix{1} '.tif'];
        %makeColonyMaskUsingNuclearMask(saveInPath, colony1_nuclearMask);
        makeColonyMask_dapi(colony1_colonyMask_image, saveInPath);
    end
end

%% ---------------- calculate radial average profiles
% save this information in a separate outputFile.

%pixel_um = 0.62;% 20X
pixel_um = 0.32;% 40X LSM

radius = 350;
outerBin = 10;
bins = getBinEdgesConstantArea(radius, outerBin);

bins_pixel = bins/pixel_um;
xValues = (bins(1:end-1)+bins(2:end))./2;
dapiNormalise = 0; % set this to 1 if dapi values across different samples needs to be normalized.

neighbourhoodSize_um = 100; % in microns, diameter of the circular region over which pixel values are averaged.
neighbourhoodSize_pixel = floor(neighbourhoodSize_um./pixel_um);

nuclearChannel = 2; % channel used to create nuclear mask
nonNuclearChannels = [1 3];
nuclearNormalized_idx = 1:2; % position of channels in nonnuclearChannels for which nuclear normalized rA is needed.
nuclearToCyto_idx = []; % position of channels in nonnuclearChannels for which nuclear to cytoplasmic rA is needed.


%% ------------ find maximum intensity limits for all channels using the control sample

controlSample = [samplesPath filesep 'top1'];
channelOrder = [nuclearChannel nonNuclearChannels];
intensities_max = findMaxIntensityLimit(controlSample, channelOrder);

intensities_max = [3750 3000 3300]

%%
for ii = 1
%for ii = 1:numel(samples)
    ii
    colonyImages = dir([samplesPath filesep  samples(ii).name filesep 'Colony*.tif']);
    colonyImages = colonyImages([1:2:end]);
    
    outputFile = [samplesPath filesep  samples(ii).name filesep 'output.mat'];
    rA_colonies_nuclear_normalized = zeros(numel(bins)-1, numel(colonyImages), numel(nuclearNormalized_idx));
    rA_colonies_nuclearToCyto = zeros(numel(bins)-1, numel(colonyImages), numel(nuclearToCyto_idx));
    rA_colonies_dapi = zeros(numel(bins)-1, numel(colonyImages));
    
    nPixels = zeros(numel(bins)-1,  numel(colonyImages));
    rawImages1 = colonyImages;
    
    %for jj = 3:4
    for jj = 1:numel(colonyImages)
        jj
        colony1_dapi = imread([colonyImages(jj).folder filesep colonyImages(jj).name], nuclearChannel);
        colony1_prefix = strsplit(colonyImages(jj).name, '.');
        colony1_dapi = SmoothAndBackgroundSubtractOneImage(colony1_dapi);
        colony1_dapi(colony1_dapi>intensities_max(1)) = 0;
        
        colony1_nonDapi = uint16(zeros(size(colony1_dapi,1), size(colony1_dapi,2), numel(nonNuclearChannels)));
        counter = 2;
        for kk = nonNuclearChannels
            image1 = imread([colonyImages(jj).folder filesep colonyImages(jj).name], kk);
            image1 = SmoothAndBackgroundSubtractOneImage(image1);
            image1(image1>intensities_max(counter)) = 0;
            colony1_nonDapi(:,:,counter-1) = image1;
            counter = counter+1;
        end
        
        colony1_nuclearMask = imread([colonyImages(jj).folder filesep 'maskNuclear_' colony1_prefix{1} '.tif']);
        colony1_colonyMask = imread([colonyImages(jj).folder filesep 'maskColony_' colony1_prefix{1} '.tif']);
        
        [rA_colonies_nuclear_normalized(:,jj,:), nPixels(:,jj)] = radialAverage_ch2dapi_oneColony(colony1_nonDapi(:,:,[nuclearNormalized_idx]), colony1_dapi, ...
            colony1_nuclearMask, colony1_colonyMask, bins_pixel, neighbourhoodSize_pixel);
        
        if ~isempty(nuclearToCyto_idx)
            [rA_colonies_nuclearToCyto(:,jj,:), ~] = radialAverage_nuc2cyto_oneColony(colony1_nonDapi(:,:,[smadChannels_idx]), colony1_nuclearMask, ...
                colony1_colonyMask, neighbourhoodSize_pixel, bins_pixel);
        else
            rA_colonies_nuclearToCyto(:,jj,:) = 0;
        end
        
        [rA_colonies_dapi(:,jj,:), ~] = radialAverage_dapi_oneColony(colony1_dapi, colony1_nuclearMask, ...
            colony1_colonyMask, bins_pixel, neighbourhoodSize_pixel);
    end
    
    colonyIds_good = 1:numel(colonyImages);
    save(outputFile, 'rawImages1', 'colonyIds_good', 'rA_colonies_nuclear_normalized', 'rA_colonies_nuclearToCyto', 'rA_colonies_dapi',  ...
        'nPixels', 'bins');
    
end


%%















