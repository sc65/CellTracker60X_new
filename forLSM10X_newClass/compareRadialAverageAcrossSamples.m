
%% ------------------------------- compare rA values across samples

%%
clearvars;
masterFolder = '/Volumes/SAPNA/190712_bCatNogginLDN';
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
%load('/Users/sapnachhabra/Desktop/CellTrackercd/CellTracker60X/colorblind_colormap/goodColors_new.mat');
% 11 distinct colors. For more colors, use colorcube
colors = colorcube;
%%
% save rA values
%samples = samples([1 5 24]);
rA = cell(1,numel(samples));
nColonies = zeros(1,numel(samples));

for ii = 1:numel(samples)
    ii
    %for ii = 1:numel(samples)
    %for ii = 1:numel(samples)
    outputFile = [samplesFolder filesep samples(ii).name filesep 'output.mat'];
    load(outputFile, 'radialProfile_avg', 'goodColoniesId', 'xValues');
    nColonies(ii) = numel(goodColoniesId);
    rA{ii} = radialProfile_avg;
end

%%
% plot
controlSample = 1;
dapiEqualize = 0; % make dapi max the same across conditions

%colors = cell2mat({[0.7 0 0.5]; [0 0.7 0];  [0 0 0.7]; [0.7 0 0.5]; [0 0.7 0];  [0 0 0.7]});
%colors = cell2mat({[1.0 0.6 0]; [1 0 0.9];  [0.7 0.7 0.7];  [0.7 0.5 0.0]; [0 0.5 0.5]});
%sampleLabels = {'dish:media 45h' 'MP:bmp 45h', 'MP:media 11h', 'MP:media 45h'};

sampleLabels = {samples.name};

if dapiEqualize == 1
    rA1_dapi = rA{controlSample}.notNormalized.mean(1,:)./max(rA{controlSample}.notNormalized.mean(1,:));
    rA_max = max(rA{controlSample}.notNormalized.mean./rA1_dapi,[],2);
else
    rA_max = max(rA{controlSample}.dapiNormalized.mean,[],2);
end
%%
samplesToPlot = [1 3:8]; channelsToPlot = [2:3];
% plot
for ii = channelsToPlot
    figure; hold on; title(meta.channelNames{ii});
    
    %make legends of the right color.
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
        if dapiEqualize == 1
            rA1_dapi = rA{jj}.notNormalized.mean(1,:)./max(rA{jj}.notNormalized.mean(1,:));
            rA1 = rA{jj}.notNormalized.mean(ii,:)./rA1_dapi;
            rA1 = rA1./rA_max(ii);
            stdError1 = rA{jj}.notNormalized.stdError(ii,:)./rA1_dapi;
            stdError1 = stdError1./rA_max(ii);
        else
            rA1 = rA{jj}.dapiNormalized.mean(ii,:)./rA_max(ii);
            stdError1 = rA{jj}.dapiNormalized.stdError(ii,:)./rA_max(ii);
        end
        
        nBins = size(rA1,2);
        plot(xValues(1:nBins), rA1, 'Color', colors(jj,:), 'LineWidth', 5);
        errorbar(xValues(1:nBins), rA1, stdError1, 'Color', colors(jj,:), 'LineWidth', 2);
        xlabel('Distance from edge (\mum)'); ylabel('Intensity (a.u.)');
        ax = gca; ax.FontSize = 25; ax.FontWeight = 'bold';
    end
end
%%
saveInPath =[masterFolder filesep 'rA'];
saveAllOpenFigures(saveInPath);
%%







