function fateData = getFateDataForCellIdsAllColoniesCellStats(allColoniesCellStats, fateOutputFilePath, cellIds)
%% returns fate data of cells with a given cell Id, corresponding to their position in the array allColoniesCellStats

fateData = zeros(1000, 10);
counter = 1;

for ii = cellIds
    colonyId = allColoniesCellStats{ii}(1,3);
    colonyPartId  = allColoniesCellStats{ii}(1,9);
    lineageId1 = allColoniesCellStats{ii}(1,5); %from all colonies cell stats.
    
    
    outputFile1 = [fateOutputFilePath filesep 'outputColony'...
        int2str(colonyId) '_' int2str(colonyPartId) '.mat'];
    load(outputFile1, 'allCellStats', 'matchedCellsfateData');
    matchedCellsfateData(matchedCellsfateData(:,6)==0,:) = []; %removes the wrongly fate assigned cells. 
    
    %%
    trackIds2 = matchedCellsfateData(:,1); % from individual colonies all cell stats.
    trackedCellsData = allCellStats(trackIds2);
    lineageId = cellfun(@(x)(x(end,3)), trackedCellsData);
    tStart = cellfun(@(x)(x(end,4)), trackedCellsData);
    tEnd = cellfun(@(x)(x(end,5)), trackedCellsData);
    pos = lineageId == lineageId1;
    %%
    daughterCellsTrackId = trackIds2(pos);
    data1 = matchedCellsfateData(ismember(matchedCellsfateData(:,1), daughterCellsTrackId),1:5);
    t1 = tStart(pos);
    t2 = tEnd(pos);
    
    nDaughters = size(data1,1);
    if nDaughters>0
        fateData(counter:counter+nDaughters-1,:) = [repmat(ii, [nDaughters,1]), data1, ...
            repmat(colonyId, [nDaughters,1]), repmat(colonyPartId, [nDaughters,1]), t1', t2'];
        counter = counter+nDaughters;
    end
end

fateData(all(fateData==0,2),:) = [];


