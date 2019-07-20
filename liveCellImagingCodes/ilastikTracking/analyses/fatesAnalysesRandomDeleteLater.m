%%
masterFolderPath = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5';
outputFile1 = [masterFolderPath filesep 'outputFiles/outputall.mat'];
load(outputFile1, 'colonyCenters');
%%

for colonyId = 2
    for ii = 1:2
        outputFile = [masterFolderPath filesep 'outputFiles/outputColony' int2str(colonyId)...
            '_' int2str(ii) '.mat'];
        load(outputFile,  'allCellStats', 'goodCells', 'matchedCellsfateData',  'umToPixel');
        
        trackedCells = matchedCellsfateData(:,1);
        daughterCellsData = allCellStats(trackedCells);
        lineageIdsDaughters = cellfun(@(x)(x(1,3)), daughterCellsData);
        allDaughterCellsX = cellfun(@(x)(x(end,1)), daughterCellsData);
        allDaughterCellsY = cellfun(@(x)(x(end,2)), daughterCellsData);
        
        brachyury = matchedCellsfateData(:,4)./matchedCellsfateData(:,3);
        cdx2 = matchedCellsfateData(:,5)./matchedCellsfateData(:,3);
        
        if ii == 1
            figure;
            center = colonyCenters{colonyId};
            radius = 405*umToPixel;
            viscircles([center(1), -center(2)] ,radius ,'Color' ,'k');
            title(['colony' int2str(colonyId) 'brachyury']);
        end
        
        hold on;
        scatter(allDaughterCellsX, -allDaughterCellsY, 80, brachyury, 'filled');
        colorbar;
        caxis([0 1.5]);
        
        for jj = 1:length(trackedCells)
            daughterCellPosition = [allDaughterCellsX(jj) allDaughterCellsY(jj)];
            
            lineageId =  lineageIdsDaughters(jj);
            parentCell = find(goodCells == lineageId); %The ancestor cell has track Id = lineageId.
            
            parentCellPosition = allCellStats{parentCell}(1,1:2);
            plot(parentCellPosition(1,1), -parentCellPosition(1,2), 'Marker', '.', 'Color', [0.4 0 0], 'MarkerSize', 18);
            arrow([parentCellPosition(1,1) -parentCellPosition(1,2)] , [daughterCellPosition(1,1), -daughterCellPosition(1,2)]...
                , 1, 'Color', 'k');
        end
    end
end




