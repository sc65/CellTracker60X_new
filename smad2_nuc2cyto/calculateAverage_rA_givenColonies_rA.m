function [rA_all, rA_all_stdError] = calculateAverage_rA_givenColonies_rA(rA_colonies, nPixels, colonyIds)
%% given radial average and pixels information for all colonies, 
% this function calculates average radial average across all colonies. 

%% ------ Inputs ---------
% rA_colonies(bins, colonies, channels) - 3d array
% nPixels(bins, colonies) - 2d array
%%

if ~exist('colonyIds', 'var')
    colonyIds = 1:size(rA_colonies, 2);
end

nColonies = numel(colonyIds);
rA_colonies = rA_colonies(:,[colonyIds], :);
nPixels = nPixels(:,[colonyIds]);

for ii = 1:size(rA_colonies,3)
    rA_ch1 = rA_colonies(:,:,ii);
    
    rA_mean = sum(rA_ch1.*nPixels,2)./sum(nPixels,2);
    rA2_mean = sum(rA_ch1.*rA_ch1.*nPixels,2)./sum(nPixels,2);
    %%
    rA_std_dev = sqrt(rA2_mean-rA_mean.*rA_mean);
    rA_std_error = rA_std_dev./sqrt(numel(nColonies));
    %%
    badinds=isnan(rA_mean);
    rA_mean(badinds)=[]; rA_std_dev(badinds)=[]; rA_std_error(badinds)=[];
    
    rA_all(:,ii) = rA_mean;
    rA_all_stdError(:,ii) = rA_std_error;
end