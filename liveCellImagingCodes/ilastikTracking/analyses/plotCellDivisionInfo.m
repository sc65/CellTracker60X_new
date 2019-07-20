function plotCellDivisionInfo(allColoniesCellStats, cellIdsTstart,cellLineageTreeIds, startDistanceEdge, timeSteps, separateRegions)
%% get the time of formation(tof) of all the cells
% group the daughter cells with the mother cell

%%
if ~exist ('separateRegions', 'var')
    nRegions = 1;
    cellIdsTstart_region{1} = cellIdsTstart;
    cellLineageTreeIds_region{1} = cellLineageTreeIds;
else
    nRegions = 3;
    regionBound = [0 73.65 183 400];
    for ii = 1:3
        cellIdsTstart_region{ii} = cellIdsTstart(startDistanceEdge>regionBound(ii) & startDistanceEdge<=regionBound(ii+1));
        cellLineageTreeIds_region{ii} = cellLineageTreeIds(startDistanceEdge>regionBound(ii) & startDistanceEdge<=regionBound(ii+1));
        
    end
end

%%
for region = 1:nRegions
    
    cellIdsTstart1 = cellIdsTstart_region{region};
    cellLineageTreeIds1 = cellLineageTreeIds_region{region};
    % For cells tracked till the end, get the time of formation and cell Ids of
    % all cells in family.
    tof_family = zeros(numel(cellIdsTstart1), 4);
    cellIds_family = tof_family;
    
    for ii = 1:numel(cellIdsTstart1)
        tof = cellfun(@(x)(x(1,6)), allColoniesCellStats([cellLineageTreeIds1{ii}])); % to for all cells in family.
        tof_family(ii, 1:numel(tof)) = tof;
        cellIds_family(ii, 1:numel(tof)) = cellLineageTreeIds1{ii};
    end
    %%
    % remove the cells which seem to have three cell divisions
    lastColumn = cellIds_family(:,4);
    toRemove = find(lastColumn>0);
    
    cellIds_family([toRemove],:) = [];
    tof_family([toRemove],:) = [];
    
    %%
    % combine cells that belong to the same family
    motherCellIds = unique(cellIds_family(:,1));
    nProgeny = zeros(numel(motherCellIds),1); % number of progeny
    
    tProgeny = zeros(numel(motherCellIds),4); % time of formation of each progeny
    
    
    nDivisions1 = zeros(timeSteps-1,1); % no. of first cell divisions
    nDivisions2 = nDivisions1; % no. of second cell divisions
    
    counter = 1;
    
    for ii = motherCellIds'
        cellsInFamily = find(cellIds_family(:,1) == ii);
        
        tof_all = tof_family([cellsInFamily], :);
        tof_12 = unique(tof_all);
        
        nProgeny(counter,1) = numel(unique(tof_12));
        tProgeny(counter,1:nProgeny(counter,1)) = unique(tof_12);
        
        counter = counter+1;
        
        tof_1 = unique(tof_all(:,2));
        tof_2 = unique(tof_all(:,3));
        
        tof_1(tof_1 == 0) = [];
        tof_2(tof_2 == 0) = [];
        
        nDivisions1([tof_1], :) = nDivisions1([tof_1],:)+1;
        nDivisions2([tof_2], :) = nDivisions2([tof_2],:)+1;
    end
    nProgeny_region{region} = nProgeny; % for comparing later
    %% ----------------------------------------------------
    %% --------------- 1) No. of cells vs number of progeny
    figure(1); 
    h = histogram(nProgeny, 'BinWidth', 0.5, 'BinEdges', [1:5]);
    
    figure(2); 
    bar([1:4], h.Values, 0.5, 'FaceColor', [0.5 0 0], 'EdgeColor', 'k', 'FaceAlpha', 0.6);
    fProgeny(region,:) = h.Values;
    
    xlabel('No. of progeny');
    ylabel('No. of cells');
    title(['Region' int2str(region)]);
    ylim([0 16]);
    
    ax = gca; ax.FontSize = 18; ax.FontWeight = 'bold';
    ax.XTickLabel = {'0', '2', '3', '4'};
    
    if nRegions == 1
        %% ---------------- 2) No. of cell divisions(first/second) vs time.
        xValues = 20+round([1:timeSteps-1]./6,1);
        % each time step is 10 minutes.
        % imaging was started 20h afterBMP4 addition
        
        figure;
        hold on;
        plot(xValues', nDivisions1,'k.', 'MarkerSize', 15);
        plot(xValues', nDivisions2, 'r*');
        xlabel('Time after BMP4 treatment(h)'); ylabel('No of cell division events');
        legend('First division', 'Second Division')
        ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';
        
        %% ----------------3) Time of first division vs time of second division
        % extract cells that divide twice:
        tDivisions2 = tof_family(cellIds_family(:,3) > 0,2:3);
        tDivisions2 = 20+round(tDivisions2./6,1);
        
        tDivision2_daughter1 = tDivisions2(:,1);
        tDivision2_daughter2 = tDivisions2(:,2);
        
        figure;
        hold on;
        
        % daughter cells formed on first division divide at different times.
        plot(tDivision2_daughter1, tDivision2_daughter2, 'r*');
        
        xlabel('Time of first cell division (h)');
        ylabel('Time of second cell division (h)');
        ax = gca; ax.FontSize = 16; ax.FontWeight = 'bold';
        
        
        %% ---------------- 4) Average division time for second division
        tD21 = tDivision2_daughter2 - tDivision2_daughter1;
        
        mean(tD21)
        
        figure;
        h = histogram(tD21); h.FaceColor = [0.6 0 0];
        xlabel('Cell division time (h)');
        ylabel('No. of cells');
        ax = gca; ax.FontSize = 16; ax.FontWeight = 'bold';
        
        %% ---------------- 5) No. of progeny vs starting position
        
        startPosition = startDistanceEdge; % distance from colony edge
        startPosition(toRemove,:) = [];
        
        [~, pos] = unique(motherCellIds);
        startPosition_motherCells = startPosition(pos,:);
        figure; plot(startPosition_motherCells, nProgeny, 'r*');
        
        xlabel('Distance from the edge at t0');
        ylabel('No. of progeny');
        ax = gca; ax.FontSize = 16; ax.FontWeight = 'bold';
    end
end
%%

if nRegions == 3
    figure; 
    b = bar([1:4], fProgeny',  'FaceAlpha', 0.6);
    
    b(1).FaceColor = [0.6 0 0.6];
    
    b(2).FaceColor = [0 0.6 0];
    b(3).FaceColor = [0 0 1];
    xlabel('No. of progeny');
    ylabel('No. of cells');
   
    ylim([0 16]); legend('Outer region', 'Middle region', 'Inner region');
    ax = gca; ax.FontSize = 18; ax.FontWeight = 'bold';
    ax.XTickLabel = {'0', '2', '3', '4'};
    
end




