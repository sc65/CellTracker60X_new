%% saves radial average profiles for all channels over colonies.

clearvars;
rawImagesPath = '/Volumes/SAPNA/180314_96wellPlates/plate1/tiffFiles';
conditions = [4 5 8:15 24:31 40:47];
%%
nonDapiChannels = 2:4;

radius = 350;
outerBin = 10;
bins = getBinEdgesConstantArea(radius, outerBin);

pixel_um = 0.62;
bins_pixel = bins/pixel_um;
xValues = (bins(1:end-1)+bins(2:end))./2;

dapiNormalise = 0;

neighbourhoodSize_um = 60; % in microns.
neighbourhoodSize_pixel = floor(neighbourhoodSize_um./pixel_um);

%% -------------- radial average individual colonies

for condition1 = conditions
    condition1
    
    outputFile = [rawImagesPath filesep 'Condition' int2str(condition1)...
        filesep 'output.mat'];
    load(outputFile);
    
    nColonies = size(masks,2);
    rA_colonies0 = zeros(numel(bins)-1, nColonies, numel(nonDapiChannels));
    nPixels = zeros(numel(bins)-1, nColonies);
    colonyMasks = cell(1, nColonies);
    
    %for ii = 3
    for ii = 1:nColonies
        tic;
        ii
        dapiImage = imread([rawImages1(ii).folder filesep rawImages1(ii).name], 1);
        dapiImage = SmoothAndBackgroundSubtractOneImage(dapiImage);
        
        if dapiNormalise==1 % bring the dapi values in all conditions to the same level. 
            d1 = double(dapiImage);
            d2 = d1./mean(d1(:));
            dapiImage= uint16(d2*2^11);
        end
        
        nonDapiImages = zeros(size(dapiImage,1), size(dapiImage,2), numel(nonDapiChannels));
        for jj = nonDapiChannels
            nonDapiImages(:,:,jj-1) = imread([rawImages1(ii).folder filesep rawImages1(ii).name], jj);
            nonDapiImages(:,:,jj-1) = SmoothAndBackgroundSubtractOneImage(nonDapiImages(:,:,jj-1));
        end
        
        colonyMasks{ii} = bwconvhull(removeCellsNotInMask(masks{ii}));
        %figure; imshow(colonyMasks{ii}); title(['Colony' int2str(ii)]);
        
        [rA_colonies0(:,ii,:), nPixels(:,ii)] = radialAverage_ch2dapi_oneColony(nonDapiImages, dapiImage, ...
            masks{ii}, colonyMasks{ii}, bins, neighbourhoodSize_pixel);
        
%        figure; hold on;  title(['Colony' int2str(ii)]);
%         for kk = 1:numel(nonDapiChannels)
%             plot(xValues, rA_colonies(:,ii,kk));
%         end
    end
    
    save(outputFile, 'colonyMasks', 'rA_colonies', 'nPixels', 'rA_colonies0', '-append');
end
%%
%% -------- select good colonies
nColonies = size(rawImages1, 1);

figure; hold on;
for ii = 1:nColonies
    subplot(5,5,ii);
    imshow(masks{ii});
    title(['Colony' int2str(ii)]);
end
%% -------- remove bad colonies
toRemove = [];
peaks(toRemove) = [];
rawImages1(toRemove) = [];
masks(toRemove) = [];

nColonies = size(rawImages1,1);

%%
xValues = (bins(1:end-1)+bins(2:end))./2 ;

figure; hold on;
for ii = 1:17
    subplot(5,4, ii); hold on;
    
    for jj = 1:3
        plot(xValues', rA_colonies0(:,ii,jj));
    end
    
    ylim([0 0.9]); title(['Colony' int2str(ii)]);
end

%%
colonyIds1 = [3 11 15:17];
colonyIds2 = [1 2 4 6 10 13:17];
%%
colonyIds1 = [2:17];
[rA_all, rA_all_stdError] = calculateAverage_rA_givenColonies_rA(rA_colonies0, nPixels, colonyIds2);

rA_all_norm = rA_all./max(rA_all,[],1);
rA_all_stdError_norm = rA_all_stdError./max(rA_all,[],1);

figure; hold on;
for ii = 1:3
    errorbar(xValues', rA_all_norm(:,ii), rA_all_stdError_norm(:,ii));
end















