%%
% classify all colonies in the output files.
% Start with t0 and t42.
parentDirectory = {'.'};
for ii = 1:length(parentDirectory)
    matfiles = dir([parentDirectory{ii} filesep '*.mat']);
    for jj = 1:numel(matfiles)
        outputfile = [parentDirectory{ii} filesep matfiles(jj).name];
        manualClassifierGoodColonies(outputfile);
    end
end
%
%%
%remove cells not in colonies.
outputfiles = {'output_1.mat', 'output_2.mat'};

ii = 2;
outputfile = outputfiles{ii};
load(outputfile, 'plate1', 'goodColonies');
figure;
plotnum = 1;
for jj = goodColonies
    subplot(6,6, plotnum);
    plotnum = plotnum+1;
    plot(plate1.colonies(jj).data(:,1), plate1.colonies(jj).data(:,2), 'k.');
    title(['Colony' int2str(jj)]);
end
%%
colonyId = 109;
plate1 = removeCellsNotInColony(outputfile, plate1, colonyId);
%%
% check fluorescence range for both channels.
% set a threshold to remove outliers.
% remove the obvious outliers.
columnNum = 6; %[6 7] = [Nodal, SMAD2]
columnNorm = 5;
shapeNum = [1:18];
plotHistogramOfExpressionLevelsAllColonies (plate1, shapeNum, columnNum)
%%
threshold = 300;
removeCellsAboveFluorescence(outputfile, plate1, goodColonies, columnNum, threshold)
%%
% I have <5 colonies for every shape.
% Make scatter plots for each.
shapenum = [1];
columnNum = 6;
figure;
load(outputfile, 'plate1', 'goodColonies');
plotnum = 1;

for jj = goodColonies
    data = plate1.colonies(jj).data;
    subplot(5,4, plotnum);
    scatter(data(:,1), -data(:,2), 20, data(:,columnNum), 'filled');
    colorbar;
    caxis([0 150]);
    plotnum = plotnum+1;
    title(['Colony' int2str(jj)]);
end

