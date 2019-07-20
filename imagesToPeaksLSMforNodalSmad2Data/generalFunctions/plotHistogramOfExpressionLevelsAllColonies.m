function plotHistogramOfExpressionLevelsAllColonies (plate1, shapeNum, columnNum, binSize)
%% histograms of fluorescence levels, corresponding to data in columnNum in shapes corresponding to shapeNum.
%  columnNorm - data in this column is used to normalise data in columnNum.
%  the function returns a separate figure for every shape.
%  binsize - histogram binwidth

if ~exist('binSize', 'var')
    binSize = 100;
end
    
for ii = shapeNum
    clear data2;
    figure;
    
    counter = 1;
    coloniestouse = find([plate1.colonies.shape] == shapeNum);
    
    if ~isempty(coloniestouse)
        %figure;
        for jj = coloniestouse
            clear alldata datatouse;
            colonydata = plate1.colonies(jj).data;
            if columnNum>5
                data1 = colonydata(:,columnNum) + colonydata(:,columnNum+1);
            else
                data1 = colonydata(:,columnNum);
            end
            if(counter == 1)
                data2 = data1;
            else
                data2 = [data2;data1];
            end
            counter = counter+1;
        end
        
        histogram(data2, 'BinWidth', binSize, 'Normalization', 'Probability');
        title(sprintf('shape%01d column%01d', ii, columnNum));
    end
end


