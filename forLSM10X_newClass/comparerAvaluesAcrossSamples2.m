
%% ------------------------------- compare rA values across samples for joint (combined) output files.


%%
masterFolder = '/Volumes/sapnaDrive2/190210_dkk_timing';
metadata  = [masterFolder filesep 'metadata.mat'];
load(metadata);
%%
samplesFolder = [masterFolder filesep 'combinedOutputFiles'];
samples = dir([samplesFolder filesep '*.mat']);

%%
load('/Users/sapnachhabra/Desktop/CellTrackercd/CellTracker60X/colorblind_colormap/goodColors_new.mat');
% 11 distinct colors. For more colors, use colorcube

%%
% save rA values
rA = cell(1,numel(samples));
nColonies = zeros(1,numel(samples));
sampleLabels = rA;

for ii = 1:numel(samples)
    outputFile = [samplesFolder filesep samples(ii).name];
    load(outputFile, 'radialProfile_avg', 'goodColoniesId', 'sampleNames');
    nColonies(ii) = numel(goodColoniesId);
    rA{ii} = radialProfile_avg;
    sampleLabels{ii} = sampleNames{1};
end

%%
controlSample = 2;
rA_max = max(rA{controlSample}.dapiNormalized.mean,[], 2);
sampleLabels = strrep(sampleLabels, '_', ' ');
%%

channelsToPlot = [2:4];
samplesToPlot = [1 2 4 5];
%%
%colors = cell2mat({[0.7 0.5 0]; [0 0.6 0]; [0.5 0 0.5]; [0 0.3 0.7]});

% plot
for ii = channelsToPlot
    figure; hold on; title(meta.channelNames{ii});
    
    % make legends of the right color.
    for jj = samplesToPlot
        plot(0, 0, 'Color', colors(jj,:)); % font color
    end
    [~,hObj]=legend(sampleLabels(samplesToPlot), 'FontSize', 25, 'FontWeight', 'bold');   % return the handles array
    hL=findobj(hObj,'type','line');  % get the lines, not text
    set(hL,'linewidth',6);
    hT=findobj(hObj,'type','text');
    
    for jj = 1:numel(samplesToPlot)
        set(hT(jj),'Color', colors(samplesToPlot(jj),:)); % line color
    end
    legend('boxoff');
    
    counter = 1;
    for jj = samplesToPlot
        rA1 = rA{jj}.dapiNormalized.mean(ii,:)./rA_max(ii);
        stdError1 = rA{jj}.dapiNormalized.stdError(ii,:)./rA_max(ii);
        
        nBins = size(rA1,2);
        plot(xValues(1:nBins), rA1, 'Color', colors(jj,:), 'LineWidth', 5);
        errorbar(xValues(1:nBins), rA1, stdError1, 'Color', colors(jj,:), 'LineWidth', 2);
        xlabel('Distance from edge (\mum)'); ylabel('Intensity (a.u.)');
        ax = gca; ax.FontSize = 25; ax.FontWeight = 'bold';
    end
end
%%
saveInPath ='/Volumes/sapnaDrive2/190210_dkk_timing/rA_plots';
saveAllOpenFigures(saveInPath);
