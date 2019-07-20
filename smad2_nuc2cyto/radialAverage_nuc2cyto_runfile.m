clearvars;
filePaths = strcat(strsplit(int2str([25:5:40]), ' '), 'h/maxZ');

%% save colony masks
%for ii = 4
for ii = 1:numel(filePaths)
    ii
    rawImages = dir([filePaths{ii} filesep 'Colony*_ch1.tif']);
    for jj = 1:numel(rawImages)
        im1_dapi = imread([rawImages(jj).folder filesep rawImages(jj).name]);
        im1_prefix = strsplit(rawImages(ii).name, '.');

        maskPath_deadCells = [rawImages(jj).folder filesep im1_prefix 'Simple Segmentation_dead.h5'];

        saveInPath = [rawImages(jj).folder filesep 'Colony_' int2str(jj) '_cMask.tif' ];
        makeColonyMask_dapi(im1_dapi, saveInPath, maskPath_deadCells);
    end
end
%% -------------------- Start here, if colony masks have already been saved.

%% --------------------------------calculate smad2 nuc/cyto radial average
% input - smad2 raw image, colonymask, nuclear mask, bins(in pixels)
% output - rA, pixels in each bin

smad2_channel = 4;

radius = 350;
outerBin = 15;
bins = getBinEdgesConstantArea(radius, outerBin);

pixel_um = 0.62;
bins_pixel = bins/pixel_um;
%%
rA_mean_all = zeros(numel(bins)-1, numel(filePaths));
rA_std_error_all = rA_mean_all;

xValues = (bins(1:end-1)+bins(2:end))./2 ;
%%
for ii = 1:numel(filePaths)
    ii
    rawImages = dir([filePaths{ii} filesep 'Colony*.tif']);
    nucleiMasks = dir([filePaths{ii} filesep 'Colony*_ch1*Segmentation.h5']);
    
    toKeep = 1:3:numel(rawImages);
    rawImages = rawImages([toKeep]);
    
    %% radial average for each colony
    rA = zeros(numel(rawImages), numel(bins)-1);
    nPixels = rA;
    
    for jj = 1:numel(rawImages)
        
        
        image1_smad2 = imread([rawImages(jj).folder filesep rawImages(jj).name], smad2_channel);
        
        dapiImage = imread([rawImages(jj).folder filesep rawImages(jj).name], 1);
        
        nuclearMask = readIlastikFile([nucleiMasks(jj).folder filesep nucleiMasks(jj).name]);
        nuclearMask = bwareaopen(nuclearMask, 10);
        
        prefix_pos = strfind(rawImages(jj).name, '.');
        colonyPrefix = rawImages(jj).name(1:prefix_pos-1);
        colonyMask = imread([nucleiMasks(jj).folder filesep colonyPrefix '_cMask.tif']);
        
        [rA(jj,:), nPixels(jj,:)] = radialAverage_nuc2cyto_oneColony(image1_smad2, nuclearMask, colonyMask, bins_pixel);
        %figure; plot(xValues, rA(jj,:));
    end
    
    %% average radial average
    rA_mean = sum(rA.*nPixels,1)./sum(nPixels,1);
    rA2_mean = sum(rA.*rA.*nPixels,1)./sum(nPixels,1);
    %%
    rA_std_dev = sqrt(rA2_mean-rA_mean.*rA_mean);
    rA_std_error = rA_std_dev./sqrt(numel(rawImages));
    %%
    badinds=isnan(rA_mean);
    rA_mean(badinds)=[]; rA_std_dev(badinds)=[]; rA_std_error(badinds)=[];
    %%
    xValues = (bins(1:end-1)+bins(2:end))./2 ;
    figure; errorbar(xValues, rA_mean, rA_std_error);
    
    rA_mean_all(:,ii) = rA_mean;
    rA_std_error_all(:,ii) = rA_std_error;
end

%% ------------------------- plot
colors = cell2mat({[0 0.6 0]; [0 0 0.7]; [0.7 0.7 0]; [0.7 0 0]; [0 0 0 ]});
figure; hold on;

for ii = [1:4]
    errorbar(xValues, rA_mean_all(:,ii), rA_std_error_all(:,ii), 'Color', colors(ii,:), 'LineWidth', 2);
end

legend('25h', '30h', '35h', '40h');
%legend('5h', '10h', '20h', '25h', '30h');
xlabel('Distance from edge (\mum)'); ylabel('smad2 nuc/cyto');
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';

%% -------------------------- peakNormalise
rA_mean_all1 = rA_mean_all./max(rA_mean_all,[],1);
rA_std_error_all1 = rA_std_error_all./max(rA_mean_all,[],1);

figure; hold on;
for ii = [1 2 3 4]
    errorbar(xValues, rA_mean_all1(:,ii), rA_std_error_all1(:,ii), 'Color', colors(ii,:), 'LineWidth', 2);
end
legend('25h', '30h', '35h', '40h');
xlabel('Distance from edge (\mum)'); ylabel('smad2 nuc/cyto');
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';

%% -------------------------- position of half max

half_max = min(rA_mean_all,[],1) + (max(rA_mean_all,[],1) - min(rA_mean_all,[],1))/2;
%%
half_max_position = zeros(2,4);
for ii = 1:4
    half_max_line = [0, 300; half_max(ii), half_max(ii)];
    half_max_position(:,ii) = InterX(half_max_line, [xValues; rA_mean_all(:,ii)']);   
end
%%
figure; plot([25:5:40], half_max_position(1,:), 'k*-', 'LineWidth', 2);
xlabel('time of IWP2 addition (h)');
ylabel({'Position of smad2 (nuc/cyto) half max'; 'distance from edge(\mum)'});

ax = gca;
ax.FontSize = 14;
ax.FontWeight = 'bold';

%% ------------------------- fit to a polynomial

f = fit([25:5:40]', half_max_position(1,:)', 'poly1');
figure; plot(f, [25:5:40]', half_max_position(1,:)', 'MarkerSize', 12);
%%
saveInPath = '/Users/sapnachhabra/Desktop/figuresForPaper/figures/movement of smad2/figure3/matlabFigures';
saveAllOpenFigures(saveInPath);












