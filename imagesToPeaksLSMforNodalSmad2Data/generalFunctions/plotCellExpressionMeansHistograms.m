function plotCellExpressionMeansHistograms(plate1, shapeNum, columnNum)
%% plots the mean expression levels and cell distribution across the shape numbers specified in shapeNum.

ylimits = [80 1.2];
histogramXlimit = [300 3];

for ch = 1:numel(columnNum)
    columnNorm = 5;
    chLabel = {'NODAL', 'nuclearSMAD2'};
    
    counter = 1;
    smad2mean = zeros(1, numel(shapeNum));
    smad2stdDeviation = smad2mean;
    smad2stdError = smad2mean;
    
    for ii = shapeNum
        coloniesInShape = find([plate1.colonies.shape] == ii);
        if ~isempty(coloniesInShape)
            coloniesData = cat(1, plate1.colonies(coloniesInShape).data);
            if ch  == 2
                smad2mean(counter) = mean(coloniesData(:,columnNum(ch))./coloniesData(:,columnNorm));
                smad2stdDeviation(counter) = std(coloniesData(:,columnNum(ch))./coloniesData(:,columnNorm));
            else
                smad2mean(counter) = mean(coloniesData(:,columnNum(ch)));
                smad2stdDeviation(counter) = std(coloniesData(:,columnNum(ch)));
            end
            smad2stdError(counter) = smad2stdDeviation(counter)/sqrt(size(coloniesData,1));
        end
        
        counter = counter+1;
    end
    
    shapesWithColonies = shapeNum(smad2mean > 0);
    noColonies = find(smad2mean == 0);
    smad2mean(noColonies) = [];
    smad2stdDeviation(noColonies) = [];
    smad2stdError(noColonies) = [];
    
    figure;
    toPlot = {smad2stdDeviation, smad2stdError};
    for ii = 1:2
        subplot(1,2,ii)
        barwitherr(toPlot{ii}, smad2mean);
        ax = gca;
        ax.XTickLabels = strsplit(int2str(shapesWithColonies), ' ');
        xlabel('Shape number');
        ylim([0 ylimits(ch)]);
        title(chLabel{ch});
    end
    %%
    % plot a histogram of the data.
    coloniesInShape = find(ismember([plate1.colonies.shape], shapeNum));
    coloniesData = cat(1, plate1.colonies(coloniesInShape).data);
    if ch == 2
        smad2Intensities = coloniesData(:,columnNum(ch))./coloniesData(:,columnNorm);
    else
        smad2Intensities =  coloniesData(:,columnNum(ch));
    end
    figure;
    histogram(smad2Intensities, 'Normalization', 'Probability');
    title(chLabel{ch});
    xlim([0 histogramXlimit(ch)]);
end
