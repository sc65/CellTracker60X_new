%% classify and save good colonies in the outputFiles

clearvars;
masterFolder = '/Volumes/sapnaDrive2/181113_leftyMediaChange_18_32h/colonyImages';
% controlFile = '/Volumes/SAPNA/180314_96wellPlates/plate1/control1.mat';
% load(controlFile, 'bins');

%%
condition = 'bottom3';
close all;

outputFile1 = [masterFolder filesep condition filesep 'output.mat'];
load(outputFile1);
rA_saveInPath = [masterFolder filesep condition filesep 'radialAveragePlots'];

% %% check segmentation masks
% figure; hold on;
% for ii = 1:length(colonyMasks)
%     subplot(6,5, ii); hold on;
%     imshow(masks{ii});
%     title(['Colony' int2str(ii)]);
% end
%
% %% check colony masks
% figure; hold on;
% for ii = 1:length(colonyMasks)
%     subplot(6,5, ii); hold on;
%     imshow(colonyMasks{ii});
%     title(['Colony' int2str(ii)]);
% end

% check individual rA plots.
xValues = (bins(1:end-1)+bins(2:end))./2;
%% ------- 1 marker, all colonies
xValues = (bins(1:end-1)+bins(2:end))./2;
legendLabels = strcat('colony:', strsplit(int2str([1:length(rawImages1)]), ' '));
%channelLabels = {'T', 'Sox2', 'Cdx2'};
channelLabels = {'rfp', 'T', 'smad2', 'smad2'};

toPlot = {rA_colonies_dapi, rA_colonies_nuclear_normalized(:,:,1), rA_colonies_nuclear_normalized(:,:,2)};
ylimits2 = [850, 3, 3.4, 4];

for ii = 1:length(toPlot)
    figure; hold on;
    rA1 = toPlot{ii};
    
    for jj = 1:length(rawImages1)
        plot(xValues', rA1(:,jj), 'LineWidth', 2);
    end
    
    %ylim([0 ylimits2(ii)]); 
    title(channelLabels{ii});
    legend(legendLabels);
end
%%
colonyIds_good = setxor([1:length(rawImages1)], [7]);
rawImages_good = rawImages1(colonyIds_good);
%
% %% -------- 1 colony, all markers
%
% figure; hold on;
% for ii = 1:length(rawImages1)
%     subplot(3,3, ii); hold on;
%
%     for jj = 1:3
%         plot(xValues', rA_colonies(:,ii,jj));
%     end
%
%      ylim([0 2.4]); title(['Colony' int2str(ii)]);
% end

%% ---------------------- all markers, all colonies average

% %% select colonies with a nice T ring (good)
% % 1) rAplot
% % 2) Manual confirmation
%

% check the average rA plot
toPlot = {rA_colonies_nuclear_normalized(:,:,1), rA_colonies_nuclear_normalized(:,:,2)};
channelLabels = {'T', 'smad2', 'smad2'};
ylimits1 = [0 0.8 0.6];
ylimits2 = [1, 1, 4];

for ii = 1:length(toPlot)
    rA1 = toPlot{ii};
    [rA_all, rA_all_stdError] = calculateAverage_rA_givenColonies_rA(rA1, nPixels, colonyIds_good);
    
    rA_all_norm = rA_all;
    rA_all_stdError_norm = rA_all_stdError;
    
    figure; 
    
    errorbar(xValues', rA_all_norm, rA_all_stdError_norm);
    %ylim([ylimits1(ii) ylimits2(ii)]);
    title(channelLabels{ii});
end
%%
saveAllOpenFigures(rA_saveInPath);
save(outputFile1, 'colonyIds_good', 'rawImages_good', '-append');
%%













%%