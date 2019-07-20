function removeFalsePositives(allCellStats, goodCells, outputFile, falseObjectIds)
%% after comparing with the fate image, remove the tracked dead cells, if you missed any earlier

allCellStats{falseObjectIds} = [];
allCellStats = allCellStats(~cellfun('isempty',allCellStats)); 
goodCells(falseObjectIds) = [];

save(outputFile, 'allCellStats', 'goodCells', '-append');
end