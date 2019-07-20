function [testMatrix, pMatrix] = compareRegionsAcrossTwoDataSets(outputFiles, coloniesToUse, regionBounds)
%% compares kidsDistribution, distance, displacement, radialDisplacement within regions: outer, middle, inner in a given dataset.
% returns ksTest results in a cell array:
% testMatrix, each row represents one variable (e.g. distance), each column represents ksTest results for that variable represented in the
% form of a nRegion*nRegion matrix with test values for region i, region j.
% returns pValues in a cell array: contains p values instead of test
% results
%%
nRegions = numel(regionBounds{1})-1;
kidsDistribution = cell(2,nRegions);
distance = kidsDistribution;
displacement = distance;
radialDisplacement = distance;
angularDisplacement = distance;

%%
for ii = 1:2
    outputFile = outputFiles{ii};
    load(outputFiles{ii});
    colonyIds = coloniesToUse{ii};
    %%
    [~, cellIdsTstart, colonyIdsCellsTend] =  matchParentCellsWithKidCells(allColoniesCellStats, timeSteps);
    
    cellsToKeep = ismember(colonyIdsCellsTend, colonyIds); %select cells in that colony
    cellIdsTstart = cellIdsTstart(cellsToKeep);
    colonyIdsCellsTend = colonyIdsCellsTend(cellsToKeep);
    
    [startDistance, ~] = findRadialDisplacement(colonyCenters, allColoniesCellStats, colonyIdsCellsTend, cellIdsTstart);
    startDistance = startDistance./umToPixel;
    startDistance = 400-startDistance;%Distance of cells from the edge at t0.
    
    for jj = 1:nRegions
        cellsInRegion = find(startDistance > regionBounds{ii}(jj) & startDistance < regionBounds{ii}(jj+1));
        cellsInRegionIds = cellIdsTstart(cellsInRegion);
        %%
        [~, kidsDistribution{ii, jj}] = nKidsDistributionInRegion(regionBounds{ii}(jj:jj+1), allColoniesCellStats, startDistance, cellIdsTstart);
        %%
        [distance{ii,jj}, displacement{ii, jj}, radialDisplacement{ii, jj}, angularDisplacement{ii,jj}] = makeDisplacementHistograms(outputFile, colonyIds, 1, cellsInRegionIds);
        % get the data per unit time.
        distance{ii,jj} = distance{ii,jj}./timeSteps;
        displacement{ii, jj} = displacement{ii,jj}./timeSteps;
        radialDisplacement{ii, jj} = radialDisplacement{ii,jj}./timeSteps;
        angularDisplacement{ii,jj} = radialDisplacement{ii,jj}./timeSteps;
    end
end
%%
toTest = {kidsDistribution, distance, displacement, radialDisplacement, angularDisplacement};
testMatrix = cell(1, size(toTest,2));
pMatrix = testMatrix;

%% check if the differences between regions across the two datasets are significant using kstest2.
for tt = 1:numel(toTest)
    for kk = 1:nRegions
        test1 = toTest{tt};
        [testMatrix{tt}(1,kk), pMatrix{tt}(1,kk)] = kstest2(test1{1, kk}, test1{2, kk});
    end
end

end