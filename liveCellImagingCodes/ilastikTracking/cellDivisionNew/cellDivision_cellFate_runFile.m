%% -------- Does the cell division time affect final fate?

[cellIdsTend, cellIdsTstart, colonyIdsCellsTend] =  matchParentCellsWithKidCells(allColoniesCellStats, timeSteps);
%%
cellsToKeep = ismember(colonyIdsCellsTend, colonyIds);
if exist('cellIds', 'var')
    cellsToKeep = ismember(cellIdsTstart, cellIds);
end
cellIdsTend = cellIdsTend(cellsToKeep);
cellIdsTstart = cellIdsTstart(cellsToKeep);
colonyIdsCellsTend = colonyIdsCellsTend(cellsToKeep);

[cellIds_lineage, tof_lineage] =  getCellLineage_cellIds_tof(cellIdsTend);
%%
% extract grand daughters
grandDaughters = find(cellIds_lineage(:,3)>0);

grandDaughters_cellIds_lineage = cellIds_lineage(grandDaughters,1:3);
grandDaughters_tof_lineage = tof_lineage(grandDaughters,1:3);
grandDaughters_cellIds = grandDaughters_cellIds_lineage(:,3);
%%
% get relevant information for matching
grandDaughters_colonyIds = cellfun(@(x)(x(1,3)), allColoniesCellStats([grandDaughters_cellIds]));
grandDaughters_colonyPartIds = cellfun(@(x)(x(1,9)), allColoniesCellStats([grandDaughters_cellIds]));
grandDaughters_trackIds = cellfun(@(x)(x(1,5)), allColoniesCellStats([grandDaughters_cellIds]));

%%
for ii = colonyIds
    for jj = 1:2
        grandDaughters_in = find(grandDaughters_colonyIds == ii & grandDaughters_colonyPartIds == jj);
        grandDaughters_in_tDivision = grandDaughters_tof_lineage(grandDaughters_in,3) - grandDaughters_tof_lineage(grandDaughters_in,2);
        
        outputFile = ['outputColony' int2str(ii) '_' int2str(jj) '.mat'];
        [grandDaughters_in_fate] = matchCellFates(grandDaughters_trackIds, grandDaughters_colonyIds, ...
            grandDaughters_colonyPartIds, ii, jj, outputFile);
        
        grandDaughters_in_fate1 = grandDaughters_in_fate(:,3)./grandDaughters_in_fate(:,2); % brachyury
        grandDaughters_in_fate2 = grandDaughters_in_fate(:,4)./grandDaughters_in_fate(:,2); % cdx2
        toRemove = find(isnan(grandDaughters_in_fate1));
        grandDaughters_in_fate1(toRemove) = [];
        grandDaughters_in_fate2(toRemove) = [];
        grandDaughters_in_tDivision(toRemove) = [];
        %% ------------------- plot
        grandDaughters_in_tDivision = grandDaughters_in_tDivision./6;
        figure(3);
        hold on;
        plot(grandDaughters_in_tDivision, grandDaughters_in_fate1, 'r*');
        if ii == colonyIds(end) && jj == 2
            xlabel('Cell division time (h)');
            ylabel ('Brachyury levels');
            ax = gca; ax.FontSize = 12; ax.FontWeight = 'bold';
        end   
        
        figure(4);
        hold on;
        plot(grandDaughters_in_tDivision, grandDaughters_in_fate2, 'r*');
        if ii == colonyIds(end) && jj == 2
            xlabel('Cell division time (h)');
            ylabel ('cdx2 levels');
            ax = gca; ax.FontSize = 12; ax.FontWeight = 'bold';
        end   
        
        figure(5);hold on;
        scatter(grandDaughters_in_fate1, grandDaughters_in_fate2, 20, grandDaughters_in_tDivision, 'filled');
      
        if ii == colonyIds(end) && jj == 2
            xlabel('brachyury levels (a.u.)');
            ylabel ('cdx2 levels (a.u.');
            ax = gca; ax.FontSize = 12; ax.FontWeight = 'bold';
        end  
        
    end
end

