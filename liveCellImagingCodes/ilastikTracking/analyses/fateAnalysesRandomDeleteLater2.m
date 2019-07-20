%%
% plot cdx2/venus vs brachyury/venus.
outputFilesPath = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles';

cdx2 = zeros(1, 500);
brachyury = zeros(1,500);
counter = 1;

for ii = 5
    for jj = 1:2
        outputFile = [outputFilesPath filesep 'outputColony'...
            int2str(ii) '_' int2str(jj) '.mat'];
        load(outputFile, 'matchedCellsfateData', 'allCellStats');
        ncells = size(matchedCellsfateData,1);
        
        brachyury(counter:counter+ncells-1) = matchedCellsfateData(:,4)./matchedCellsfateData(:,3);
        cdx2(counter:counter+ncells-1) = matchedCellsfateData(:,5)./matchedCellsfateData(:,3);
        valueToFind = matchedCellsfateData(:,5)./matchedCellsfateData(:,3);
        counter = counter+ncells;
    end
end

cdx2 = cdx2(1:counter-1);
brachyury = brachyury(1:counter-1);
%%
figure; plot(cdx2, brachyury,  '.', 'Color', [0.5, 0, 0], 'MarkerSize', 18);

xlabel('CDX2/Venus');
ylabel('T/Venus');
ax = gca;
ax.FontSize = 14;
ax.FontWeight = 'bold';
%%
masterFolderPath = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5';
outputFile1 = [masterFolderPath filesep 'outputFiles/outputall.mat'];
load(outputFile1, 'colonyCenters');
%%

% Where are high expression T/CDX2 cells coming from?
outputFilesPath = [masterFolderPath filesep 'outputFiles'];
colonyIds = 6;
outputFile2 =  [outputFilesPath filesep 'outputColony'...
    int2str(colonyIds(1)) '_' int2str(1) '.mat'];
load(outputFile2,'umToPixel');

fatePositionTable = makeFatePositionTableColonies(outputFilesPath, colonyIds);

% remove false positives from the output files.
% toRemove = [8 18];
% colonyPartId = fatePositionTable([toRemove], 9);
% cellIdsToRemove = fatePositionTable([toRemove],10);
% 
% fatePositionTable([toRemove],:) = [];

% Are the cell fates correctly matched?
nCells = size(fatePositionTable,1);
titles = {'T/Venus', 'CDX2/Venus'};
caxisLimits = [1.5 1]; %[T, CDX2].

for ii = 1:2
    figure;
    % color code by fates
    scatter(fatePositionTable(:,5), -fatePositionTable(:,6), 50, fatePositionTable(:,ii), 'filled');
    colorbar;
    caxis([0 caxisLimits(ii)]);
    hold on;
    
    % plot the circular colony
    center = colonyCenters{colonyIds};
    radius = 405*umToPixel;
    viscircles([center(1), -center(2)] ,radius ,'Color' ,'k');
    
    %     % plot the parent cells
    plot(fatePositionTable(:,7), -fatePositionTable(:,8), '.', 'Color', [0.5 0 0], 'MarkerSize', 15);
    %
    %
    %     % draw an arrow from parent to daughter cells.
    arrow([fatePositionTable(:,7) -fatePositionTable(:,8)] , [fatePositionTable(:,5), -fatePositionTable(:,6)]...
        , 1, 'Color', 'k');
    %
    
    for jj = 1:nCells
        text(fatePositionTable(jj,5)+5, -fatePositionTable(jj,6), int2str(jj) , 'FontSize', 10);
    end
    
    title(['colony' int2str(colonyIds) ' ' titles{ii}]);
end



% for ii = 1:2
%     outputFile2 =  [outputFilesPath filesep 'outputColony'...
%         int2str(colonyId) '_' int2str(colonyPartId(ii)) '.mat'];
%     load(outputFile2, 'matchedCellsfateData');
%     %%
%     matchedCellsfateData(:,6) = 1;
%     %%
%     matchedCellsfateData(ismember(matchedCellsfateData(:,1), cellIdsToRemove(ii)), 6) = 0;
%     %%
%     save(outputFile2, 'matchedCellsfateData', '-append');
% end

% scatter plots color coded by T/Venus, CDX2/Venus values.

colorBy = [1 2]; %column numbers corresponding to Brachyury, CDX2 values.
titles = {'T/Venus', 'CDX2/Venus'};

for ii = 1:2
    figure;
    scatter(fatePositionTable(:,4), fatePositionTable(:,3), 60, fatePositionTable(:,ii), 'filled');
    colorbar;
    caxis([0 caxisLimits(ii)]);
    hold on;
    plot([0 350], [77.2 77.2], 'k-.', 'LineWidth', 2);
    plot([0 350], [194.73 194.73], 'k-.', 'LineWidth', 2);
    
    plot([77.2 77.2], [0 350], 'k:', 'LineWidth', 2);
    plot([194.73 194.73], [0 350], 'k:', 'LineWidth', 2);
    
    xlabel('Distance from the edge (\mum) @ t0');
    if ii == 1
        ylabel('Distance from the edge (\mum) @ tEnd');
    end
    
    for jj = 1:nCells
        text(fatePositionTable(jj,4)+5, fatePositionTable(jj,3), int2str(jj) , 'FontSize', 10);
    end
    
    title(['colony' int2str(colonyIds) ' ' titles{ii}]);
    ax = gca;
    ax.FontSize = 12;
    ax.FontWeight = 'bold';
end
%%
yValues = [1 2]; % column numbers correponding to T, CDX2 values.
yLabels = {'Brachyury/Venus', 'CDX2/Venus'};
xValues = [4 3];
xLabels = {'Distance from the edge (\mum) @ t0', 'Distance from the edge (\mum) @ tEnd'};

figure;
counter = 1;

for ii = yValues
    xcounter = 1;
    for jj = xValues
        subplot(2, 2, counter);
        plot(fatePositionTable(:,jj), fatePositionTable(:,ii),  '.',...
            'Color', [0.5 0 0], 'MarkerSize', 20);
        
        if ii == 1 && jj == 4
            hold on;
            plot([211 211], [0 2], 'k-.', 'LineWidth', 2);
            
        end
        
        xlim([0 410]);
        xlabel(xLabels{xcounter});
        xcounter = xcounter+1;
        ylabel(yLabels{ii});
        ax = gca;
        ax.FontSize = 12;
        ax.FontWeight = 'bold';
        
        counter = counter+1;
    end
end



%% make the radial average plots to define three different regions.
figure; plot(fatePositionTable(:,4), fatePositionTable(:,3), '.'...)
    ,'Color', [0.5 0 0], 'MarkerSize', 14);

xlabel(xLabels{1});
ylabel(xLabels{2});

ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
hold on;
plot([0 350], [194.73 194.73], 'k-.', 'LineWidth', 1);
plot([211 211], [0 350], 'k-.', 'LineWidth', 2);

%%
outerCells = fatePositionTable(fatePositionTable(:,4) < 211,:);
%%
figure; plot(outerCells(:,2), outerCells(:,1), '.', 'Color', [0.5 0 0], 'MarkerSize', 20);
xlabel(yLabels{2});
ylabel(yLabels{1});

title('In the outer and Middle Region');

ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';




