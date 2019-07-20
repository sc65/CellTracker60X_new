
%% ------------------ shape averages, fate territories.
outputfile = '/Volumes/sapnaDrive2/180628_shapesChip1/output.mat';
load(outputfile);
%%
counter = 1;
fatePattern = struct;
fullColony_threshold = 0.97; % 0.97

for shapeId = [1 6 16]
    channels = [6 8 10];
    binSize = 60; % in pixels
    intensityNorm = [];
    
    avgOut = computeShapeAverages(plate1.colonies, shapeId, [], binSize, channels);
    %%
    % ------ smooth averages.
    filterSize = 3;
    filter1 = ones(filterSize)./(filterSize^2);
    
    avgOut_smooth = imfilter(avgOut.markerAvgs(:,:,:), filter1);
    avgOut_smooth(isnan(avgOut_smooth)) = 0;
    
    %%
    % ----- normalize
    maxIntensity = max(max(avgOut_smooth));
    avgOut_smooth_norm = avgOut_smooth./maxIntensity;
   
    %%
    % --- colony space.
    allMarkers = sum(avgOut_smooth_norm,3);
    figure; imagesc(allMarkers);
    fullColony = allMarkers > fullColony_threshold;
    %figure; imagesc(fullColony);
    
     for ii = 1:3
        avgOut_smooth_norm(:,:,ii) = avgOut_smooth_norm(:,:,ii).*fullColony;
        %figure; imagesc(avgOut_smooth_norm(:,:,ii)); colorbar;
    end
    
    
    % --- fate territories
    [~,idx1] = max(avgOut_smooth_norm,[],3);
    idx1 = idx1.*fullColony;
    figure; imagesc(idx1);
    
    fatePattern(counter).pattern = idx1;
    fatePattern(counter).density = avgOut.density;
    fatePattern(counter).shapeId = avgOut.shape_id;
    fatePattern(counter). markerAvgs = avgOut.markerAvgs;
    counter = counter+1;
end

%%
for ii = 1:3
    figure; imagesc(fatePattern(ii).density); colorbar; caxis([0 5.5]); title('Density');
end
%%
saveInPath = '/Volumes/sapnaDrive2/180628_shapesChip1/fatePatterns';
saveAllOpenFigures(saveInPath);
%%
save(outputfile,'fatePattern', '-append');






