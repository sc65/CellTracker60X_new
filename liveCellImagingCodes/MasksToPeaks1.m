function peaks = MasksToPeaks1(images, nuclearMask, cytoplasmicMask, mRNA_channels)
%% given a nuclear mask, cytoplasmic mask and different channel images, this function returns
% the information of cells in the array peaks.
%----------- Input-----------
% images - a 3d/4d array of images (x,y, channel, z), starting from nuclear channel (dapi/rfp) image.

properties = regionprops(nuclearMask, 'Centroid', 'Area');
centers = cat(1,properties.Centroid);
area = [properties.Area]';
peaks = zeros(size(centers,1), 6);

peaks(:,1:2) = centers;
peaks(:,3) = area;
peaks(:,4) = -1;


counter = 1;
%% for max z projections, or images with no z information, this part works fine.
if size(images,4)<2
    for ii = 1:size(images,3)
        intensity1 = regionprops(nuclearMask, images(:,:,ii), 'MeanIntensity');
        nuclearIntensity = [intensity1.MeanIntensity]';
        peaks(:,4+counter) = nuclearIntensity;
        counter = counter+1;
        
        if (ii>1)
            % add cytoplasmic intensity only for non-DAPI channels.
            if exist('cytoplasmicMask', 'var')
                intensity1 = regionprops(cytoplasmicMask, images(:,:,ii), 'MeanIntensity');
                cytoplasmicIntensity = [intensity1.MeanIntensity]';
                peaks(:,4+counter) = cytoplasmicIntensity;
                counter = counter+1;
            end
        end
        
    end
    
else
    %% if images are taken across multiple z planes, then for each cell,
    % first find the z plane with max nuclear intensity,
    % then use that z channel to calculate intensity for each cell in that channel.
    
    % assuming the first channel in the image order corresponds to nuclear
    % channel.
    % "intensity1/2" contain intensities corresponding to nuclear/cytoplasmic
    % channels for every cell in each z plane for every channel
    % (cell*zPlane*channel)
    
    for ii = 1:size(images,3)
        for jj = 1:size(images,4)
            stats1 = regionprops(nuclearMask, images(:,:,ii,jj), 'MeanIntensity');
            stats2 = regionprops(cytoplasmicMask, images(:,:,ii,jj), 'MeanIntensity');
            if ii == 1 && jj == 1
                intensity1 = zeros(size(stats1,1), size(images,4));
                intensity2 = intensity1;
            end
            intensity1(:,jj,ii) = cat(1, stats1.MeanIntensity);
            intensity2(:,jj,ii) = cat(1, stats2.MeanIntensity);
        end
    end
    
    % z1: z slice with maximum nuclear intensity
    nuclearChannelIntensity = intensity1(:,:,1);
    [~,zMax] = max(nuclearChannelIntensity,[],2);
    
    %% update values in peaks.
    if mRNA_channels>0
        proteinChannels = setxor([1:size(images,3)], mRNA_channels);
    else
        proteinChannels = 1:size(images,3);
    end
    
    %% for protein channels, use the z plane where the cell is in focus.
    counter = 1;
    for ii = proteinChannels
        nuclearIntensity = intensity1(:,:,ii);
        cytoplasmicIntensity = intensity2(:,:,ii);
        idx = sub2ind(size(nuclearIntensity), 1:size(nuclearIntensity, 1), zMax');
        % converts(i,j) = (rowIdx, columnIdx) into linear indices.
        
        peaks(:,4+counter) = nuclearIntensity(idx); % add this value to peaks array
        counter = counter+1;
        
        if ii>1 % add cytoplasmic intensity only for non-dapi/rfp channels.
            peaks(:,4+counter) = cytoplasmicIntensity(idx);
            counter = counter+1;
        end
    end
    
    %% for mRNA channel, add the intensity across all z slices
    if (mRNA_channels)
        for jj = mRNA_channels
            nuclearIntensity = intensity1(:,:,jj);
            cytoplasmicIntensity = intensity2(:,:,jj);
            
            peaks(:,4+counter) = sum(nuclearIntensity,2); % add this value to peaks array
            counter = counter+1;
            
            peaks(:,4+counter) = sum(cytoplasmicIntensity,2);
            counter = counter+1;
        end
    end
end
%%

