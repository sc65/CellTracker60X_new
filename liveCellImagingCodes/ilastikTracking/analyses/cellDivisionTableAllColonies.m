function cellDivisionTableAllColonies(outputFile)
%% collates information about the division of cells in all colonies.
%------- Input---------
%outputFile = path to the file containing information of all tracked cells in allcolonies.
%----------------------

% cellDivisionTable - a new variable saved in the outputFile.
% An array with columns ------ [parentCellId daughter1_Id daughter2_Id divisionTimeStep...
% AngleBetweenDivisionAxisAndRadius......
% DistanceMovedByDaughterCellsOnDivision(daughter1 daughter2].
%----- Each row has information for a dividing cell.

%----------------------------------------------------------------

load(outputFile);
[~, cellIdsTstart, ~] =  matchParentCellsWithKidCells(allColoniesCellStats);
% returns parent cell ids for all cells tracked till the end.
%%
cellDivisionTable = zeros(length(allColoniesCellStats),7);
counter = 1;
uniqueParentCellIds = unique(cellIdsTstart);
%%
for ii = 1:length(uniqueParentCellIds)
    oneParentCellId = uniqueParentCellIds(ii);
    kidsId = findCellIdsOfKids(allColoniesCellStats, oneParentCellId);
    familyCellIds = [oneParentCellId, kidsId];
    familyTrackIds = cellfun(@(x)(x(1,5)), allColoniesCellStats(familyCellIds));
    
    colonyId = allColoniesCellStats{uniqueParentCellIds(ii)}(1,3);
    divisionsTable = readtable(['/Volumes/SAPNA/170221LiveCellImaging/Tracking Results/Track' int2str(colonyId) 'ch1-exported_data_divisions.csv']);
    divisionsTable = table2array(divisionsTable);
    
    %% match daughters
    for jj = 1:length(familyTrackIds)
        parentCellId = familyCellIds(jj);
        parentCellTrackId = familyTrackIds(jj);
        [divisionTimeStep, daughterTrackIds, ~] = getDivisionInfo(divisionsTable, parentCellTrackId);
        if (daughterTrackIds)
            daughterCellIds = familyCellIds(ismember(familyTrackIds, daughterTrackIds));
            %% add information to the cell division table.
            [theta, d1] = findAngleBetweenColonyRadiusAndCellDivisionAxis(colonyCenters, allColoniesCellStats, parentCellId, daughterCellIds, umToPixel);
            cellDivisionTable(counter,:) = [parentCellId daughterCellIds divisionTimeStep theta d1];
            counter = counter+1;
        end
    end
end

cellDivisionTable(all(cellDivisionTable==0,2),:)=[];
save(outputFile, 'cellDivisionTable', '-append');
end





