
%% save the colony 3 tif file (134 timepoints, 2 channels, both separately) as a smaller figure.
clearvars;
image1 = '/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616/fullColonies/colony3/Colony3new.tif';
image2 = '/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616/fullColonies/colony3/';
%%
reader = bfGetReader(image1);
channels = reader.getSizeC;
timePoints = reader.getSizeT;
%%
zPlane = 1;

xValues = [490:1889];
yValues = [1:1400];

for ii = 1:2 % only rfp and gfp channels
    image12 = uint16(zeros(1400,1400));
    image12_fullPath = [image2 filesep 'colony3small_ch' int2str(ii) '.tif'];
    
    for jj = 1:timePoints
        imagePlane = reader.getIndex(zPlane-1, ii-1, jj-1)+1;
        image11 = bfGetPlane(reader, imagePlane);
        
        image12 = image11([yValues], [xValues]);
        if jj == 1
            imwrite(image12, image12_fullPath);
        else
            imwrite(image12, image12_fullPath, 'WriteMode', 'append');
        end
    end
end

%%
% optimize colony masks - 
% keep only the biggest object
% fill holes
% save all timepoints as a binary file
%%
colonyMask_binary = '/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616/fullColonies/colony3/colony3_colonyMask.tif';
colonyMask = readIlastikFile('/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616/fullColonies/colony3/colony3small_ch2_Simple Segmentation.h5');
%%
for ii = 1:134
colonyMask1 = colonyMask(:,:,ii);
stats = regionprops(colonyMask1, 'Area');
colonyMask1 = bwlabel(colonyMask1);
%%
areaMax = find([stats.Area] == max([stats.Area]));
colonyMask1(colonyMask1~= areaMax) = 0;
%%
colonyMask1 = imfill(colonyMask1, 'holes');
colonyMask1 = imbinarize(colonyMask1);
if mod(ii,20) == 0
figure; imshow(colonyMask1);
end
%%
if ii == 1
    imwrite(colonyMask1, colonyMask_binary);
else
    imwrite(colonyMask1, colonyMask_binary, 'WriteMode', 'append');
end
end












