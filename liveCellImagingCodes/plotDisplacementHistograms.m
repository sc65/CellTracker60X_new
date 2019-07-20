function plotDisplacementHistograms(allstats, colonyMask, umtopixel, plotnum)
% plot histograms.
% Total Displacement
% Radial Displacemnt
% Angular Displacement
% Change in Beta catenin Expression.

%% Total displacement
d1 = findDisplacementfromAllstats(allstats, 1);
d1 = d1/umtopixel; %in microns.
%% Displacement in the radial and angular direction.
stats = regionprops(colonyMask, 'Centroid');
ColonyCenter = [stats.Centroid];

startPositions = (squeeze(allstats(1,2:3,:)))';
startDistance = sqrt((startPositions(:,2) - ColonyCenter(2)).^2 + (startPositions(:,1) - ColonyCenter(1)).^2);
startDistance = startDistance/umtopixel;

startTheta = atan2d(startPositions(:,2) - ColonyCenter(2), startPositions(:,1) - ColonyCenter(1));
startTheta(startTheta<0) = 360+startTheta(startTheta<0); %convert angles in the range [0-360].

endPositions = (squeeze(allstats(end,2:3,:)))';
endDistance =  sqrt((endPositions(:,2) - ColonyCenter(2)).^2 + (endPositions(:,1) - ColonyCenter(1)).^2);
endDistance = endDistance/umtopixel;

endTheta = atan2d(endPositions(:,2) - ColonyCenter(2), endPositions(:,1) - ColonyCenter(1));
endTheta(endTheta<0) = 360+endTheta(endTheta<0);

r1 = endDistance-startDistance; %radial displacement
%%
angleFromTheCenter = [startTheta endTheta];
a1 = endTheta-startTheta;

from4to1 = find(angleFromTheCenter(:,1)>270 & angleFromTheCenter(:,2)<90);
a1(from4to1) = 360-angleFromTheCenter(from4to1,1) + angleFromTheCenter(from4to1,2);

%% Change in b-cat levels.
startIntensity = squeeze(allstats(1,7,:))./squeeze(allstats(1,6,:));
endIntensity = squeeze(allstats(end,7,:))./squeeze(allstats(end,6,:));
foldChangeIntensity = endIntensity./startIntensity;
%%
if plotnum == 1
    dataToPlot = [d1,r1,a1, startIntensity, endIntensity, foldChangeIntensity];
    binwidths = [10 10 5, 0.25, 0.25, 0.5];
    titles = {'Displacement', 'Radial Displacement', 'Angular Displacement', 'Intensity @ 26hr', 'Intensity @ 36hr', 'Fold Change in b-cat Intensity'};
    
    for ii = 1:size(dataToPlot,2)
        if ii == 4 || ii == 5
            if ii == 4
                figure;
                histogram(dataToPlot(:,ii), 'Normalization', 'Probability', 'BinWidth', binwidths(ii));
                
            else
                hold on;
                histogram(dataToPlot(:,ii), 'Normalization', 'Probability', 'BinWidth', binwidths(ii));
            end
            legend(titles{4}, titles{5});
            hold off;
        else
            figure;
            histogram(dataToPlot(:,ii), 'Normalization', 'Probability', 'BinWidth', binwidths(ii));
            title(titles{ii});
        end
        ax = gca;
        ax.FontSize = 12;
        ax.FontWeight = 'Bold';
    end
end
%%
% Scatter Plots
%1) Does the displacement - radial, angular or total, correlate with the fold change in b-cat levels?
%2) Does the radial position - start or end correlate with change in b-cat
%levels?
if plotnum == 2
    Ydata = [d1,r1,a1, startDistance, endDistance, endIntensity];
    
    Ylabels = {'Displacement', 'Radial Displacement', 'Angular Displacement', 'Distance from center(26hr)', 'Distance from center(36hr)', '\beta catenin @ 36hr'};
    
    figure;
    hold on;
    for ii = 1:size(Ydata,2)
        subplot(2,3,ii);
        plot(foldChangeIntensity, Ydata(:,ii), 'b.', 'MarkerSize', 10);
        xlabel('Fold Change in \beta catenin');
        ylabel(Ylabels{ii});
        ax = gca; ax.FontSize = 12; ax.FontWeight = 'Bold';
    end
    hold off;
    
    % Is the displacement related to start or end position?
    figure;
    hold on;
    toPlot = [1:3 6]; %corresponds to Ydata vector.
    for ii = 1:numel(toPlot)
        subplot(2,4,ii);
        plot(startDistance, Ydata(:,toPlot(ii)), 'r.', 'MarkerSize', 10);
        xlabel(Ylabels{4});
        xlim([0 420]);
        ylabel(Ylabels{toPlot(ii)});
        ax = gca; ax.FontSize = 12; ax.FontWeight = 'Bold';
        
        subplot(2,4,4+ii);
        plot(endDistance, Ydata(:,toPlot(ii)), 'r.', 'MarkerSize', 10);
        xlabel(Ylabels{5});
        xlim([0 420]);
        ylabel(Ylabels{toPlot(ii)});
        ax = gca; ax.FontSize = 12; ax.FontWeight = 'Bold';
    end
    hold off;
end%
%%
% scatter plots w.r.t absolute beta catenin levels.

