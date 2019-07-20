function colonyMask = makeColonyMask_nuclearMaskDeadCellsMask(saveInPath, nuclearMask, deadCellsMask)
%% using mask for segmented nuclei and segmented dead cells, this function returns the binary colony mask.

if exist('deadCellsMask', 'var')
    deadCells_extended = imdilate(deadCellsMask, strel('disk', 5));
    cleanMask1 = nuclearMask & (~deadCells_extended);
else
    cleanMask1 = nuclearMask;
end

cleanMask2 = imclose(cleanMask1, strel('disk', 16));
figure; imshow(cleanMask2);

cleanMask3 = bwconvhull(bwareafilt(imfill(cleanMask2, 'holes'),1));
colonyMask = cleanMask3;
figure; imshow(colonyMask);

if exist('saveInPath', 'var')
    imwrite(colonyMask, saveInPath)
end
end