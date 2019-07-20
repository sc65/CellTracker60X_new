clearvars;
close all;
    %%
masterFolder = '/Volumes/SAPNA/180314_96wellPlates/plate1';
controlFile = '/Volumes/SAPNA/180314_96wellPlates/plate1/control1.mat';

condition5_path = '/Volumes/SAPNA/180314_96wellPlates/plate1/tiffFiles/Condition5/output.mat';
load(controlFile, 'bins');

conditions = [5 24 1];
controlCondition = 1;% position of the control condition in conditions array

conditionLabels = ['Control', strcat('IWP2 @ ', strsplit(int2str([15:5:40]), ' '), 'h')];
channelLabels = {'BRA', 'SOX2', 'CDX2'};
%% ------------------------ save average rA for all conditions
counter = 1;
rA_all = cell(1, numel(conditions));
rA_all_stdError = rA_all;
nColonies = zeros(1, numel(conditions));

for ii = conditions
    if ii == 5
        load(condition5_path, 'rA_colonies0', 'nPixels', 'colonyIds_good');
    else
        outputFile1 = [masterFolder filesep 'tiffFiles/Condition' ...
            int2str(ii) filesep 'output.mat'];
        load(outputFile1, 'rA_colonies0', 'nPixels', 'colonyIds_good');
    end
    [rA_all{counter}, rA_all_stdError{counter}] = calculateAverage_rA_givenColonies_rA(rA_colonies0, nPixels, colonyIds_good);
    nColonies(counter) = numel(colonyIds_good);
    
    counter = counter+1;
end

%%
maxRA = max(rA_all{controlCondition},[],1);
xValues = (bins(1:end-1)+bins(2:end))./2;

%% ------------------------ plot average rA
%%
load('/Users/sapnachhabra/Desktop/CellTrackercd/CellTracker60X/colorblind_colormap/goodColors_new.mat');
% 11 distinct colors. For more colors, use colorcube
%%
conditionsToPlot = [1:3];
channelsToPlot = 1:3;

%colors = cell2mat({[1.0 0.6 0]; [1 0 0.9];  [0.7 0.7 0.7];  [0.7 0.5 0.0]; [0 0.5 0.5]});
% for smad2 data in the paper -- use this set of colors for 0h, 10h, 15h,
% 25h, 35h LDN treatment]

for ch = channelsToPlot
    figure; hold on;
    
    % correct legend colors, fonts, lines.
    counter =1;
    for ii = conditionsToPlot
        plot(0, 0, 'Color', colors(counter,:));
        counter = counter+1;
    end
    [~,hObj]=legend(conditionLabels(conditionsToPlot), 'FontSize', 25, 'FontWeight', 'bold');   % return the handles array
    hL=findobj(hObj,'type','line');  % get the lines, not text
    set(hL,'linewidth',6);
    hT=findobj(hObj,'type','text');
    counter = 1;
    for ii = conditionsToPlot
        set(hT(counter),'Color', colors(counter,:));
        counter = counter+1;
    end
    legend('boxoff');
    
    % plot each condition
    counter = 1;
    for ii = conditionsToPlot
        rA1 = rA_all{ii};
        rA1_norm = rA1./maxRA;
        
        rA1_stdError = rA_all_stdError{ii};
        rA1_stdError_norm = rA1_stdError./maxRA;
        
        plot(xValues', rA1_norm(:,ch),  'Color', colors(counter,:), 'LineWidth', 5);
        errorbar(xValues', rA1_norm(:,ch),    rA1_stdError_norm(:,ch), 'Color', colors(counter,:), 'LineWidth', 1);
        counter = counter+1;
    end
    
    xlabel('Distance from edge (\mum)');
    ylabel([channelLabels{ch} ' (a.u.)']);
    xlim([0 350]); %ylim([0.3 1.4]);
    ax = gca; ax.FontSize = 30; ax.FontWeight = 'bold';
end
%%

saveInPath = '/Users/sapnachhabra/Desktop/figuresForPaper/figures/brachyury_LDN_IWP2_SB/radialAveragePlots/IWP2/withoutLegends';
saveAllOpenFigures(saveInPath);















