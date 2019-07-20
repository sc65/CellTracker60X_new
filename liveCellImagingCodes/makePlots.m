%%
%function makePlots(allstats, timepoints)
% Making relevant plots.
% Divide cells into territories.
% Remove false positives.

% Plot
% a) distance from the edge.
% b) distance moved.
% c) speed of movement.
% d) Changing beta cat levels.

%%
processT = @(t) (t-1).*3 + 1;%% convert hour to timepoint
timepoints = processT([26 36]);

umtopixel = 1.55;
territories = [0 57 200 400];

ylabels = {'Distance from the edge at t / Distance from the edge at t0', 'Distance Moved (\mum)', 'Speed(\mum/hr)', 'nuclear \betacat/RFP'};
ylimits = [2 35 150 7];


for ii = 1:3
    mindistance = territories(ii)*umtopixel;
    maxdistance = territories(ii+1)*umtopixel;
    
    %select cells whose distance from the edge fall between mindistance and
    %maxdistance at t0.
    distance_from_edge_t0 = squeeze(allstats(1,4,:));
    
    condition_to_satisfy = distance_from_edge_t0 > mindistance & distance_from_edge_t0 < maxdistance;
    cells_in_territory = allstats(:,:, condition_to_satisfy);
    
    ncells = size(cells_in_territory,3);
    figure; % make a subplot for every relevant statistic. [distance from the edge; distance moved; Speed; GFP/RFP]
    plotnum = 1;
    
    for plot_counter = 4:5
        valuesAllCells = zeros(size(allstats,1), ncells);
        cellLabels = zeros(1, ncells);
        
        
        subplot(1,2,plotnum);
        hold on;
        
        
        %plot1: distance from edge at time t/ distance from edge at time 1.
        for jj = 1:ncells
            if plot_counter == 2
                distance_from_edge = squeeze(cells_in_territory(:,4,jj))./squeeze(cells_in_territory(1,4,jj));
                values = distance_from_edge./umtopixel;
            elseif plot_counter == 3
                distance_travelled= squeeze(cells_in_territory(:,5,jj));
                values = distance_travelled./umtopixel;
            elseif plot_counter == 4
                distance_travelled= squeeze(cells_in_territory(:,5,jj));
                values = distance_travelled./umtopixel;
                values = values./0.3; % speed in um/hour.
            else
                values = squeeze((cells_in_territory(:,7,jj)))./squeeze((cells_in_territory(:,6,jj)));
            end
            valuesAllCells(:,jj) = values;
            cellLabels(jj) = squeeze(cells_in_territory(1,1,jj));
            
            plot(linspace(timepoints(1), timepoints(2), size(valuesAllCells,1)), values, '-', 'LineWidth', 2);
        end
        %plot(linspace(timepoints(1), timepoints(2), size(valuesAllCells,1)), mean(valuesAllCells,2), '-', 'LineWidth', 2);
        
        xlabel('Time after Differentiation(hrs)');
        ylabel(ylabels{plot_counter-1});
        title(['Territory ' int2str(ii)]);
        
        ax = gca;
        ax.FontSize = 12;
        hold off;
        ylim([0 ylimits(plot_counter-1)]);
        plotnum = plotnum+1;
        
        
        if plot_counter == 5
            legend(strsplit(int2str(cellLabels), ' '));
        end
        %showCells(peaks, nuclear_masks, timepoints, cells_in_territory);
    end
    
    %legend('Territory 1', 'Territory 2', 'Territory 3');
end

%%
% Plot a histogram of nuclear beta catenin expression values in cells at the first and last time point in different territories. 








































