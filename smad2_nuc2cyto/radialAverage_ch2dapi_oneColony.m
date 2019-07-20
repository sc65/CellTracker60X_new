function [rA, nPixels] = radialAverage_ch2dapi_oneColony(channelImages, dapiImage, nuclearMask, colonyMask, bins, filterSize)
%% --------------------------------------------- Inputs

% -> channelImages: x*y*n array of n images for which pixel profile needs
% to be averaged.
% -> bins: bins in pixels for radial average calculation
% -> filterSize: radius in pixels of the summing filter
%% ---------------------------------------------

nuclearMask = colonyMask&nuclearMask;
%filterSize = 50; % in pixels. ~30um works good for 20X images.
colony_ch2dapi = ch2dapiPixelProfile_colonyImage(channelImages, dapiImage, nuclearMask, filterSize);

%% --------------------------------------------- radial average
nChannels = size(colony_ch2dapi,3);

rA = zeros(numel(bins)-1,nChannels);
nPixels = rA(:,1); % no. of pixels is same in every channel
dists = bwdist(~colonyMask);

for ii = 1:length(bins)-1
    bin1 = [bins(ii) bins(ii+1)];
    idx1 = find(dists>bin1(1) & dists<=bin1(2));
    nPixels(ii) = numel(idx1);
    
    if~isempty(idx1)
        for jj = 1:nChannels
            image1 = colony_ch2dapi(:,:,jj);
            rA(ii, jj) = mean(image1([idx1]));   
        end
    end
    
end

end