function barPlotColonyStats(outputFile)
%% a bar plot containing information about number of cells at start, and number of cell divisions.

load (outputFile);

startTime = cellfun(@(x)(x(1,4)), allCellStats);
nCellsT0= numel(find(startTime==0));

lineageIds = cellfun(@(x)(x(1,3)), allCellStats);
lineageIds = unique(lineageIds);
nDivision = zeros(numel(lineageIds),1); % number of times a particular cell divides

[~, idx, ~] = intersect(goodCells, lineageIds);
nDivision(1:numel(idx)-1,1) = (diff(idx)-1)/2;
nDivision(nDivision == 3) = 2;
nDivision(numel(lineageIds),1) = numel(goodCells) - idx(end);

zeroDivision = numel(find(nDivision == 0));
oneDivision = numel(find(nDivision == 1));
twoDivisions = numel(find(nDivision == 2));

variables = [nCellsT0 zeroDivision oneDivision twoDivisions];
figure; bar(1:4, variables, 0.5);
ylabel('Frequency');
title('Colony Stats');
ax = gca;
ax.XTickLabel = {'Cells @ t0', 'No Division', '1 Division', '2 Divisions'};
ax.FontSize = 12;
ax.FontWeight = 'bold';



