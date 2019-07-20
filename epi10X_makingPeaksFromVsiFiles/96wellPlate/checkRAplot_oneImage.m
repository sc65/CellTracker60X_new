%% verify trend from epi data in LSM images.
%%
clearvars;
rawImage_name = 'Colony_1.tif';
for ii = 1:4
    rawImages(:,:,ii) = imread(rawImage_name, ii);
    rawImages(:,:,ii) = SmoothAndBackgroundSubtractOneImage(rawImages(:,:,ii));
end

%%
rawImage_nucleiMask_name = 'Colony_1_ch1_Simple Segmentation.h5';
rawImage_nucleiMask = readIlastikFile(rawImage_nucleiMask_name);
%%
rawImage_nucleiMask = bwareaopen(rawImage_nucleiMask, 100);
%%
figure; imshow(rawImage_nucleiMask);
%%

for ii = 1:4
    figure; imshow(rawImages(:,:,ii), []);
end
%%
figure; imshow(rawImage_nucleiMask);
%%
dapi_rawImage = rawImages(:,:,1);
saveInPath = './Colony_1_cMask.tif';
rawImage_colonyMask = makeColonyMask_dapi(dapi_rawImage, saveInPath);
%%
nonDapiImages = rawImages(:,:,2:end);
dapiImage = rawImages(:,:,1);

radius = 350;
outerBin = 15;
bins = getBinEdgesConstantArea(radius, outerBin);

pixel_um = 0.62;
bins_pixel = bins/pixel_um;

%%
filterSize = floor(60./pixel_um);
%%
[rA, nPixels] = radialAverage_ch2dapi_oneColony(nonDapiImages, dapiImage, rawImage_nucleiMask, rawImage_colonyMask, ...
    bins_pixel, filterSize);
%%
figure; hold on;
xValues = (bins(1:end-1)+bins(2:end))./2 ;
rA_norm = rA./max(rA,[],1);

for ii = 1:3
    plot(xValues, rA(:,ii));
    %plot(xValues', rA_norm(:,ii)); 
end
