function [rA, nPixels] = radialAverage_nuc2cyto_oneColony(channelImages, nuclearMask, colonyMask, filterSize, bins)

nuclearMask = colonyMask&nuclearMask;
cytoplasmicMask = colonyMask - nuclearMask;

%filterSize = 40; % works good for 20X images.
nChannels = size(channelImages,3);
colony_nuc2cyto = zeros(size(channelImages,1), size(channelImages,2), size(channelImages,3));

for ii = 1:nChannels
    colony_nuc2cyto(:,:,ii) = nuc2cytoPixelProfile_colonyImage(channelImages(:,:,ii), nuclearMask, cytoplasmicMask, filterSize);
end
%figure; imshow(colony_nuc2cyto,[]);
%% --------------------------------------------- radial average
rA = zeros(numel(bins)-1, nChannels);
nPixels = rA;

dists = bwdist(~colonyMask);
for ii = 1:length(bins)-1
    bin1 = [bins(ii) bins(ii+1)];
    idx1 = find(dists>bin1(1) & dists<=bin1(2));
    if~isempty(idx1)
         for jj = 1:nChannels
            image1 = colony_nuc2cyto(:,:,jj);
            rA(ii, jj) = mean(image1([idx1]));   
        end
    end
    
end

end