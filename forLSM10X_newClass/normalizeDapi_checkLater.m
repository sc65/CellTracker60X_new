%%

% because final cell density (maximum cell density in a colony) is fairly constant across different conditions,
% I think I can normalize dapi values.

masterFolder = '/Volumes/SAPNA/180314_96wellPlates/Lsm20X/allConditionsMoreImages/smad2_data/plate1';
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
% check if dapi levels are comparable
controlSample = 2;
samplesToConsider = [2:20];

for ii = samplesToConsider
    outputFile = [samplesFolder filesep samples(ii).name filesep 'output.mat'];
    load(outputFile, 'radialProfile_avg', 'goodColoniesId', 'xValues');
    nColonies(ii) = numel(goodColoniesId);
    if ii == controlSample
        rA_max = max(radialProfile_avg.notNormalized.mean,[],2);
    end
    rA{ii} = radialProfile_avg;
end
%%
% find maximum values in control sample
controlSample = 2; ch = 3;

dapi1 = rA{controlSample}.notNormalized.mean(1,:);
dapi1_max = max(dapi1);
dapi1 = dapi1./dapi1_max;

smad1 = rA{controlSample}.notNormalized.mean(3,:);
smad1 = smad1./dapi1;
smad1_max = max(smad1);

%%
samplesToPlot = [2 3 20]; smad1_ch =3;
sampleColors = cell2mat({[0 0 0]; [1.0 0.6 0]; [1 0 0.9]});
sampleLabels = {'Control', 'IWP2@0h', 'SB@0h'};
plotSmad1rA(rA, dapi1_max, smad1_max, smad1_ch, samplesToPlot, sampleLabels, sampleColors, xValues);

%%
samplesToPlot = [2 3 11 19 20]; smad1_ch =3;
sampleColors = cell2mat({[0 0 0]; [1.0 0.6 0]; [0.8 0.8 0]; [0.7 0.7 0.7];  [1 0 0.9]});
sampleLabels = {'Control', 'IWP2@0h', 'LDN@0h', 'Nodal-/-', 'SB@0h'};
plotSmad1rA(rA, dapi1_max, smad1_max, smad1_ch, samplesToPlot, sampleLabels, sampleColors, xValues);

%%
samplesToPlot = [11 12:2:18 2]; smad1_ch =3;
sampleColors = cell2mat({[1.0 0.6 0]; [0.8 0.8 0]; [0.7 0.7 0.7];  [1 0 0.9];  [0 0.5 0.5]; [0 0 0]});
sampleLabels = {'LDN@0h' 'LDN@10h', 'LDN@20h', 'LDN@30h', 'LDN@40h', 'Control'};
plotSmad1rA(rA, dapi1_max, smad1_max, smad1_ch, samplesToPlot, sampleLabels, sampleColors, xValues);

%%
saveInPath = '/Users/sapnachhabra/Desktop/figuresForPaper/figures/movement of smad2_new/rA_plots/smad1';
saveAllOpenFigures(saveInPath);
%%
function plotSmad1rA(rA, dapi1_max, smad1_max, ch,  samplesToPlot, sampleLabels, sampleColors, xValues)
counter = 1;
figure; hold on;
for ii = samplesToPlot
    %---make legends of the right color
    for jj = 1:numel(samplesToPlot)
        plot(0, 0, 'Color', sampleColors(jj,:));
    end
    
    [~,hObj]=legend(sampleLabels, 'FontSize', 25, 'FontWeight', 'bold');
    hL=findobj(hObj,'type','line');
    set(hL,'linewidth',6);
    
    hT=findobj(hObj,'type','text');
    for jj = 1:numel(samplesToPlot)
        hT
        hT(jj).Color = sampleColors(jj,:);% font color
    end
    legend('boxoff');
    
    dapi1 = rA{ii}.notNormalized.mean(1,:);
    dapi1 = dapi1./dapi1_max;
    if ii == 20 % renormalize sb treated sample.
        dapi1 = dapi1./max(dapi1);
    end
    smad1 = rA{ii}.notNormalized.mean(ch,:);
    smad1 = smad1./dapi1;
    smad1_stdError = rA{ii}.notNormalized.stdError(ch,:)./dapi1;
    smad1 = smad1./smad1_max;
    smad1_stdError = smad1_stdError./smad1_max;
    plot (xValues, smad1, 'Color', sampleColors(counter,:), 'LineWidth', 5);
    errorbar(xValues, smad1, smad1_stdError, 'Color', sampleColors(counter,:), 'LineWidth', 2);
    counter = counter+1;
    
    xlabel('Distance from edge(\mum)'); ylabel('Intensity(a.u.)');
    ax = gca; ax.FontSize = 25; ax.FontWeight = 'bold';
end
end
