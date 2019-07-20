function matchId  = matchCellTracksToFates(image1, xy1, umToPixel1, xy2, umToPixel2)
%%  draft1. Subject to change. 
%% match cells in last time point of live cell data to the fate image
%----- Inputs ------
% 1) image1: tracking image
% 2) xy1: centers of cells tracked till end - get this from tracking stats
% 2) umToPixel1: conversion factor for image1
% 3) xy2: centers of cells to be matched in fate image 
% 4) umToPixel1: conversion factor for image2
%-------------------
%----- Output ------
% matchId - cell Id corresponding to cell in image 2 that is matched to a
% cell in image1 (starting from cell1)
%--------------------------------------------------------------------------------------------

%% distance matrix.
cM1 = distmat(xy1, xy1);
cM1 = cM1/umToPixel1; % convert to microns

cM2 = distmat(xy2, xy2);
cM2 = cM2/umToPixel2; %convert to microns
%% theta matrix
thetaM1 = zeros(size(xy1,1));
for ii = 1:size(xy1,1)
    thetaM1(:,ii) = atan2d(-xy1(:,2) - -xy1(ii,2), xy1(:,1)-xy1(ii,1));
end
thetaM1  = thetaM1 + (thetaM1 < 0)*360; % convert to 0-360

thetaM2 = zeros(size(xy2,1));
for ii = 1:size(xy2,1)
    thetaM2(:,ii) = atan2d(-xy2(:,2) - -xy2(ii,2), xy2(:,1)-xy2(ii,1));
end
thetaM2  = thetaM2 + (thetaM2 < 0)*360;
%% will work as long as there are no false-positives around - there aren't any in the tracked cells list.
% find the 3 closest neighbors.
% find the angle the cell makes and those neighbors make with the horizontal.
% match.

matchId = zeros(size(xy1,1),1);
costs = matchId;
%%
neighbors = 9;
for ii = 1:size(xy1,1)
    [~, idx1] = sort(cM1(ii,:)); %get indices of neighbors - first 3 neighbors.
    idx1 = idx1(2:2+neighbors-1); %remove self from neighbors
    dist1 = cM1(idx1,ii);
    theta1 = thetaM1(idx1,ii);
    
    % position of neighbors
    y1 = xy1(idx1,2);
    top = numel(find(y1<xy1(ii,2)));
    bottom = numel(y1) - top;
    
    x1 = xy1(idx1,1);
    left =  numel(find(x1<xy1(ii,1)));
    right = numel(x1) - left;
    position1 = [left top right bottom];
   %% 
    thetaMM = zeros(neighbors, size(xy2,1));
    distMM = zeros(neighbors, size(xy2,1));
    positionMM = zeros(size(xy2,1),4);
     
    for jj = 1:size(xy2,1)
        [~, idx1] = sort(cM2(jj,:)); %get indices of neighbors - first 3 neighbors.
        idx1 = idx1(2:2+neighbors-1); %remove self from neighbors
        thetaMM(:,jj) = thetaM2(idx1,jj);
        distMM(:,jj) = cM2(idx1,jj);
        
        y1 = xy2(idx1,2);
        top = numel(find(y1<xy2(jj,2)));
        bottom = numel(y1) - top;
        
        x1 = xy2(idx1,1);
        left =  numel(find(x1<xy2(jj,1)));
        right = numel(x1) - left;
        
        positionMM(jj,:) = [left top right bottom];   
    end
    
    cost1 = abs(bsxfun(@minus,distMM,dist1));
    cost1 = sum(cost1, 1);
    
    cost2 = abs(bsxfun(@minus,thetaMM,theta1));
    cost2 = sum(cost2, 1);
    
    cost3 = abs(bsxfun(@minus,positionMM,position1));
    cost3 = sum(cost3,2);
    
    
    totalCost = cost1+0.2*cost2+4*cost3'; %-----------------Play with cost values.
    [~, matchedCell] = min(totalCost);
    
    matchId(ii,1) = matchedCell;
    costs(ii,1) = min(totalCost);
end

figure; imshow(image1); hold on;
plot(xy1(:,1), xy1(:,2), 'b*');
for ii = 1:size(xy1,1)
    text(xy1(ii, 1)+5, xy1(ii, 2), int2str(matchId(ii)), 'FontSize', 10, 'Color', 'g', 'FontWeight', 'bold');
end
title('trackedImage matched to fateImage');
end
%%









