%%
% Analyzing 500um colonies
% cell distribution
% scatter plot for nuclear T, bCat, Nodal

clearvars;
outputFile = '/Volumes/SAPNA/170703_FISH_nodal_IF_t_bCat/25_29_33_37_47h/20X_LSM/rawData/37h/t37_500_q2_q4/outputFiles/output_2.mat';
%%
load(outputFile);
%%
shapeNum = 1;

coloniesInShape = find([plate1.colonies.shape] == shapeNum);
nCells = [plate1.colonies(coloniesInShape).ncells];
figure; histogram(nCells, 'BinWidth', 150);
%%
normalizeByDapi = 1;
caxis1 = [1500 1400 1000];
caxis2 = [3 8 1.5];

chCounter = 1;


for ii = [6 8 10]
    figure;
    colonyCounter = 1;
    for jj = coloniesInShape
        subplot(5,5,colonyCounter);
        
        xy = plate1.colonies(jj).data(:,1:2);
        xy = xy-mean(xy);
        
        if ii < 12
            channelData = plate1.colonies(jj).data(:,ii);
        else
            channelData = plate1.colonies(jj).data(:,ii) + plate1.colonies(jj).data(:,ii+1);
        end
        
        if normalizeByDapi == 1
            nChannelData = channelData./plate1.colonies(jj).data(:,5) ;
        else
            nChannelData = channelData;
        end
        
        scatter(xy(:,1), xy(:,2), 20, nChannelData, 'filled');
        title(['Colony' int2str(jj)]);
        colorbar;
        
        if normalizeByDapi == 1
            caxis([0 caxis2(chCounter)]);
        else
            caxis([0 caxis1(chCounter)]);
        end
        
        colonyCounter = colonyCounter+1;
    end
    
    chCounter = chCounter+1;
end
%%
oldOutputFilesPath = {'/Volumes/SAPNA/170703_FISH_nodal_IF_t_bCat/25_29_33_37_47h/20X_LSM/rawData/37h/t37_500_q2_q4/outputFiles'};

newOutputFile = '/Volumes/SAPNA/170703_FISH_nodal_IF_t_bCat/25_29_33_37_47h/20X_LSM/rawData/masterOutputFiles/500um/output_37h';
makeMasterOutputFile(oldOutputFilesPath, newOutputFile);

















