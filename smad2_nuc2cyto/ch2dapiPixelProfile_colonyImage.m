function [colony_ch2dapi, dapi_nuclear_avg] = ch2dapiPixelProfile_colonyImage(nonDapiImages, dapiImage, nuclearMask, filterSize)
%% computes the ratio of average nuclear pixels in the colony image of a given channel

% filterSize : radius of the filter(in pixels) - defines the neighbourhood for filtering

% to average nuclear pixels in colony image of dapi channel.
nChannels = size(nonDapiImages,3);
colony_ch2dapi = zeros(size(nonDapiImages,1), size(nonDapiImages,2), nChannels);

filter1 = ones(filterSize);
nuc_pixels = imfilter(double(nuclearMask), filter1);

%% applying nuclear filter to dapi image
dapi_nuclear = bsxfun(@times, dapiImage, cast(nuclearMask,class(dapiImage))); % nuclear cast
dapi_nuclear_nSum = imfilter(double(dapi_nuclear), filter1); % neighbourhood sum
dapi_nuclear_avg = double(dapi_nuclear_nSum)./double(nuc_pixels);

%% applying nuclear filter to non-dapi image
for ii = 1:nChannels
    channel1_nuclear = bsxfun(@times, nonDapiImages(:,:,ii), cast(nuclearMask,class(nonDapiImages(:,:,ii)))); % nuclear cast
    channel1_nuclear_nSum = imfilter(double(channel1_nuclear), filter1); % neighbourhood sum
    channel1_nuclear_avg = double(channel1_nuclear_nSum)./double(nuc_pixels);
    colony_ch2dapi(:,:,ii) = channel1_nuclear_avg./dapi_nuclear_avg;

    colony_ch2dapi(isnan(colony_ch2dapi)) = 0; % remove nan
    colony_ch2dapi(isinf(colony_ch2dapi)) = 0; %remove infinity
end
end