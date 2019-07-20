function fatePositionTable = makeFatePositionTableOneColony(outputFilesPath, colonyIds)
%% returns the positions and final fate levels of all tracked cells in a colony.
% results stored in a table - fatPositionTable with the columns:
%[T/Venus, cdx2/venus distanceFromEdgeTEnd distanceFromEdgeT0 xEnd yEnd xStart yStart]


fatePositionTable = zeros(1000,8);
counter = 1;
for ii = colonyId
    for jj = 1:2
        outputFile = [outputFilesPath filesep 'outputColony'...
            int2str(ii) '_' int2str(jj) '.mat'];
        load(outputFile, 'matchedCellsfateData', 'allCellStats', 'goodCells', 'umToPixel');
        ncells = size(matchedCellsfateData,1);
        
        % fate data
        brachyury = matchedCellsfateData(:,4)./matchedCellsfateData(:,3);
        cdx2 = matchedCellsfateData(:,5)./matchedCellsfateData(:,3);
        
        % position data(Start:- d1, End:- d2)
        trackedCellsId = matchedCellsfateData(:,1);
        trackedCellsData = allCellStats(trackedCellsId);
        d2 = cellfun(@(x)(x(end,6)), trackedCellsData);
        d2 = d2/umToPixel;
        d2 = 400-d2;
        % distance from the center at the last timePoint
        
        % positions at the last timepoint
        x2 = cellfun(@(x)(x(end,1)), trackedCellsData);
        y2 = cellfun(@(x)(x(end,2)), trackedCellsData);
        
        fatePositionTable(counter:counter+ncells-1, [1:3 5:6]) = [brachyury cdx2 d2' x2' y2'];
        
        d1 = zeros(1,ncells);
        x1 = d1;
        y1 = d1;
        lineageIdsDaughters = cellfun(@(x)(x(1,3)), trackedCellsData);
        for kk = 1:length(trackedCellsId)
            lineageId =  lineageIdsDaughters(kk);
            parentCell = find(goodCells == lineageId); %The ancestor cell has track Id = lineageId.
            % The variable 'goodCells' stores trackIds of all the tracked cells within the colony.
            d1(kk) = allCellStats{parentCell}(1,6);
            
            % positions of the parent cell at the start.
            x1(kk) = allCellStats{parentCell}(1,1);
            y1(kk) = allCellStats{parentCell}(1,2);
        end
        d1 = d1/umToPixel;
        d1 = 400-d1;
        fatePositionTable(counter:counter+ncells-1, [4 7:8]) = [d1' x1' y1'];
        
        counter = counter + ncells;
    end
end

fatePositionTable = fatePositionTable(1:counter-1,:);
