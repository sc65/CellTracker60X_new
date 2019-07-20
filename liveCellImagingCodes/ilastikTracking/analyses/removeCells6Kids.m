%%

[cellIdsTend, cellIdsTstart, colonyIdsCellsTend] =  matchParentCellsWithKidCells(allColoniesCellStats, timeSteps);
%returns the parent cell Ids for all cells tracked till end.
%%
cellsToKeep = ismember(colonyIdsCellsTend, colonyIds);
cellIdsTend = cellIdsTend(cellsToKeep);
cellIdsTstart = cellIdsTstart(cellsToKeep);
colonyIdsCellsTend = colonyIdsCellsTend(cellsToKeep);
% get the kid Ids of all cells tracked till the end.
%%
uniqueParentCellIds = unique(cellIdsTstart);
%%
% find the distance moved by all the kids of cell with cellId ii
nCells = length(uniqueParentCellIds);
nKids = zeros(1, nCells);

counter = 1;
for ii = uniqueParentCellIds
    kidsId = findCellIdsOfKids(allColoniesCellStats, ii); %find all daughter cells of that parent cell.
    nKids(counter) = length(kidsId);
    counter = counter+1;
end
%%
figure; histogram(nKids);
%%
% remove cells with > 6 kids - 3 divisions did not occur. 
toRemove = find(nKids>6);
toRemoveParentIds = uniqueParentCellIds(toRemove);

toRemoveKidsIds = zeros(1,100); % initialize
counter = 1;
for ii  = toRemoveParentIds
    kidsId = findCellIdsOfKids(allColoniesCellStats, ii);
    toRemoveKidsIds(counter:counter+length(kidsId)-1) = kidsId;
    counter = counter+length(kidsId);
end
%%
toRemoveKidsIds = toRemoveKidsIds(1:counter-1);
%%
toRemoveIds = union(toRemoveParentIds, toRemoveKidsIds);
%%
allColoniesCellStats(toRemoveIds) = [];
%%
h = histogram(nKids);

divisions = h.Values;
divisions(divisions==0) = [];

figure;
bar(0:3, divisions, 0.5, 'FaceColor', [0.5 0 0], 'EdgeColor', 'k', 'FaceAlpha', 0.6);
xlabel('No. of divisions');
ylabel('No. of cells');
ax = gca; ax.FontSize = 16; ax.FontWeight = 'bold';

ax.XTickLabel = {'No division', '1 Division', 'one daughter divides', 'both daughters divide'};

%%
% save the coordinates of the daughter cells in a matrix
x1 = zeros(timeSteps,1);
y1 = x1;

ii = uniqueParentCellIds(65);
kidsId = findCellIdsOfKids(allColoniesCellStats, ii); %f

if ~isempty(kidsId)
    
    
    if length(nKids)==2
        counter1 = 1;
        for jj = kidsId
            if allCellStats{jj}(1,7) == timeSteps-1
                x1 = zeros(timeSteps,1); y1 = x1;
                
                startTime = allCellStats{jj}(1,6);
                x1(startTime+1:timeSteps,counter1) = allCellStats{jj}(:,1);
                y1(startTime+1:timeSteps, counter1) = allCellStats{jj}(:,1);
                
                x1(1:startTime, counter1) = allCellstats{ii}(:,1);
                y1(1:startTime, counter1) = allCellstats{ii}(:,2);
                
                counter1 = counter1+1;
            end
        end
        
    end
    % if nKids == 2, check if the kid is tracked till the end
    % if nKids == 4, one daughter cell divided once, other didn't - so
    % three cells in total - form the lineage tree, get the position list
    % of those three cells.
    % if nKids == 6, both daughters divided, so 4 cells in total - first
    % form the lineage tree, get the position list of those 4 cells
    
        
else
    x1(:,1) = (allColoniesCellStats{ii}(:,1));
    y1(:,1) = (allColoniesCellStats{ii}(:,2));
    
    points1 = [x1(1:164,1), y1(1:164,1)];
    points2 = [x1(2:165,1), y1(2:165,1)];
    
    distance = sum(sqrt((points1(:,1)-points2(:,1)).^2 + (points1(:,2) - points2(:,2)).^2));
    distance = distance./umToPixel;
end

