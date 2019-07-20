function plotHistogramOfExpressionLevelsGivenColonies (plate1, coloniesToUse, columnNum, normColumnNum, binSize)
%% histograms of fluorescence levels, corresponding to data in columnNum in shapes corresponding to shapeNum.
%  normColumnNum - data in this column is used to normalise data in
%  columnNum. Set to 0 if not normalizing.
%  the function returns a separate figure for every shape.
%  binsize - histogram binwidth

if ~exist('binSize', 'var')
    binSize = 100;
end

counter = 1;
%figure;
for jj = coloniesToUse
    clear alldata datatouse;

    if iscell(plate1)
        colonyData = plate1{jj};
    else
        colonyData = plate1.colonies(jj).data;
    end
    
    if columnNum>12
        data1 = colonyData(:,columnNum) + colonyData(:,columnNum+1);
    else
        data1 = colonyData(:,columnNum);
    end
    
    if normColumnNum
        data1 = data1./colonyData(:,normColumnNum);
    end
    
    if(counter == 1)
        data2 = data1;
    else
        data2 = [data2;data1];
    end
    counter = counter+1;
end


histogram(data2, 'BinWidth', binSize, 'Normalization', 'Probability', 'DisplayStyle', 'stairs', ...
    'LineWidth', 2);
title(['Channel' int2str(columnNum)]);
%title(sprintf('Colony%01d column%01d', jj, columnNum));
end



