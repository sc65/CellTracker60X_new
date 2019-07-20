function [regionParentCellIds, ksTestTable] = cellDivisionMetricsAcrossRadialRegions(outputFile, colonyIds, regionBounds)
%% returns a bar plot of cell division distributions across different radial regions
% and a table - ksTestTable, containing results for Kolmogorov-Smirnov
% test
%% ---------------------Inputs--------------------
% 1) outputFile: path to the output file containing combined data for all
% colonies.
% 2) colonyIds: colonies for which the data needs to be evaluated.
% 3) regionBounds: an array containing edges(in um) of the radial bins,
% defined by distance from the edge.
% contains values starting with the lower bound for region 1, and ending in the upper bound for region 2. 
% e.g: regionBounds = [0 20 100 400] => 3 regions, region1: distance from
% edge - [0-20 um] and so on.
%--------------------------------------------------
%% ----------------------Outputs--------------------
% 1) regionParentCellIds: a cell array (4*nRegions) containing cellIds
% corresponding to cells that are present in that regions and have [0, 2,
% 4, 6] daughters. 
% 2) ksTestTable: results for Kolmogorov-Smirnov test, testing the
% hypothesis that cells in different regions divide differently.

%%
load(outputFile);
% get metrics of cells tracked till the end.
[~, cellIdsTstart, colonyIdsCellsTend] =  matchParentCellsWithKidCells(allColoniesCellStats, timeSteps);

cellsToKeep = ismember(colonyIdsCellsTend, colonyIds); %select cells in that colony
cellIdsTstart = cellIdsTstart(cellsToKeep);
colonyIdsCellsTend = colonyIdsCellsTend(cellsToKeep);

[startDistance, ~] = findRadialDisplacement(colonyCenters, allColoniesCellStats, colonyIdsCellsTend, cellIdsTstart);
startDistance = startDistance./umToPixel;
startDistance = 400-startDistance;%Distance of cells from the edge at t0.

% initialize
nRegions = numel(regionBounds)-1;
regionNDaughters = zeros(nRegions, 4); %[columns----nDaughters(0,2,4,6)] [rows--------region1,region2..region n]
regionDistributions = cell(nRegions,1); % actual nDaughter distributions.
regionParentCellIds = cell(4, nRegions); % 4: cell division type, possible divisions:[0 2 4 6]; 

% plot specifics
figure;
if nRegions<5
    nColumns = nRegions;
    nRows = 1;
else
    nColumns = 4;
    nRows = ceil(nRegions/4);
end
    %%
for region = 1:nRegions
    regionBounds1 = (regionBounds(region:region+1));
    
    [uniqueParentCellIds, nKids] = nKidsDistributionInRegion(regionBounds1, allColoniesCellStats, startDistance, cellIdsTstart);
    regionDistributions{region} = nKids;%distribution
    
    [nData, edges] = histcounts(nKids);
    nValues = nData;%frequency
    nDaughters = 0.5*(edges(1:end-1)+edges(2:end));%bin means
    nDaughters(nValues==0) = [];
    nValues(nValues==0) = [];
    %%
    possibleDaughters = [0 2 4 6];
    
    for ii = 1:length(possibleDaughters)
        regionParentCellIds{ii, region} = uniqueParentCellIds(nKids == possibleDaughters(ii));        
    end
    
    frequency = zeros(1,4);
    frequency(ismember(possibleDaughters, nDaughters)) = nValues;
    regionNDaughters(region,:) = frequency;
    sum(frequency)
    %%
    subplot(nRows, nColumns, region);
    bar(possibleDaughters, frequency, 0.5, 'FaceColor', [0.5 0 0], 'EdgeColor', 'k', 'FaceAlpha', 0.6);
    xlabel('No. of daughters');
    ylabel('No. of cells');
    ylim([0 30]);
    title([num2str(regionBounds(region)) ' : ' num2str(regionBounds(region+1)) '\mum']);
    ax = gca; ax.FontSize = 16; ax.FontWeight = 'bold';
end

%% Kolmogorov-Smirnov test
ksTestTable= zeros(nRegions);

for ii = 1:nRegions
    for jj = 1:nRegions
        ksTestTable(ii,jj) = kstest2(regionDistributions{ii}, regionDistributions{jj});
    end
end

