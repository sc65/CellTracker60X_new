
%
% get the colony mask. Filter out cells which lie outside the mask.
colonyMask = imread('/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616/fullColonies/ilastik_segmentation/Colony2_colonymask.tif');
figure; imshow(colonyMask);

%%
% read mask file
masks = readIlastikFile('/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616/fullColonies/ilastik_segmentation/Colony2new_Simple Segmentation.h5');
area_threshold = 40;
masks = IlastikMaskPreprocess(masks, area_threshold);
%%
% use watershed to get full nuclei from ilastik masks - these are
% oversegmented.
% Raw images
filename = '/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616/fullColonies/Colony2new.tif';
filereader = bfGetReader(filename);
z = 1;
ch = [1 2]; %[RFP GFP]
peaks = cell(1, filereader.getSizeT);
%%
nuclear_masks = zeros(size(masks));
tic;
for t = 1:filereader.getSizeT
    
    mask1 = masks(:,:,t);
    mask1 = mask1 & colonyMask;
    
    iplane1 = filereader.getIndex(z-1, ch(1)-1, t-1)+1;
    image1(:,:,1) = bfGetPlane(filereader, iplane1); %image1: RFP
    
    iplane2 = filereader.getIndex(z-1, ch(2)-1, t-1)+1;
    image1(:,:,2) = bfGetPlane(filereader, iplane2); %GFP.
    
    [mask2, ~] = MakeNuclearMaskAndGetStats(mask1, image1(:,:,1));
    nuclear_masks(:,:,t) = mask2;
    peaks{t} = MasksToPeaks1(mask2, image1); 
  
    if t>1
        peaks =  MatchFrames(peaks, t, 50);
    end
   
end
toc;
%%
processT = @(t) (t-1).*3 + 1;%% convert hour to timepoint
timepoints = processT([26 35]);
checkTrackingInTimepoints(peaks, nuclear_masks,  timepoints);
%allstats = getCellMigrationStats(peaks, colonyMask, timepoints);
%%
% find indices of false positives.
% remove those cells from the list.
false_positives = [334 384 367];
not_to_remove = ~ismember(squeeze(allstats(1,1,:)), false_positives);
allstats = allstats(:,:,not_to_remove);
