function onlyCircles_radialAvergeOneColony(peaks, maxRA1)
%% plots radial average for one colony.
%% -----------------------Inputs-------------------
% 1) peaks/plate: variable containing colonies information

%% -------------------------------------------------
% standard. Check umToPixel
%% -------------------------------------
fChannels = [6 8 10]; %column(s) (in array peaks) corresponding to the fluorescent channel that needs to be quantified.
nChannel = 5; % column corresponding to DAPI channel - used to normalise data.

channelLabels = {'CDX2', 'Sox2', 'T'};
%channelLabels = {'smad2', 'smad1', 'sox17'};

colors = {[0.5 0 0], [0 0 0.5], [0 0.5 0.5]};

% average across all colonies
binSize = 50; %in pixels
rollSize = 20;
dapiNorm = 0;
umToPixel = 1.5;
channelToPlot = [1:3];
tooHigh = [3e3, 8e3,8e3]; 
yLimit = 2.0;

if ~exist('maxRA1', 'var')
    maxRA1 = 1;
end
%%
for ii = 1:size(peaks,2)
    ii 
    figure; hold on;
         
        [rA, ~, xValues] = calculateRadialAverageFromEdge(peaks, ii, fChannels, nChannel,...
        binSize, rollSize, dapiNorm, umToPixel, tooHigh);
        
        %%
        % -- sample Plot
        %get the legends in correct color and order.
        for jj = channelToPlot
            plot(0, 0, 'Color', colors{jj});
            xlabel('Distance from outer edge (\mum)');
            ylabel('Radial Average (a.u.)');
            ylim([0 yLimit]);
            xlim([0 xValues(end)+10]);
        end
        
        [~,hObj]=legend(channelLabels);           % return the handles array
        hL=findobj(hObj,'type','line');  % get the lines, not text
        set(hL,'linewidth',2);
         
        for kk = channelToPlot
            rA(:,kk) = rA(:,kk)./maxRA1(kk);
            plot(xValues, rA(:,kk),  'Color', colors{kk}, 'LineWidth', 4);            
        end
        
        title(['Colony' int2str(ii)]);
        ax = gca;
        ax.FontSize = 14;
        ax.FontWeight = 'bold';
    
 
end