%
%%
mask1 = zeros(1024);
for ii = 1:26
    mask1(stats(ii).PixelIdxList) = ii;
end
stats2 = stats;
mask2  = zeros(1024);
for ii = 1:26
    mask2(stats(ii).VPixelIdxList) = ii;
end
%%
figure; imshow(mask1);
hold on;
for ii = 1:26
    idx = floor([stats(ii).Centroid(1), stats(ii).Centroid(2)]);
    text(stats(ii).Centroid(1), stats(ii).Centroid(2), int2str(mask1(idx(2), idx(1))), 'FontSize', 14, 'Color', 'r');
end
%%
figure; imshow(mask2);
for ii = 1:26
    idx = floor([stats(ii).Centroid(1), stats(ii).Centroid(2)]);
    text(stats(ii).Centroid(1), stats(ii).Centroid(2), int2str(mask2(idx(2), idx(1))), 'FontSize', 14, 'Color', 'r');
end
%%
for ii = 1:26
    idx = floor([stats(ii).Centroid(1), stats(ii).Centroid(2)]);
    match = mask2(idx(2), idx(1))
    stats2(ii).VPixelIdxList = stats(match).VPixelIdxList;
end
%%
mask3  = zeros(1024);
for ii = 1:26
    mask3(stats2(ii).VPixelIdxList) = ii;
end
%%
figure; imshow(mask3);
for ii = 1:26
    idx = floor([stats(ii).Centroid(1), stats(ii).Centroid(2)]);
    text(stats(ii).Centroid(1), stats(ii).Centroid(2), int2str(mask3(idx(2), idx(1))), 'FontSize', 14, 'Color', 'r');
end













