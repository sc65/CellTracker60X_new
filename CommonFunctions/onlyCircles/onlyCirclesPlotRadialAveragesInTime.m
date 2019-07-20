function onlyCirclesPlotRadialAveragesInTime (outputFiles, legendLabels, maxRA)
%% radial Average In Time

%%
fChannels = [6 8 10]; %column(s) (in array peaks) corresponding to the fluorescent channel that needs to be quantified.
nChannel = 5; % column corresponding to DAPI channel - used to normalise data.
binSize = 50; %in pixels
rollSize = 20;
dapiNorm = 0; % set to 1, if normalize dapi values across samples.
umToPixel = 1.5;
tooHigh = [3e3, 8e3,8e3];
toNorm = 1; % set to 1, if normalize by maxRA;

%% legend labels
%samples = ['Control', strcat(strsplit(int2str([0:5:40]), ' '), 'h')];
if ~exist('legendLabels', 'var')   
    samples =  [strcat(strsplit(int2str([1:numel(outputFiles)]), ' '), 'h')];
else
    samples = legendLabels;
end
%%
titles = {'cdx2', 'sox2', 'T'};
samplesToPlot = [1:numel(outputFiles)]; % plot a subset/complete set of files
%% the function "calculateRadialAverageFromEdge" will work with both peaks and plate as the first input.
% ----using peaks----

rA = cell(1,numel(outputFiles));
rAerr = rA; xValues = rA;
for ii = 1:numel(outputFiles)
    load (outputFiles{ii}, 'peaks');
    %peaks = peaks1;
    
    colonies1 = 1:length(peaks);
    [rA{ii}, rAerr{ii}, xValues{ii}] = calculateRadialAverageFromEdge(peaks, colonies1, fChannels, nChannel,...
        binSize, rollSize, dapiNorm, umToPixel, tooHigh);
end
%% 3 plots

%%
colors = rand(numel(outputFiles),3);
colors = cell2mat({[0.9, 0.3, 0.2];  [0.7, 0.6, 0.0]; [0, 0, 0.6]; [0.9, 0, 0]});
%%
for ch = 3
    
    figure;
    hold on; % correct labels
    for ii = samplesToPlot
        plot(0, 0, 'Color', colors(ii,:));
        xlabel('Distance from outer edge (\mum)');
        ylabel('Radial Average (a.u.)');
        %ylim([0 1.3]);
        xlim([0 400+10]);
    end
    
    [~,hObj]=legend(samples(samplesToPlot), 'FontSize', 14);           % return the handles array
    hL=findobj(hObj,'type','line');  % get the lines, not text
    set(hL,'linewidth',4);
    
    if ~exist('maxRA', 'var')
        if toNorm == 1 % normalization
            maxRA = max(rA{1});
            
        else
            maxRA = ones(1, numel(fChannels));
        end
    end
    
    for jj = samplesToPlot %plot
        
        %maxRA = max(rA{jj}); %-- uncomment, if peak normalize
        rA1 = rA{jj}(:,ch)./maxRA(ch);
        rAerr1 = rAerr{jj}(:,ch)./maxRA(ch);
        xValues1 = xValues{jj};
        plot(xValues1, rA1,  'Color', colors(jj,:), 'LineWidth', 5);
        errorbar(xValues1, rA1, rAerr1, 'Color', colors(jj,:), 'LineWidth', 3);
        
        if jj == samplesToPlot(end)
            xlabel('Distance from edge (\mum)');
            ylabel('radial average (a.u.)');
            %title(titles{ch});
            ax = gca;
            ax.FontWeight = 'bold'; ax.FontSize = 20;
        end
    end
end
%%




