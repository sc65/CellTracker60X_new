function data = normaliseDapi(data, dapiChannel)
%% Dapi values are divided by the mean DAPI value.
% This removes differences in DAPI values across across samples
%-----------------------------Inputs-------------------------------
% data: can be either a single matrix - one condition or a cell array, each
% cell representing a different condition.
% dapiChannel: column corresponding to DAPI values.  
%%
if iscell(data) 
    for ii = 1:size(data,2)
        data{ii}(:,dapiChannel) = data{ii}(:,dapiChannel)./mean(data{ii}(:,dapiChannel));
    end
else
    data(:,dapiChannel) = data(:,dapiChannel)./mean(data(:, dapiChannel));
end


