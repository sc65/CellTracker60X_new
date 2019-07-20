%%
% scatter plots - T vs Sox2, color coded by Nanog.

%% All the colonies combined, what does T, bCat and Nodal expression look like?
clearvars;
outputFile = '/Volumes/SAPNA/170703_FISH_nodal_IF_t_bCat/25_29_33_37_47h/20X_LSM/rawData/masterOutputFiles/500um/output_37h.mat';
load(outputFile);
%%
coloniesInShape = find([plate1.colonies.shape] == 3);
%%
figure;
counter = 1;

for ii = coloniesInShape % individual colonies
    subplot(5,5,counter);
    
    dapi = plate1.colonies(ii).data(:,5);
    
    brachyury = plate1.colonies(ii).data(:,6)./dapi;
    bCat = plate1.colonies(ii).data(:,8)./dapi;
    nodal = plate1.colonies(ii).data(:,10)./dapi;
    
    scatter(brachyury, bCat, 10, nodal, 'filled');
    colorbar;
    
    counter = counter+1;
end
%%
% all colonies together
%channels
brachyury = zeros(1000,1);
bCat = brachyury;
nodal = bCat;
dapi = nodal;

%positions
xyValues = zeros(1000,2);

counter = 1;

for ii = coloniesInShape
    
    nCells = size(plate1.colonies(ii).data,1);
    dapi_1 = plate1.colonies(ii).data(:,5);
    
    brachyury_1 = plate1.colonies(ii).data(:,6)./dapi_1;
    bCat_1 = plate1.colonies(ii).data(:,8);%./dapi;
    nodal_1 = plate1.colonies(ii).data(:,10) + plate1.colonies(ii).data(:,11);
    
    xy1 = plate1.colonies(ii).data(:,1:2) - mean(plate1.colonies(ii).data(:,1:2));
    
    brachyury(counter:counter+nCells-1) = brachyury_1;
    bCat(counter:counter+nCells-1) = bCat_1;
    nodal(counter:counter+nCells-1) = nodal_1;
    dapi(counter:counter+nCells-1) = dapi_1;
    
    xyValues(counter:counter+nCells-1,:) = xy1;
    
    counter = counter+nCells;
    
end
%%
figure;
scatter(brachyury, bCat, 50, nodal, 'filled', ...
    'MarkerFaceAlpha', .5, 'MarkerEdgeAlpha', .2);
colormap(jet);
colorbar;
caxis([0 3]);
xlabel(['Brachyury/Dapi']);
ylabel(['Sox2/Dapi']);

%%
figure;
scatter(xyValues(:,1), xyValues(:,2), 20, nodal, 'filled', ...
    'MarkerFaceAlpha', .5, 'MarkerEdgeAlpha', .2);

colormap(jet);
colorbar;
caxis([100 200]);
%%
figure;
scatter(xyValues(:,1), xyValues(:,2), 20, brachyury, 'filled', ...
    'MarkerFaceAlpha', .5, 'MarkerEdgeAlpha', .2);

colormap(jet);
colorbar;
caxis([0 0.5]);
%%
figure;
scatter(xyValues(:,1), xyValues(:,2), 20, bCat, 'filled', ...
    'MarkerFaceAlpha', .5, 'MarkerEdgeAlpha', .2);

colormap(jet);
colorbar;
caxis([100 1000]);
%%
% plot a histogram of nanog expression levels:
% group1 = cells at a distance of <100 from the edge.
% group2 = cells at a distance of 125-225um from the edge.
% group3 = cells at a distance 300-500 um from edge.

xyValues = xyValues+900;
%%
colmax=max(xyValues(:,1:2));
mask=false(ceil(colmax(2))+100,ceil(colmax(1))+100);
inds=sub2ind(size(mask),ceil(xyValues(:,2)),ceil(xyValues(:,1)));
mask(inds)=1;
mask=bwconvhull(mask);
distt=bwdist(~mask);
dists=distt(inds);

dists = dists./userParam.umtopxl;
%%
group1 = find(dists<50);
group2 = find(dists>150 & dists<180);
group3 = find(dists>230);
%%
FaceColors = {[1 0 0], [0 0.5 0.5], [0.5 0 1]};
figure; 

histogram(nodal(group1), 'BinWidth', 0.2, 'Normalization', 'Probability', ...
    'DisplayStyle','stairs', 'EdgeColor', FaceColors{1}, 'LineWidth', 5);
hold on;
%%
figure;
histogram(nodal(group2), 'BinWidth', 0.2, 'Normalization', 'Probability', ...
    'DisplayStyle','stairs', 'EdgeColor', FaceColors{2}, 'LineWidth', 5);

hold on;
histogram(nodal(group3), 'BinWidth', 0.2, 'Normalization', 'Probability', ...
    'DisplayStyle','stairs', 'EdgeColor', FaceColors{3}, 'LineWidth', 5);


xlabel('Nanog/DAPI');
ylabel('Fraction of cells');

ax = gca;
ax.FontWeight = 'bold';
ax.FontSize = 12;
%%

histogram(nodal(group1), 'BinWidth', 0.2, 'Normalization', 'Probability', ...
    'DisplayStyle','stairs', 'EdgeColor', FaceColors{1}, 'LineWidth', 5);
hold on;
%%
figure;
histogram(bCat(group2), 'BinWidth', 0.5, 'Normalization', 'Probability', ...
    'DisplayStyle','stairs', 'EdgeColor', FaceColors{2}, 'LineWidth', 5);

hold on;
histogram(bCat(group3), 'BinWidth', 0.5, 'Normalization', 'Probability', ...
    'DisplayStyle','stairs', 'EdgeColor', FaceColors{3}, 'LineWidth', 5);

xlabel('Sox2/DAPI');
ylabel('Fraction of cells');

ax = gca;
ax.FontWeight = 'bold';
ax.FontSize = 12;

%%
rawImagesPath = parentDirectory{1};
saveInPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/170812_pluripotencyCheck_TNanogSox2/goodChipColonyImages/shape3';
shapeNum = 3;
makeColonyImages_mm(rawImagesPath, saveInPath, plate1, acoords, shapeNum);