if plotnum == 3
    Ydata = [d1,r1,a1, startDistance, endDistance, foldChangeIntensity];
    
    Ylabels = {'Displacement', 'Radial Displacement', 'Angular Displacement', 'Distance from center(26hr)', 'Distance from center(36hr)', '\beta catenin @ 36hr'};
    
    figure;
    hold on;
    for ii = 1:size(Ydata,2)
        subplot(2,3,ii);
        plot(endIntensity, Ydata(:,ii), 'b.', 'MarkerSize', 10);
        xlabel('\beta catenin @ 36 hrs');
        ylabel(Ylabels{ii});
        ax = gca; ax.FontSize = 12; ax.FontWeight = 'Bold';
    end
    hold off;
    
    % Is the displacement related to start or end position?
    figure;
    hold on;
    toPlot = [1:3 6]; %corresponds to Ydata vector.
    for ii = 1:numel(toPlot)
        subplot(2,4,ii);
        plot(startDistance, Ydata(:,toPlot(ii)), 'r.', 'MarkerSize', 10);
        xlabel(Ylabels{4});
        xlim([0 420]);
        ylabel(Ylabels{toPlot(ii)});
        ax = gca; ax.FontSize = 12; ax.FontWeight = 'Bold';
        
        subplot(2,4,4+ii);
        plot(endDistance, Ydata(:,toPlot(ii)), 'r.', 'MarkerSize', 10);
        xlabel(Ylabels{5});
        xlim([0 420]);
        ylabel(Ylabels{toPlot(ii)});
        ax = gca; ax.FontSize = 12; ax.FontWeight = 'Bold';
    end
    hold off;
end%
%% Plot cells inside the colonyBoundary color coded by final beta cetenin levels.

if plotnum == 4
    colonyBoundary = bwboundaries(colonyMask);
    %find the largest cell.
    [~, maxcellind] = max(cellfun(@numel,colonyBoundary));
    x1 = colonyBoundary{maxcellind}(:,2);
    y1 = -colonyBoundary{maxcellind}(:,1);
    k = convhull(x1, y1);
    figure;
    plot(x1(k), y1(k), 'k-', 'LineWidth', 2); %Colony Boundary.
    hold on;
    scatter(endPositions(:,1), -endPositions(:,2), 50, endIntensity, 'filled');
    ncells = size(allstats,3);
    for kk = 1:ncells %displaying the label of the cell in frame 1 , next to it.
        text(endPositions(kk,1)+1, -endPositions(kk,2)+2, int2str(allstats(1,1,kk)), 'Fontsize', 12, 'FontWeight', 'bold');
    end
    title('\beta catenin intensity @ 36 hr');
    
end

%% plot changing beta catenin levels in individual cells.
if plotnum == 5
    figure;
    ncells = size(allstats,3);
    timepoints = size(allstats,1);
    cellIds = squeeze(allstats(1,1,:))';
    
    counter = 1;
    colors = {'r', 'b', 'k', 'm', 'g'};
    
    for ii = 1:ncells
        bcatIntensity = squeeze(allstats(:,7,ii))./squeeze(allstats(:,6,ii));
        
        if (mod(ii-1,5) == 0)
            subplot(3,3,counter);
        end
        hold on;
        plot(1:timepoints, bcatIntensity', 'Color', colors{mod(ii,5)+1});
        ylim([0 5]);
        if(mod(ii-1,5) == 4)
            legend(strsplit(int2str(cellIds((counter-1)*5+1:(counter-1)*5+5))));
            counter = counter+1;
        end
    end
end

%% group the cells by absolute beta catenin levels.
% remove cells which have a absolute value greater than 5
if plotnum == 6
    counter1 = 1;
    counter2 = 1;
    counter3 = 1;
    ncells = size(allstats,3);
    timepoints = size(allstats,1);
    cellIds = squeeze(allstats(1,1,:))';
    
    
    for ii = 1:ncells
        bcat = squeeze(allstats(:,7,ii))./squeeze(allstats(:,6,ii));
        cellId = cellIds(ii);
        if ~any(bcat > 5) %only include the non-dividing cells.
            if any(bcat > 1)
                if bcat(end)/bcat(1) > 1%increases in intensity
                    upBcat(1:timepoints,counter1) = bcat;
                    upBcat(timepoints+1,counter1) = cellId; %include cellId in the last row.
                    counter1 = counter1+1;
                else
                    downBcat(1:timepoints,counter2) = bcat;
                    downBcat(timepoints+1,counter2) = cellId;
                    counter2 = counter2+1;
                end
            else
                noChangeBcat(1:timepoints,counter3) = bcat;
                noChangeBcat(timepoints+1,counter3) = cellId;
                counter3 = counter3+1;
            end
        end
    end
    
    %% plot nochangeBcat upBcat and downBcat separately.
    dataToPlot = {upBcat, downBcat, noChangeBcat};
    for ii = 1:length(dataToPlot)
        figure;
        ncells = size(dataToPlot{ii},2);
        cellIds = dataToPlot{ii}(end,:);
        
        counter = 1;
        colors = {'r', 'b', 'k', 'm', 'g'};
                
        for jj = 1:ncells
            bcat = dataToPlot{ii}(1:end-1,jj);
            if (mod(jj-1,3) == 0)
                if ii == 1
                    subplot(4,2,counter);
                elseif ii == 2
                    subplot(3,2,counter);
                else
                    subplot(2,2, counter);
                end
            end
            hold on;
            plot(1:timepoints, bcat', 'Color', colors{mod(jj,3)+1});
            ylim([0 5]);
            if(mod(jj-1,3) == 2)|| jj == ncells
                if mod(jj-1,3)==2
                legend(strsplit(int2str(cellIds((counter-1)*3+1:(counter-1)*3+3))));
                counter = counter+1;
                else
                    legend(strsplit(int2str(cellIds((counter-1)*3+1:end))));
                end
                    
            end
        end
    end
    
end























