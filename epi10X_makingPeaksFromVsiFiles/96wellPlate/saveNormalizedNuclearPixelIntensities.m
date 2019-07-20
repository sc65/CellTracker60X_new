
%% Do the intensity levels change across different conditions?

% 1) Define an intensity range based on control sample.
% 2) Plot histograms of intensity levels
% i) (for each condition, all colonies) -
%    - a) normalized to dapi
%    - b) individual channels
% ii) compare across colonies


%%
close all; clearvars;
masterFolder = '/Volumes/SAPNA/180314_96wellPlates/plate1/tiffFiles';
conditionsToUse = 24:31;

nuclearPixels_norm_compute = 'nuclear pixel values in intensity image normalized by dapi image';
%%
nuclearPixels_norm(numel(10)).brachyury = 0;

for condition = conditionsToUse(1:end)
    condition
    outputFile = [masterFolder filesep 'Condition' int2str(condition) filesep 'output.mat'];
    load(outputFile);  
   
    for ii = 1:numel(masks)
        nuclearMask = masks{ii} & colonyMasks{ii};
        
        clear images;
        
        for jj = 1:4
            images(:,:,jj) = imread([rawImages1(ii).folder filesep rawImages1(ii).name],jj);
            images(:,:,jj) = SmoothAndBackgroundSubtractOneImage(images(:,:,jj));
            images(:,:,jj) = bsxfun(@times, images(:,:,jj), cast(nuclearMask,class(images(:,:,jj))));
            
        end
        
        
        for jj = 2:4
            nuclearImage_norm = double(images(:,:,jj))./double(images(:,:,1));
            nuclearImage_norm(isnan(nuclearImage_norm)) = 0; % remove nan
            nuclearIntensity = nuclearImage_norm(:);
            
            if jj == 2
                nuclearPixels_norm(ii).brachyury = nuclearIntensity(nuclearIntensity>0);
            elseif jj == 3
                nuclearPixels_norm(ii).sox2 = nuclearIntensity(nuclearIntensity >0);
            else
                nuclearPixels_norm(ii).cdx2 = nuclearIntensity(nuclearIntensity >0);
            end
        end
        
        dapiImage = double(images(:,:,1));
        nuclearPixels_norm(ii).dapi = dapiImage(dapiImage>0);
    end
    save(outputFile, 'nuclearPixels_norm', 'nuclearPixels_norm_compute', '-append');
end

%% ---------------------------------------------------------------------------------------
%% ------------------------- all good colonies combined, get max intensity values
fields = fieldnames(nuclearPixels_norm);
pixels_max = zeros(1,4);
allPixels = cell(1,4);

for ii = 1:numel(fields)
    for jj = colonyIds_good
        allPixels{ii} = cat(1, allPixels{ii}, nuclearPixels_norm(jj).(fields{ii}));
    end
    pixels_max(ii) = mean(allPixels{ii}) + 3*std(allPixels{ii});
end

%% ------------------------ plot histograms
% all colonies combined
for ii = 1:4
    if ii <4
        edges = [0:0.02:pixels_max(ii)];
    else
        edges = [0:100:pixels_max(ii)];
    end
    figure; histogram(allPixels{ii}, edges);
end
%%
% individual colonies
legendLabels = strcat('Colony', strsplit(int2str(colonyIds_good), ' '));
channelLabels = {'Brachyury', 'sox2', 'cdx2', 'dapi'};

for ii = 1:4
    figure; hold on; title(channelLabels{ii});
    if ii <4
        edges = [0:0.02:pixels_max(ii)];
    else
        edges = [0:100:pixels_max(ii)];
    end
    for jj = colonyIds_good
        histogram(nuclearPixels_norm(jj).(fields{ii}), edges, 'DisplayStyle', 'stairs',...
            'Normalization', 'probability');
    end
    legend(legendLabels);
end







