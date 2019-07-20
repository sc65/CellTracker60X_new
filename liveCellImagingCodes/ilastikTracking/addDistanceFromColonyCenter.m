function addDistanceFromColonyCenter (outputFilePath, trackIds)
%% add a new column to allCellStats that contains the distance of cells from the center of the colony

for ii = trackIds
    for jj = 1:2
        outputFile = [outputFilePath filesep 'outputColony' int2str(ii) '_' int2str(jj) '.mat'];
        if jj == 1
            load(outputFile, 'allCellStats', 'colonyCenter');
        else
            load(outputFile, 'allCellStats');
        end
        
        nCells = length(allCellStats);
        allXY = zeros(nCells, 2);
        
        allXY(:,1) = (cellfun(@(x)(x(1,1)), allCellStats))'; % X coordinate at t0.
        allXY(:,2) = (cellfun(@(x)(x(1,2)), allCellStats))'; % Y coordinate at t0.
        
        allDists = sqrt((allXY(:,1)-colonyCenter(1)).^2 + (allXY(:,2) - colonyCenter(2)).^2);
        
        newColumn = size(allCellStats{1},2) + 1;
        
        
        for kk = 1:nCells
            allCellStats{kk}(:,newColumn) = allDists(kk,1);
        end
        
        save(outputFile, 'allCellStats', '-append');
    end
end
