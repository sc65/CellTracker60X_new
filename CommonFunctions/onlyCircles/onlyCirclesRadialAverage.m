function maxRA1 = onlyCirclesRadialAverage (peaks, maxRA1)
%% Input--------------------
% 1)peaks/plate - variable containing colonies information

%% calculate Radial Average and Plot Data


%%
fChannels = [6 8 10]; %column(s) (in array peaks) corresponding to the fluorescent channel that needs to be quantified.
nChannel = 5; % column corresponding to DAPI channel - used to normalise data.

%channelLabels = {'CDX2', 'Sox2', 'T'};
channelLabels = {'smad1', 'sox17', 'smad2'};
colors = {[0.5 0 0], [0 0.5 0], 'm'};
%%
% average across all colonies
binSize = 50; %in pixels
rollSize = 30;
dapiNorm = 0;
umToPixel = 1.6;
channelToPlot = [1:3];
tooHigh = [3e3, 8e3,8e3];
ylimit =1.2;

n = 1;
for shapeNum = 2
    %while n <12
    coloniesInShape = find([peaks.colonies.shape] == shapeNum);
    [rA, rAerr, xValues] = calculateRadialAverageFromEdge(peaks, coloniesInShape, fChannels, nChannel,...
        binSize, rollSize, dapiNorm, umToPixel, tooHigh);
    
    if ~exist('maxRA1', 'var')
        maxRA1 = max(rA);   
    end
    %%
    % -- sample Plot
    figure;
    hold on;
    %get the legends in correct color and order.
    for ii = channelToPlot
        plot(0, 0, 'Color', colors{ii});
        xlabel('Distance from edge (\mum)');
        ylabel('Radial Average (a.u.)');
        ylim([0 ylimit]);
        xlim([0 xValues(end)+10]);
    end
    
    [~,hObj]=legend(channelLabels, 'FontSize', 12);  % return the handles array
    hL=findobj(hObj,'type','line');  % get the lines, not text
    set(hL,'linewidth',2);
    
    for ii = channelToPlot
        rA(:,ii) = rA(:,ii)./maxRA1(ii);
        rAerr(:,ii) = rAerr(:,ii)./maxRA1(ii);
        plot(xValues, rA(:,ii),  'Color', colors{ii}, 'LineWidth', 4);
        errorbar(xValues, rA(:,ii), rAerr(:,ii), 'Color', colors{ii}, 'LineWidth', 2);
    end
    
    ax = gca;
    ax.FontSize = 16;
    ax.FontWeight = 'bold';
    
    %title([Condition ' n =' int2str(numel(coloniesInShape))]);
    % end
    
end



