
clearvars;
condition = strcat(strsplit(int2str([15:5:40]), ' '), 'h/');
%%
radius = 350;
outerBin = 15;
bins = getBinEdgesConstantArea(radius, outerBin);

pixel_um = 0.62;
bins_pixel = bins/pixel_um;

nonDapiChannels = 2:3;

%%
rA_mean_all = zeros(numel(bins)-1, numel(condition), numel(nonDapiChannels));
rA_std_error_all = rA_mean_all;

xValues = (bins(1:end-1)+bins(2:end))./2 ;
%%
for ii = 1:numel(condition)
    ii
    colonies = dir([condition{ii} filesep 'Colony*.tif']);
    nucleiMasks = dir([condition{ii} filesep 'Colony*_ch1*Segmentation.h5']);
    
    toKeep = 1:3:numel(colonies);
    colonies = colonies([toKeep]);
    
    %% radial average for each colony
    rA = zeros(numel(bins)-1, numel(colonies), numel(nonDapiChannels));
    nPixels = zeros(numel(bins)-1, numel(colonies)); % same pixels in each bin
    
    for jj = 1:numel(colonies)
        jj
        dapiImage = imread([colonies(jj).folder filesep colonies(jj).name], 1);
        nonDapiImages = zeros(size(dapiImage,1), size(dapiImage,2), numel(nonDapiChannels));
        
        counter = 1;
        for kk = nonDapiChannels
            nonDapiImages(:,:,counter) = imread([colonies(jj).folder filesep colonies(jj).name], kk);
            counter = counter+1;
        end
        
        nuclearMask = readIlastikFile([nucleiMasks(jj).folder filesep nucleiMasks(jj).name]);
        nuclearMask = bwareaopen(nuclearMask, 10);
        
        prefix_pos = strfind(colonies(jj).name, '.');
        colonyPrefix = colonies(jj).name(1:prefix_pos-1);
        colonyMask = imread([nucleiMasks(jj).folder filesep colonyPrefix '_cMask.tif']);
        
        [rA1, nPixels1] = radialAverage_ch2dapi_oneColony(nonDapiImages, dapiImage, nuclearMask, colonyMask, bins_pixel);
        
        for kk = 1
            figure; hold on;
            plot(xValues, rA1(:,kk));
        end
        %
        rA(:,jj,:) = rA1;
        nPixels(:,jj) = [nPixels1];
    end
    
    %% average radial average
    for kk = 1:numel(nonDapiChannels)
        rA_ch1 = rA(:,:,kk);
        
        rA_mean = sum(rA_ch1.*nPixels,2)./sum(nPixels,2);
        rA2_mean = sum(rA_ch1.*rA_ch1.*nPixels,2)./sum(nPixels,2);
        %%
        rA_std_dev = sqrt(rA2_mean-rA_mean.*rA_mean);
        rA_std_error = rA_std_dev./sqrt(numel(colonies));
        %%
        badinds=isnan(rA_mean);
        rA_mean(badinds)=[]; rA_std_dev(badinds)=[]; rA_std_error(badinds)=[];
        %%
        xValues = (bins(1:end-1)+bins(2:end))./2 ;
        figure; errorbar(xValues, rA_mean, rA_std_error);
        
        rA_mean_all(:,ii,kk) = rA_mean;
        rA_std_error_all(:,ii,kk) = rA_std_error;
    end
end
%% ------------------------- plot
colors = cell2mat({[0 0.6 0]; [0 0 0.7]; [0.7 0.7 0]; [0.7 0 0]; ...
    [0 0 0]; [1 0 1]; [1 0.6 0]; [0.3 0.3 0.3]});

legendLabel = strcat(strsplit(int2str([15:5:40]), ' '), 'h');

for kk = 1:2
    figure; hold on;
    for ii = 1:numel(condition)
        errorbar(xValues, rA_mean_all(:,ii,kk), rA_std_error_all(:,ii,kk), 'Color', colors(ii,:), 'LineWidth', 2);
    end
    legend(legendLabel);
    xlabel('Distance from edge (\mum)'); ylabel('nuc/dapi');
    ax = gca;
    ax.FontSize = 12;
    ax.FontWeight = 'bold';
    
end

