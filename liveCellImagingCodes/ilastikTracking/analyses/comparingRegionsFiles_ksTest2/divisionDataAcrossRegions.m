
%%
% outputFile = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/outputAll.mat';
% colonyIds = [2 4:6];
% regionBounds = [0 77.2 194.73 400];% different density domains.

outputFile = '/Volumes/SAPNA/170221LiveCellImaging/outputFiles/outputAll.mat';
colonyIds = 1:6;
regionBounds = [0 54 160 400];
%regionBounds = [0:90:400];
[regionParentCellIds, ksTestTable] = cellDivisionMetricsAcrossRadialRegions(outputFile, colonyIds, regionBounds);
ksTestTable
%% Do the cells that divide differently move differently?
region = 1;
distance = cell(1,3);
displacement = distance;
radialDisplacement = displacement;
angularDisplacement = displacement;
plotnum = 5;
for ii = 2:4
    cellIds = regionParentCellIds{ii,region};
    [distance{ii-1}, displacement{ii-1}, radialDisplacement{ii-1}, angularDisplacement{ii-1}] = makeDisplacementHistograms(outputFile, colonyIds, plotnum, cellIds);
end

%%
ksTestTable1= zeros(3);
ksTestTable2 = ksTestTable1;
ksTestTable3 = ksTestTable2;
ksTestTable4 = ksTestTable2;

for ii = 1:3
    for jj = 1:3
        ksTestTable1(ii,jj) = kstest2(distance{ii}, distance{jj});
        ksTestTable2(ii,jj) = kstest2(displacement{ii}, displacement{jj});
        ksTestTable3(ii,jj) = kstest2(radialDisplacement{ii}, radialDisplacement{jj});
        ksTestTable4(ii,jj) = kstest2(radialDisplacement{ii}, radialDisplacement{jj});
    end
end

ksTestTable1
ksTestTable2
ksTestTable3
%%
figure;
hold on;
colors = {'b', 'r'};
counter = 1;

for ii = [2 3]
    plot(1:numel(distance{ii}), distance{ii}, '.', 'Color', colors{counter}, 'MarkerSize', 15);
    counter = counter+1;
end
legend('1 Division', '2 Divisions');
ylabel('Distance moved (\mum)');
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';

%%  Do the cells that divide differently differentiate to different fates?
load(outputFile, 'allColoniesCellStats')
allFateData = cell(1,3);
region = 1;

for ii = 2:4 %divisionType
    cellIds = regionParentCellIds{ii, region};
    fateOutputFilePath = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles';
    allFateData{ii-1} = getFateDataForCellIdsAllColoniesCellStats(allColoniesCellStats, fateOutputFilePath, cellIds);
end
%%
for ii = 1:3
    for jj = 1:3
        cdx2_1 = allFateData{ii}(:,6)./allFateData{ii}(:,3);
        cdx2_2 = allFateData{jj}(:,6)./allFateData{jj}(:,3);
        [ksTestTable4(ii,jj), p1(ii, jj)] = kstest2(cdx2_1, cdx2_2);
        
        t_1 = allFateData{ii}(:,5)./allFateData{ii}(:,3);
        t_2 = allFateData{jj}(:,5)./allFateData{jj}(:,3);
        [ksTestTable5(ii,jj), p2(ii,jj)] = kstest2(t_1, t_2);
    end
end
%%
ksTestTable4
ksTestTable5
%%
cdx2_1 = allFateData{1}(:,6)./allFateData{1}(:,4);
cdx2_2 = allFateData{3}(:,6)./allFateData{3}(:,4);
%%
figure; hold on;
colors = {'b', 'r'};
plot(1:numel(cdx2_1), cdx2_1, '.', 'Color', colors{1}, 'MarkerSize', 15);
plot(1:numel(cdx2_2), cdx2_2, '.', 'Color', colors{2}, 'MarkerSIze', 15);
ylabel('CDX2/DAPI');
legend('1 Division', '2 Division');
ax = gca; ax.FontSize = 12;
ax.FontWeight = 'bold';
%%
figure; histogram(cdx2_1, 'BinWidth', 0.3);
xlim([0.2 3]);
figure; histogram(cdx2_2, 'BinWidth', 0.3);
xlim([0.2 3]);
















