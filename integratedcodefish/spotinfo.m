function spotinfo(inputdirec, channels, samplenum)
%% 
% inputdirec = folder where raw images for spatzcells, masks and spatzcells output is saved.
% channels = channel number for which mrna was quantified.
% samplenum = no. of different samples in the dataset.
%%
ch = channels;
samples = samplenum;
mRNAfilter = 5; % works for most. Check the spotinfo histogram to make sure this value is good for your dataset too.
newfolder = strcat(inputdirec, '/', 'new_mRNAoutput');
mkdir (newfolder)

for i = 1:length(ch)
    filename = strcat(inputdirec, sprintf('/spotsquantify_ch%d/data/FISH_spots_data_new.mat', ch(i)));
    load(filename);
    clear spotinfomat
    
    for j = 1:samples
        spotinfo = spotlist_new{j}; % a variable in filename.
        % filter spots that map to more than hundred mRNA's. That's just
        % insane!
      
        spotinfo(:,5) = spotinfo(:,5)/One_mRNA;
        spotinfo = spotinfo(spotinfo(:,5) < mRNAfilter, :);
        spotinforeq = [spotinfo(:,14), spotinfo(:,1), spotinfo(:,7), spotinfo(:,8),spotinfo(:,5)];
        if j == 1
           spotinfomat = spotinforeq;
        else
            spotinfomat = [spotinfomat; spotinforeq];
        end
         
    end
    
    filename = strcat(newfolder, sprintf('/ch%dallspots.mat', ch(i)));
    save(filename, 'spotinfomat');
end

