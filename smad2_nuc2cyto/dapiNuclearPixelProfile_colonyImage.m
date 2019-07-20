function colony_dapiNuclearPixelProfile = dapiNuclearPixelProfile_colonyImage(dapiImage, nuclearMask, filterSize)
%% computes the ratio of average nuclear pixels in the dapi image of the colony
% to average nuclear pixels in colony image of dapi channel.

filter1 = ones(filterSize);
nuclear_pixels = imfilter(double(nuclearMask), filter1);

%% applying nuclear filter to dapi image
dapi_nuc = bsxfun(@times, dapiImage, cast(nuclearMask,class(dapiImage))); % nuclear cast
dapi_nuc_nSum = imfilter(double(dapi_nuc), filter1); % neighbourhood sum
colony_dapiNuclearPixelProfile = double(dapi_nuc_nSum)./double(nuclear_pixels);
colony_dapiNuclearPixelProfile(isnan(colony_dapiNuclearPixelProfile)) = 0; % remove nan

end