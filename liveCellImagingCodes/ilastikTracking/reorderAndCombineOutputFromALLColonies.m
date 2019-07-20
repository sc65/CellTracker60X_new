function reorderAndCombineOutputFromALLColonies(outputFilesPath)
%% makes a new cell array - allColoniesCellStats, with each cell representing a "cell".
% -- columns of the cell - [xPosition yPosition colonyId lineageId trackId tStart tEnd DistanceFromCenter colonyPartId(1/2)]
% -- each row represents data for a particular time Point, starting from
% tStart to tEnd.
%%-----------------------------------------------------------------
colonyNum = 10; %total number of colonies to analyse.
colonyCellStats = cell(1,colonyNum);
colonyCenters = colonyCellStats;

for ii = 2:colonyNum %colony1 was not tracked
    newCellStats = cell(1,2); %to store cell data for both colony parts.
    
    for jj = 1:2
        outputFile = [outputFilesPath filesep 'outputColony' int2str(ii) '_' int2str(jj) '.mat'];
        load(outputFile);
        
        if jj == 1
            colonyCenters{ii} = colonyCenter; %the output file
        end
        
        cellStats = allCellStats; %do not fiddle with the original variable.
        
        
        for kk = 1:length(cellStats)
            data = cellStats{kk};
            
            %adding  colony Id and trackId
            colonyId = repmat(ii, size(data,1),1);
            colonyPartId = repmat(jj, size(data,1),1);
            trackId = repmat(goodCells(kk), size(data,1), 1);
            
            newOrderCellStats =  [data(:,1:2) colonyId data(:,3) trackId data(:,4:6) colonyPartId];
            newCellStats{jj}{kk} = newOrderCellStats;
        end
    end
    newCellStats = cat(2, newCellStats{1}, newCellStats{2});
    colonyCellStats{ii} = newCellStats;
    
end

%% combine information from all colonies in a single cell array.
allColoniesCellStats = cat(2, colonyCellStats{2},colonyCellStats{3},...
    colonyCellStats{4}, colonyCellStats{5}, colonyCellStats{6},...
    colonyCellStats{7}, colonyCellStats{8}, colonyCellStats{9}, colonyCellStats{10});

save([outputFilesPath filesep 'outputAll.mat'], 'allColoniesCellStats', 'colonyCenters', 'umToPixel');




