function [image1, mergedObjectsInImage, falseObjectsInCellStats] = filterTrackedImage(image1, allCellStats)
%% a function that returns 1,3,4
% 1) image with only tracked cells
% 2) display 2 images for manual intervention -
%     a) merged cells
%     b) false positives
% 3) Ids of merged cells, ids as in labels of those cells in the image - if
% these objects are joined in the fate image, they need to be separated (if
% possible) before proceeding.
% 4) Ids of false positives, ids as in cell Id in the array allCellStats
%-----------------------------------------------
%% -------------Inputs --------------
% image1 - tracking image for the last time point.
% allCellStats - information on cell statistics stored in the output file
% -----------------------------------
trackingEndTimePoint = 165;
cellsEndTimePoint =  cellfun(@(x)(x(1,5)), allCellStats);
%%
cellsPresentAtEndTimePoint = find(cellsEndTimePoint == trackingEndTimePoint-1); %ilastik numbering starts from 0.
%% Get their positions at the end.
xValue = cellfun(@(x)(x(end,1)), allCellStats(cellsPresentAtEndTimePoint));
yValue = cellfun(@(x)(x(end,2)), allCellStats(cellsPresentAtEndTimePoint));
objectsTrackedPositions = floor([xValue' yValue']);
objectsTracked = size(xValue,1); % number of objects tracked.
%% Remove the objects not tracked.
stats = regionprops(image1, 'PixelList');
objectsInImage = size(stats,1);
image1 = bwlabel(image1);
toKeep = zeros(1,objectsTracked);
trueObjects = toKeep;
mergedObjectsInCellStats = toKeep;

counter = 1;
counter1 = 1;

for ii = 1:objectsInImage
    [check, ~, objectId] = intersect(stats(ii).PixelList, objectsTrackedPositions, 'rows');
    if ~isempty(check)
        toKeep(counter) = ii;
        if numel(objectId) > 1
            mergedObjectsInCellStats(counter1:counter1+numel(objectId)-1) = objectId;
            counter1 = counter1+numel(objectId);
            
        end
        trueObjects(objectId') = 1;
        counter = counter+1;
    end
end

falseObjectsInCellStats = cellsPresentAtEndTimePoint(~(trueObjects));

%%
if ~isempty(falseObjectsInCellStats)
    [~,id] = intersect(cellsPresentAtEndTimePoint, falseObjectsInCellStats);
    figure; imshow(image1);
    hold on;
    plot(xValue([id']), yValue([id']), 'r*');
    title('Are these real cells?');
end
%% get object Ids of merged cells in the new filtered image
% to be used as an input for watershed in case the objects are separable.

image1 = bwlabel(image1);
image1(~ismember(image1, toKeep)) = 0; % remove non-tracked cells.

image1 = imbinarize(image1);
stats = regionprops(image1, 'PixelList');

counter = 1;
mergedObjectsInImage = zeros(1,10);
if mergedObjectsInCellStats
    mergedObjectsPositions = [(xValue(mergedObjectsInCellStats))' (yValue(mergedObjectsInCellStats))'];
    
    for ii = 1:size(stats,1)
        if intersect(mergedObjectsPositions, stats(ii).PixelList)
            mergedObjectsInImage(counter) = ii;
            counter = counter+1;
        end
    end
    mergedObjectsInImage(mergedObjectsInImage==0) = [];
    %%
    figure; imshow(image1);
    hold on;
    plot(xValue([mergedObjectsInCellStats]), yValue([mergedObjectsInCellStats]), 'r*');
    title('Watch for these objects in fate image. Watershed, if possible');
end





