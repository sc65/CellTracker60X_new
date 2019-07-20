clearvars;
close all; 
%%
masterFolder = '/Volumes/sapnaDrive2/181113_leftyMediaChange_18_32h/colonyImages';
controlFile = '/Volumes/sapnaDrive2/181113_leftyMediaChange_18_32h/colonyImages/top1/output.mat';
load(controlFile, 'bins');

%conditions = [strcat('iwp2_', strsplit(int2str([1:4]), ' '), 'h')];
conditions1 =[strcat('top', strsplit(int2str([1:4]), ' '))];
conditions2 =[strcat('bottom', strsplit(int2str([3 4]), ' '))];
conditions = [conditions1 conditions2];

controlCondition = 1;% position of the control condition in conditions array

conditionLabels = conditions;
%conditionLabels = [strcat('lefty:', strsplit(int2str([0 250 500 4000]), ' '), 'ng/ml')];
channelLabels = {'T', 'smad2'};

%% ------------------------ save average rA for all conditions
counter = 1;
rA_all = cell(1, numel(conditions));
rA_all_stdError = rA_all;
nColonies = zeros(1, numel(conditions));

for ii = 1:numel(conditions)
    ii
    outputFile1 = [masterFolder filesep conditions{ii} filesep 'output.mat'];
    load(outputFile1, 'rA_colonies_nuclear_normalized', 'nPixels', 'colonyIds_good');
    [rA_all{counter}, rA_all_stdError{counter}] = calculateAverage_rA_givenColonies_rA(rA_colonies_nuclear_normalized, nPixels, colonyIds_good);
    nColonies(counter) = numel(colonyIds_good);
    
    counter = counter+1;
end

%%
maxRA = max(rA_all{controlCondition},[],1);
%maxRA = 1;
xValues = (bins(1:end-1)+bins(2:end))./2;

%% ------------------------ plot average rA
%%
load('/Users/sapnachhabra/Desktop/CellTrackercd/CellTracker60X/colorblind_colormap/goodColors_new.mat');
% 11 distinct colors. For more colors, use colorcube
%%
conditionsToPlot = [1 3:6];
channelsToPlot = 1:2;

%colors = cell2mat({[1.0 0.6 0]; [1 0 0.9]; [0.6 0.6 0.6];  [0.6 0.5 0]; [0 0.5 0.5]}); 
% for smad2 data in the paper -- use this set of colors for 0h, 10h, 15h,
% 25h, 35h LDN treatment]


for ch = channelsToPlot
    figure; hold on;
    
    % correct legend colors, fonts, lines.
    counter = 1; conditionsCounter = 1;
    for ii = conditionsToPlot
        plot(0, 0, 'Color', colors(counter,:));
        counter = counter+1;
    end
    [~,hObj]=legend(conditionLabels(conditionsToPlot), 'FontSize', 20, 'FontWeight', 'bold');   % return the handles array
    hL=findobj(hObj,'type','line');  % get the lines, not text
    set(hL,'linewidth',4);
    hT=findobj(hObj,'type','text');
    counter = 1;
    for ii = conditionsToPlot
        set(hT(counter),'Color', colors(counter,:));
        counter = counter+1;
    end
    legend('boxoff');
    
    % plot each condition
    for ii = conditionsToPlot
        rA1 = rA_all{ii};
        rA1_norm = rA1./maxRA;
        
        rA1_stdError = rA_all_stdError{ii};
        rA1_stdError_norm = rA1_stdError./maxRA;
        
        plot(xValues', rA1_norm(:,ch),  'Color', colors(conditionsCounter,:), 'LineWidth', 5);
        errorbar(xValues', rA1_norm(:,ch),    rA1_stdError_norm(:,ch), 'Color', colors(conditionsCounter,:), 'LineWidth', 1);
        conditionsCounter = conditionsCounter+1;
    end
    
    xlabel('Distance from edge (\mum)');
    ylabel([channelLabels{ch} ' (a.u.)']);
    xlim([0 350]); ylim([0 1.4]);
    ax = gca; ax.FontSize = 30; ax.FontWeight = 'bold';
end

%%
saveInPath = '/Volumes/sapnaDrive2/181113_leftyMediaChange_18_32h/radialAverages';
saveAllOpenFigures(saveInPath);
%%
saveInPath = '/Users/sapnachhabra/Desktop/figuresForPaper/figures/movement of smad2_new/rA_plots/IWP2/t_0_10_20_30_40_noLegend';
saveAllOpenFigures(saveInPath);













