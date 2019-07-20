%% classify and save good colonies in the outputFiles

clearvars;
masterFolder = '/Volumes/sapnaDrive2/181021_mediaChange_IWP2_17_34/Folder_20181021';
% controlFile = '/Volumes/SAPNA/180314_96wellPlates/plate1/control1.mat';
% load(controlFile, 'bins', 'max_rA');

controlCondition = 1;
controlOutputFile = [masterFolder filesep 'tiffFiles/Condition' ...
    int2str(condition) filesep 'output.mat'];
load(controlOutputFile, 'rA_colonies0', 'nPixels', 'colonyIds_good');
[rA_control,~] = calculateAverage_rA_givenColonies_rA(rA_colonies0, nPixels, colonyIds_good);
max_rA = max(rA_control,[], 1);
%%
close all;
condition = 40;

outputFile1 = [masterFolder filesep 'tiffFiles/Condition' ...
    int2str(condition) filesep 'output.mat'];
load(outputFile1);

rA_saveInPath = [masterFolder filesep 'tiffFiles/Condition' ...
    int2str(condition) filesep 'filteredColoniesFigures'];
%% ---------------------------------------------------------------
%% -------------------- check masks
%% check segmentation masks
figure; hold on;
for ii = 1:length(masks)
    subplot(6,5, ii); hold on;
    imshow(masks{ii});
    title(['Colony' int2str(ii)]);
end
%% check colony masks
figure; hold on;
for ii = 1:length(colonyMasks)
    subplot(6,5, ii); hold on;
    imshow(colonyMasks{ii});
    title(['Colony' int2str(ii)]);
end
%% -------------- filter1
toRemove1 = [];
colonyIds_good = setxor([1:length(masks)], toRemove1);

if isempty(toRemove1)
    colonyIds_good = colonyIds_good';
end

%%

%% ---------------------------------------------------------------
%% ---------------------------------------------------------------
%% ------------ check dapi profiles
%% -------all colonies

xValues = (bins(1:end-1)+bins(2:end))./2;

coloniesToPlot = colonyIds_good;
colors = colorcube(max(coloniesToPlot));
colors(end,:) = [0.5 0.5 0];

figure; hold on;
for ii = coloniesToPlot
    plot(xValues', rA_colonies_dapi(:,ii), 'LineWidth', 2, 'Color', colors(ii,:));
    title('dapiLevels');
end

legendLabels = strcat('colony:', strsplit(int2str(coloniesToPlot), ' '));
legend(legendLabels);

%ylim([0 ylimits(ii)]);
%% ------- filter 2
toRemove2 = [];
colonyIds_good = setxor([1:length(colonyMasks)], [toRemove1, toRemove2]);

if isempty(toRemove1) && isempty(toRemove2)
    colonyIds_good = colonyIds_good';
end
%% ------ filtered colonies
colors = colorcube(length(colonyMasks));
colors(end,:) = [0.5 0.5 0];

figure; hold on;
for ii = colonyIds_good
    plot(xValues', rA_colonies_dapi(:,ii), 'LineWidth', 2, 'Color', colors(ii,:));
    title('dapiLevels');
end

legendLabels = strcat('colony:', strsplit(int2str(colonyIds_good), ' '));
legend(legendLabels);
%% check individual rA plots

%% -------------------------------------------------------------
%% -------------------------------------------------------------
%% ------------------------ 1 marker, all colonies
%coloniesToPlot = 1:numel(rawImages1);
%coloniesToPlot = colonyIds_good;
coloniesToPlot = 4;

channelLabels = {'T', 'Sox2', 'Cdx2'};
legendLabels = strcat('colony:', strsplit(int2str(coloniesToPlot), ' '));
colors = colorcube(length(colonyMasks));
colors(end,:) = [0.5 0.5 0];

toAverage = {rA_colonies, rA_colonies0};

ylimits = [0.6, 1];

for ii = length(toAverage)
    rA = toAverage{ii};
    for jj = 1:3
        figure; hold on;
        
        for kk = coloniesToPlot
            plot(xValues', rA(:,kk,jj), 'LineWidth', 2, 'Color', colors(kk,:));
        end
        
        ylim([0 ylimits(ii)]);
     title(channelLabels{jj});
        legend(legendLabels);
    end
end
%% ---------- filter 3
toRemove3 = [24];
colonyIds_good = setxor(colonyIds_good, toRemove3);
%colonyIds_good = setxor([1:length(colonyMasks)], [toRemove1, toRemove2, toRemove3]);

%% find colonies with max and min T levels

t_levels = rA_colonies0(:,:,1);
t_levels_peak = max(t_levels,[],1);

[~, ids] = sort(t_levels_peak)

%% -------------------- 1 colony, all markers
figure; hold on;
counter = 1;

for ii = colonyIds_good
    subplot(6,5, counter); hold on; counter = counter+1;
    for jj = 1:3
        plot(xValues', rA_colonies(:,ii,jj));
    end
    ylim([0 1]); title(['Colony' int2str(ii)]);
end
%% select colonies with a nice T ring (good)
% 1) rAplot
% 2) Manual confirmation

rawImages_good = rawImages1(colonyIds_good);

%% check the average rA plot
toAverage = {rA_colonies, rA_colonies0};
for ii = 2
    [rA_all, rA_all_stdError] = calculateAverage_rA_givenColonies_rA(toAverage{ii}, nPixels, colonyIds_good);
    
    %maxRa = max(rA_all,[],1);
    
    rA_all_norm = rA_all;
    rA_all_stdError_norm = rA_all_stdError;
    
    figure; hold on;
    for jj = 1:3
        errorbar(xValues', rA_all_norm(:,jj), rA_all_stdError_norm(:,jj));
    end
    title(int2str(ii));
end
%%
saveAllOpenFigures(rA_saveInPath);
%%
save(outputFile1, 'colonyIds_good', 'rawImages_good', '-append');

%%