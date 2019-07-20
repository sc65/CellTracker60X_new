%%

outputFile = '/Volumes/sapnaDrive2/190304_cellsInDish_BMP_SB_IWP2_kongData/1-4_media-BMP-BMPSB-BMPIWP2/Gata3/output.mat';
load(outputFile);
%%
ch = 2; % channel to investigte
ch_dapi = 1;
%%
for ii = 1:numel(cells)
    im1 = zeros(2048);
    
    data1 = cells(ii).intensity(:,ch)./cells(ii).intensity(:,ch_dapi);
    idx = find(data1 > 1) % extracts super bright spots
    data1(idx)
    
    if ~isempty(idx)
        figure; imshow(im1); hold on;
        for jj = idx
            positions = cells(ii).position(jj,:);
            plot(positions(1,1), positions(1,2), 'w*', 'MarkerSize',20);
        end
    end
end

%%
% histograms
figure; hold on;
for ii = 1:numel(cells)
    data1 = cells(ii).intensity(:,ch);
    subplot(4,4,ii);
    histogram(data1);
end
figure; hold on;
for ii = 1:numel(cells)
    data1 = cells(ii).intensity(:,ch_dapi);
    subplot(4,4,ii);
    histogram(data1);
end
%%
figure; hold on;
for ii = 1:numel(cells)
    data1 = cells(ii).intensity(:,ch)./cells(ii).intensity(:,ch_dapi);
    subplot(4,4,ii);
    histogram(data1);
end
%%
sampleIds = [1 3];
for ii = sampleIds
    im1 = zeros(2048);
    data1 = cells(ii).intensity(:,ch)./cells(ii).intensity(:,ch_dapi);
    figure; imshow(im1); hold on;
    
    for jj = 1:size(data1,1)
        positions = cells(ii).position(jj,:);
        plot(positions(1,1), positions(1,2), 'w*', 'MarkerSize',20);
        intensity = round(data1(jj),2);
        if intensity>0.2
            text(positions(1,1), positions(1,2), num2str(intensity), 'Color', 'r', 'FontSize', 20);
        end
    end
end
%%
sampleIds = [1 3];
threshold = 0.2;
for ii = sampleIds
    data1 = cells(ii).intensity(:,ch)./cells(ii).intensity(:,ch_dapi);
    idx = find(data1>=threshold);
    cells(ii).position(idx,:) = [];
    cells(ii).intensity(idx,:) = [];
end
    
%%
save(outputFile, 'cells', '-append');