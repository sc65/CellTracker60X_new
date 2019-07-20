function makeAllStats(resultTable, divisionsTable, centerX, centerY, goodCells,  outputFilePath, colonyMask)
%% making allCellStats - a cell array, each cell corresponding to one "cell(object)"
% each cell contains a table with [x y lineageId startTimeStep endTimeStep]

%-------Inputs-----------
%--- resultTable: tracking table exported from ilastik
%--- divisionsTable: divisions table exported from ilastik
%--- goodCells: lineage Ids of non-dying cells
%--- outputFilePath: full path of the outputFile ('/../../output.mat')

% synthesising position coordinates

allCellStats = cell(1,60);
counter = 1;

if exist('colonyMask', 'var')
    alldists = bwdist(~colonyMask); %distance transform of the complement.
end

trackId = goodCells(counter);

while counter <= length(goodCells)
    
    [divisionTime, childrenId, ~] = getDivisionInfo(divisionsTable, trackId);
    if (divisionTime)
        data1 = resultTable(resultTable(:,2) < divisionTime+1,:);
    else
        data1 = resultTable;
    end
    data2 = data1(data1(:,5) == trackId,:);
    positions = data2(:,[centerX centerY]);
    lineageId = data2(:,4);
    tStart = data2(1,2);
    tEnd = data2(end,2);
    
    
    allCellStats{counter}(:,1:2) = positions;
    allCellStats{counter}(:,3) = lineageId;
    allCellStats{counter}(:,4) = tStart;
    allCellStats{counter}(:,5) = tEnd;
    
    if exist('colonyMask', 'var')
        distanceFromEdge = alldists(sub2ind(size(colonyMask),floor(positions(1,2)), floor(positions(1,1))));
        allCellStats{counter}(:,6) = distanceFromEdge;
    end
    
    counter = counter+1;
    
    if counter > length(goodCells) && (~childrenId(1))
        break;
    end
    
    if (childrenId)
        goodCellsNew = [goodCells(1:counter-1) childrenId goodCells(counter:end)];
        goodCells = goodCellsNew;
    end
    trackId = goodCells(counter);
    
end

allCellStats = allCellStats(~cellfun('isempty', allCellStats)); %removes empty cells.
save(outputFilePath, 'goodCells', 'allCellStats', '-append');








