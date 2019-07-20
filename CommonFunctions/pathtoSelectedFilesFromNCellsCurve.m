
%% find the path to the colonies in the first 50 percentile in 29h and 33h colonies.
% Do the fluorescence values of Nodal look comparable?
path = cell(1,2);
for ii = [2 3]
    cIn = coloniesOnCurve{1,ii};
    p1 = strfind(shape2_colallSamplesDataonyPath{ii}(cIn), 'output_');
    path{ii-1} = shape2_colonyPath{ii}(p1:end);
end
%% expression histograms
columnNum = 5;
binSize = 0.25; normColumnNum = 0;
for ii = [1:4]
    figure; counter = 1;
    load(outputFiles{ii});
    coloniesToUse = coloniesOnCurve{1,ii};
    for jj = coloniesToUse
        subplot(3,4,counter);
        channelData = plate1.colonies(jj).data(:,columnNum);
        channelData = channelData./mean(channelData);
        plate1.colonies(jj).data(:,columnNum) = channelData;
        
        plotHistogramOfExpressionLevelsGivenColonies (plate1, jj, columnNum, normColumnNum, binSize);
        xlim([0 4]); ylim([0 0.5]);
        title(int2str(jj));
        counter = counter+1;
    end
end

%% expression histogram - all colonies combined
binSize = 100; columnNum = 6; normColumnNum = 5;
figure; hold on;
for ii = [1 4]
    counter = 1;
    load(outputFiles{ii});
    coloniesToUse = coloniesOnCurve{1,ii};
    
    for jj = coloniesToUse
        channelData = plate1.colonies(jj).data(:,normColumnNum);
        channelData = channelData./mean(channelData);
        plate1.colonies(jj).data(:,normColumnNum) = channelData;
    end
    
    plotHistogramOfExpressionLevelsGivenColonies(plate1, coloniesToUse, columnNum, normColumnNum, binSize);
    xlim([0 3000]); ylim([0 0.6]);
    title(int2str(jj));
    counter = counter+1;
    ax = gca;
    ylim([0 0.45]);
    xlim([0 3000]);
    ax.FontSize = 12;
    ax.FontWeight = 'bold';
    
    legend('25h', '37h');
    
end
%% scatter plots
columnNum = 6;
normColumnNum = 5;

for ii = [1 4]
    load(outputFiles{ii});
    figure;
    counter = 1;
    coloniesToUse = coloniesOnCurve{1,ii};
    for jj = coloniesToUse
        subplot(3,4,counter);
        data = plate1.colonies(jj).data;
        normData = plate1.colonies(jj).data(:,normColumnNum);
        normData = normData./mean(normData);
        
        data(:,1:2) = data(:,1:2) - mean(data(:,1:2));
        scatter(data(:,1), data(:,2), 20, data(:,6), 'filled');
        colorbar; caxis([0 700]);
        counter = counter+1;
        title([int2str(jj)]);
    end
    
end
%% scatter plots - all colonies combined
columnNum = 6;
normColumnNum = 5;


for ii = [3]
    load(outputFiles{ii});
    
    data1 = zeros(5000,2);
    channelData1 = data1(:,1);
    
    figure;
    counter = 1;
    coloniesToUse = coloniesOnCurve{1,ii};
    
    for jj = coloniesToUse

        data = plate1.colonies(jj).data;
        data(:, 1:2) = data(:, 1:2) - mean(data(:,1:2));
        
        normData = plate1.colonies(jj).data(:,normColumnNum);
        normData = normData./mean(normData);
        
        channelData =  plate1.colonies(jj).data(:,columnNum)./normData;
        
        if jj == coloniesToUse(1)
            data1 = data(:,1:2);
            channelData1 = channelData;
        else
            data1 = [data1; data(:,1:2)];
            channelData1 = [channelData1; channelData];
        end
        
        
    end
    scatter(data1(:,1), data1(:,2), 20, channelData1, 'filled');
    colorbar; caxis([0 600]);
    counter = counter+1;
    title([int2str(ii)]);
end

%% path to
clear coloniestoUse;
ii = 4;
load(outputFiles{ii});
coloniesToUse = coloniesOnCurve{1,ii};
for jj = 1:numel(coloniesToUse)
    p1 = strfind(colonyPath{coloniesToUse(jj)}, '37h');
    p2 = colonyPath{coloniesToUse(jj)}(p1:end)
end

%%



