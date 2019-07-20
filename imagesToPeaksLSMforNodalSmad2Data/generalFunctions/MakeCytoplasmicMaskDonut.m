function [nuclearMask, cytoplasmicMask] = MakeCytoplasmicMaskDonut(nuclearMask, donutSize)
%% returns cytoplasmic masks for cells

stats = regionprops(nuclearMask,'Area','Centroid', 'PixelIdxList');
% make the cytoplasmic masks.
% start with voronoi of cells.
maskSize = size(nuclearMask);
stats = addVoronoiPolygon2Stats(stats, maskSize);
%%
cytoplasmicMask  = zeros(size(nuclearMask));
for ii = 1:numel(stats)
    cytoplasmicMask(stats(ii).VPixelIdxList) = ii;
end
%% match
stats2 = stats; %temporary variable
for ii = 1:numel(stats)
    
    idx = floor([stats(ii).Centroid(1), stats(ii).Centroid(2)]);
    match = cytoplasmicMask(idx(2), idx(1));
    if match ~= 0
        stats2(ii).VPixelIdxList = stats(match).VPixelIdxList;
    end
end

%% label the nuclear mask. correct the labels in the cytoplasmic mask.
nuclearMask = double(nuclearMask);
for ii = 1:numel(stats)
    nuclearMask(stats2(ii).PixelIdxList) = ii;
end

cytoplasmicMask = zeros(size(nuclearMask));
for ii = 1:numel(stats)
    cytoplasmicMask(stats2(ii).VPixelIdxList) = ii;
end

allNuclearPixels = cat(1, stats2.PixelIdxList);
cytoplasmicMask(allNuclearPixels) = 0;

if ~exist('donutSize', 'var')
    donutSize = 6;
end
radius = donutSize;
donut = imdilate(nuclearMask, strel('disk', radius));
cytoplasmicMask(~donut|nuclearMask) = 0;


%figure; imshow(cytoplasmic_mask,[]); colormap('jet'); caxis([1 800]); %check if the cyto mask loooks decent.

end