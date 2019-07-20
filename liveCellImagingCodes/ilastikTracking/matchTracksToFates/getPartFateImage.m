function fateImage1 = getPartFateImage(image2, colonyCenter2, colonyPart)
%% from the aligned fate image in the fluorescent channel, 
% get only the colony part that corresponds to colony part tracked.

%% ---------- Inputs -----------
% image2 = venus channel image from the fate image. 
% colonyCenter = center of the colony.
% colonyPart = 1/2 (top/Bottom)

stats1 = regionprops(image2, 'Centroid');
centers = cat(1, stats1.Centroid);
if colonyPart == 1
    toKeep = find(centers(:,2) < colonyCenter2(2));
else
    toKeep = find(centers(:,2) > colonyCenter2(2));
end

image2 = bwlabel(image2);
fateImage1 = ismember(image2, toKeep);
%figure; imshow(fateImage1); hold on; plot(colonyCenter2(1), colonyCenter2(2), 'r*');
