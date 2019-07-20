function [testMatrix, pMatrix] = compareRegionsInOneDataSet(outputFile, colonyIds, regionBounds)
%% compares kidsDistribution, distance, displacement, radialDisplacement within regions: outer, middle, inner in a given dataset.
% returns ksTest results in a cell array: 
% testMatrix, each row represents one variable (e.g. distance), each column represents ksTest results for that variable represented in the 
% form of a nREgion*nRegion matrix with test values for region i, region j.
% returns pValues in a cell array: contains p values instead of test
% results 
%%
nRegions = numel(regionBounds)-1;

%% initialize
kidsDistribution = cell(1,nRegions);
distance = kidsDistribution;
displacement = distance;
radialDisplacement = distance;
angularDisplacement = distance;



%%
load(outputFile);

[~, cellIdsTstart, colonyIdsCellsTend] =  matchParentCellsWithKidCells(allColoniesCellStats, timeSteps);

cellsToKeep = ismember(colonyIdsCellsTend, colonyIds); %select cells in that colony
cellIdsTstart = cellIdsTstart(cellsToKeep);
colonyIdsCellsTend = colonyIdsCellsTend(cellsToKeep);

[startDistance, ~] = findRadialDisplacement(colonyCenters, allColoniesCellStats, colonyIdsCellsTend, cellIdsTstart);
startDistance = startDistance./umToPixel;
startDistance = 400-startDistance;%Distance of cells from the edge at t0.


for jj = 1:nRegions
    cellsInRegion = find(startDistance > regionBounds(jj) & startDistance < regionBounds(jj+1));
    cellsInRegionIds = cellIdsTstart(cellsInRegion);
    
    [~, kidsDistribution{jj}] = nKidsDistributionInRegion(regionBounds(jj:jj+1), allColoniesCellStats, startDistance, cellIdsTstart);
    [distance{jj}, displacement{jj}, radialDisplacement{jj}, angularDisplacement{jj}] = makeDisplacementHistograms(outputFile, colonyIds, 5, cellsInRegionIds);
end

toTest = {kidsDistribution, distance, displacement, radialDisplacement, angularDisplacement};
testMatrix = cell(1, size(toTest,2));
pMatrix = testMatrix;
%% check if the difference are significant using kstest2.

for tt = 1:numel(toTest)
    for kk = 1:nRegions
        for ll = 1:nRegions
            [testMatrix{tt}(kk,ll), pMatrix{tt}(kk,ll)] = kstest2(toTest{tt}{kk}, toTest{tt}{ll});
        end
    end
end

end

