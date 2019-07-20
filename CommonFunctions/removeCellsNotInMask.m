function mask = removeCellsNotInMask(mask, alphaRadius)
%removing cells which do not belong to the largest object.
%plate1: object plate.
%%
if ~exist('alphaRadius', 'var')
    alphaRadius = 50; %for making alphashape. The distance should enable required separation
end

stats = regionprops(mask, 'PixelList');
xy = cat(1, stats.PixelList);
%%
% figure;
% plot(xy(:,1), xy(:,2), 'k*'); %all the points in original mask.
ashape = alphaShape(xy(:,1), xy(:,2), alphaRadius);
points_in_shape =  xy(inShape(ashape,xy(:,1), xy(:,2), 1),:); %points in alphaShape.

% hold on;
% plot(points_in_shape(:,1), points_in_shape(:,2), 'r*');

points_outside =  setdiff(xy, points_in_shape, 'rows');
%%
linearIdx = sub2ind([size(mask)], points_outside(:,2), points_outside(:,1));
mask([linearIdx]) = 0;
%figure; imshow(mask);
end
