function ilastikMask = IlastikMaskPreprocess(ilastikMask, areaThreshold)
% preprocessing ilastik segmentation masks

if ~exist('areaThreshold', 'var')
    areaThreshold = 50;
end

for ii = 1:size(ilastikMask,3)
    ilastikMask(:,:,ii) = bwareaopen(ilastikMask(:,:,ii), areaThreshold);
    ilastikMask(:,:,ii) = imfill(ilastikMask(:,:,ii), 'holes');
end


end

