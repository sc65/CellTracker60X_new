function rawImage = displayImageWithColonyBoundary (rawImage, colonyMask, withBoundary)
%% displays a raw image along with the colony boundary

%% ------ Inputs
% rawImage, colonyMask: matrices.
% withBoundary = 0/1;

%%

rawImage = bsxfun(@times, rawImage, cast(colonyMask, class(rawImage)));

if ~exist('withBoundary', 'var')
    withBoundary = 1;
end

if withBoundary == 1
    [B, ~] = bwboundaries(colonyMask, 'noholes');
    boundary = B{1};
    boundary_linearIdx = sub2ind(size(rawImage), boundary(:,1), boundary(:,2));
    
    imageWithBoundary = uint16(zeros(size(rawImage,1), size(rawImage,2)));
    imageWithBoundary(boundary_linearIdx) = 2^16-1;
    imageWithBoundary = imdilate(imageWithBoundary, strel('disk', 3));
    
    rawImage = rawImage+imageWithBoundary;
   
    
end
end