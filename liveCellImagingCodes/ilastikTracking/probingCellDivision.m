%%
% check if division angle makes sense.
allColonyIds = cellfun(@(x)(x(1,3)), allColoniesCellStats);

dividingCellsIds = cellDivisionTable(:,1);
dividingCellsColonyIds = (allColonyIds(dividingCellsIds))';
%%
c1 = 3;
cellsInColony = find(dividingCellsColonyIds==c1);
cellsInColonyIds = dividingCellsIds(cellsInColony); 
cellsInColonyLineageId = cellfun(@(x)(x(1,4)), allColoniesCellStats(cellsInColonyIds));
%%
  i1 = 5;
% plot the line passing through the cell center and colony center. 
  colonyImagePath = ['/Volumes/SAPNA/170221LiveCellImaging/colonyMorphology@tEnd/tend_Track' int2str(c1) 'ch2.tif'];
  figure; imshow(imread(colonyImagePath),[]); title(['Colony' int2str(c1)]);
  
  hold on;
  plot(colonyCenters{c1}(1), colonyCenters{c1}(2), 'r.','MarkerSize', 20);
  
  parentCellPosition = allColoniesCellStats{cellsInColonyIds(i1)}(end,1:2); %position on division
  plot(parentCellPosition(1), parentCellPosition(2), 'b.', 'MarkerSize', 20);
  xValues = [colonyCenters{c1}(1) parentCellPosition(1)];
  yValues = [colonyCenters{c1}(2) parentCellPosition(2)];
  plot(xValues, yValues, 'k-', 'LineWidth',2);
  
  daughterCellIds = cellDivisionTable(cellsInColony(i1), 2:3);
  daughterCell_1_position = allColoniesCellStats{daughterCellIds(1)}(1,1:2); %position on division
  daughterCell_2_position = allColoniesCellStats{daughterCellIds(2)}(1,1:2);
  plot(daughterCell_1_position(1), daughterCell_1_position(2), 'g.', 'MarkerSize', 15);
  plot(daughterCell_2_position(1), daughterCell_2_position(2), 'g.', 'MarkerSize', 15);
  
  xValues = [daughterCell_1_position(1), daughterCell_2_position(1)];
  yValues = [daughterCell_1_position(2), daughterCell_2_position(2)];
  plot(xValues, yValues, 'k-', 'LineWidth', 4);
  
  