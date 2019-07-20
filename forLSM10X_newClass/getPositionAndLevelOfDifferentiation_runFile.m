
%% -------------------------------------- %%
%% ---------- define a metric for -------------

% a) level of mesodermal differentiaiton
% b) position of mesodermal ring
% c) size of mesodermal ring

%%
masterFolder = '/Volumes/SAPNA/180314_96wellPlates/plate1';
metadata  = [masterFolder filesep 'metadata.mat'];
load(metadata);
%%
samplesFolder = [masterFolder filesep 'processedData'];
samples = dir(samplesFolder);
toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{samples.name},'UniformOutput',false))); % remove non-named folders
samples = samples(toKeep);
[~, idx] = natsortfiles({samples.name});
samples = samples(idx);

%%
ch = 2; % brachyury channel id
sampleIds = [5 9:15 24:31];
controlSample = 5;

for ii = sampleIds
    outputFile = [samplesFolder filesep samples(ii).name filesep 'output.mat'];
    load(outputFile);
    [positions_all{ii}, thresholds_all{ii}] = getPositionAndLevelOfDifferentiation(colonies, goodColoniesId, ch);
end
%%
thresholds_all  = cellfun(@(c) c./max(thresholds_all{controlSample}), thresholds_all, 'UniformOutput', false);
%%
% calculate mean and errors
nSamples = numel(sampleIds);
positions = struct;
width = struct;
levels = struct;


for ii = sampleIds
    position1 = positions_all{ii};
    if ~isempty(position1)
        position1(position1(:,1) == position1(:,2),1) = 0;
        width1 = position1(:,2) - position1(:,1);
        width.mean(ii,:) = mean(width1,1);
        width.std(ii,:) = std(width1,1)./sqrt(size(position1,1));
        positions.mean(ii,:) = mean(position1,1);
        positions.std(ii,:) = std(position1,[],1)./sqrt(size(position1,1));
        levels.mean(ii,:) = mean(thresholds_all{ii});
        levels.std(ii,:) =  std(thresholds_all{ii})./sqrt(size(position1,1));
    end
end
%%
%% LDN treatment data
treatment = 'LDN';
sampleLabels = {'10', '20', '30', '40'};
samplesToPlot = [9:2:15];
sampleColors = cell2mat({[1.0 0.6 0]; [0.8 0.8 0]; [0.7 0.7 0.7];  [1 0 0.9];  [0 0.5 0.5]});
makeBarPlots(treatment, samplesToPlot, sampleLabels, sampleColors, levels, positions, width);

%% IWP2 treatment data
treatment = 'IWP2';
sampleLabels = {'20', '25', '40'};
samplesToPlot = [27 28 31];
sampleColors = cell2mat({[0.7 0.7 0.7]; [0.6 0.5 0];  [0 0.5 0.5]});
makeBarPlots(treatment, samplesToPlot, sampleLabels, sampleColors, levels, positions, width);
%%

saveInPath = '/Users/sapnachhabra/Desktop/figuresForPaper/figures/brachyury_LDN_IWP2_SB/mesodermalRingPosition';
saveAllOpenFigures(saveInPath);

%% ---------------------------------------------------------------------------------------------
%% ---------------------------------------------------------------------------------------------
%% ---------------------------------------------------------------------------------------------

function makeBarPlots(treatment, samplesToPlot, sampleLabels, sampleColors, levels, positions, width)
% positions
x1 = 1:numel(samplesToPlot);
yLabels = {'back', 'front', 'peak'};
for ii = 1:3
    figure; hold on;
    b= bar(diag(positions.mean(samplesToPlot,ii)), 'stacked');
    
    for jj = 1:numel(samplesToPlot)
        b(jj).FaceColor= sampleColors(jj,:);
        b(jj).BarWidth = 0.6;
    end
    er = errorbar(x1, positions.mean(samplesToPlot,ii), positions.std(samplesToPlot,ii), 'LineWidth', 2);
    er.Color = [0 0 0]; er.LineStyle = 'none';
    xlim([0.5 numel(samplesToPlot)+0.5]); xlabel(['Time of ' treatment ' addition(h)']);
    ylabel(['mesodermal ring ' yLabels{ii} ;{'(Distance from edge (\mum)'}]);
    ax = gca; ax.XTick = 1:numel(samplesToPlot); ax.XTickLabel = sampleLabels;
    ax.FontSize = 25; ax.FontWeight = 'bold';
end

%%
% width
figure; hold on;
b = bar(diag(width.mean(samplesToPlot)), 'stacked');
for jj = 1:numel(samplesToPlot)
    b(jj).FaceColor= sampleColors(jj,:);
    b(jj).BarWidth = 0.6;
end
er = errorbar(x1, width.mean(samplesToPlot), width.std(samplesToPlot),  'LineWidth', 2);
er.Color = [0 0 0]; er.LineStyle = 'none';
xlim([0.5 numel(samplesToPlot)+0.5]); xlabel(['Time of ' treatment ' addition(h)']); ylabel('mesodermal ring width (\mum)');
ax = gca; ax.XTick = 1:numel(samplesToPlot); ax.XTickLabel = sampleLabels;
ax.FontSize = 25; ax.FontWeight = 'bold';

%%

% levels
figure; hold on;
b = bar(diag(levels.mean(samplesToPlot)), 'stacked');
for jj = 1:numel(samplesToPlot)
    b(jj).FaceColor= sampleColors(jj,:);
    b(jj).BarWidth = 0.6;
end
er = errorbar(x1, levels.mean(samplesToPlot), levels.std(samplesToPlot),  'LineWidth', 2);
er.Color = [0 0 0]; er.LineStyle = 'none';

xlim([0.5 numel(samplesToPlot)+0.5]); xlabel(['Time of ' treatment ' addition(h)']); ylabel([{'mesodermal differentiation'}; {'(a.u.)'}]);
ax = gca; ax.XTick = 1:numel(samplesToPlot); ax.XTickLabel = sampleLabels;
ax.FontSize = 25; ax.FontWeight = 'bold';
%%
end






