function ltCheck = makeLineageDivisionTimeMatrix(outputFilesPath, colonyId, partId)

outputFile = [outputFilesPath filesep 'outputColony'...
    int2str(colonyId) '_' int2str(partId) '.mat'];
load(outputFile, 'matchedCellsfateData', 'allCellStats', 'goodCells', 'umToPixel');

matchedCellsfateData(matchedCellsfateData(:,6)==0,:) = [];
trackedCellsId = matchedCellsfateData(:,1);
trackedCellsData = allCellStats(trackedCellsId);
t1 = cellfun(@(x)(x(1,4)), trackedCellsData);
tEnd = cellfun(@(x)(x(end,5)), trackedCellsData);
allT = [t1' tEnd'];
lineageId = cellfun(@(x)(x(end,3)), trackedCellsData);
ltCheck = [trackedCellsId lineageId', allT];

nCells = size(trackedCellsId,1);
%%
% get the start distance from edge of parent cells
for kk = 1:nCells
    parentCell = find(goodCells == lineageId(kk));
    d0 = allCellStats{parentCell}(end,6);
    d0 = d0/umToPixel;
    ltCheck(kk,5) = 400 - d0; %distance from the edge
end

%%
% select cells that belong to the middle+outer region
ltCheck = ltCheck(ltCheck(:,5)<215,:);