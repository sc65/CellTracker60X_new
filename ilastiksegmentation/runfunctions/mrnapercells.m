function [peaks, spotstable]= mrnapercells(nucleilist, stats, mrnamatfile, colonyno, zrange, channels, cmcenter, mask3d)

%%
% spotstable contains information about spots identified in the image
% Every row represents a spot.
% The columns - [x y z mrna_count cell_id channel_no]
% x, y , z position of the centroid of spot.
% cell_id: cell number to which the spot is assigned.
% channel_no: channel in which the spot was identified.
%%
% peaks contains information about cells identified in each image
% Every row represents a cell.
% The columns - [x y z cell_id random_filler mrna1nuc mrna1cyto mrna2nuc
% mrna2cyto mrna3nuc mrna3cyto]
% x,y,z position of the centroid of cell.
% cell_id: cell number
% random_filler: In order to make peaks array compatible with peaks from
% CellTracker, this column is added.
% mrna1nuc: mrnas assigned to the cell as they overlap with the cell in channel 1
% mrna1cyto: mrnas assigned to the cell as they are closest to the cell in
% channel1.
%%

% getting the center of nuclei in 3D
zstart = zrange(1);
zend = zrange(end);

nucleiinfo = cell(1,size(nucleilist,1));

for i = 1:size(nucleiinfo,2)
    
    object = nucleilist(i,:);
    objectmatchcol = find(~isnan(object));
    
    objectmatchz = zrange(objectmatchcol);
    objectsmatched = nucleilist(i,objectmatchcol);
    
    for match = 1:numel(objectsmatched)
        centroidmatch = stats{objectmatchz(match)}(objectsmatched(match)).Centroid;
        nucleiinfo{i}(match,:) = [centroidmatch objectmatchz(match)];
    end
    
    xcenter = 0.5*(max(nucleiinfo{i}(:,1))+min(nucleiinfo{i}(:,1)));
    ycenter = 0.5*(max(nucleiinfo{i}(:,2))+min(nucleiinfo{i}(:,2)));
    zcenter = 0.5*(max(nucleiinfo{i}(:,3))+min(nucleiinfo{i}(:,3)));
    
    nucleicenter(i,:) = [xcenter, ycenter, zcenter];
end

%%
% assigning mRNA's
% If masklabel at pixeindices corresponding to the spot belongs to a cell,
% then spot is assigned to that cell.(mrnapercelln)
% Else it is assigned to the closest cell, provided distance between the
% centroids is less than the threshold. (mrnapercellc)
% To make the code compatible with cases where only protein levels have to
% be quantified - set mrnafilepath as 0.

peaks = nucleicenter;

if(mrnamatfile)
    counter = 1;
    
    
    for ii = 1:numel(channels)
        
        mrnafile = strcat(mrnamatfile, filesep, sprintf('ch%dallspots.mat', channels(ii)));
        load(mrnafile);
        
        spots = spotinfomat(spotinfomat(:,1) == colonyno,:);
        
        spots(any(isnan(spots),2), :) = [];
        
        spotspos = [spots(:,3:4), spots(:,2)];
        
        mrnapercelln = zeros(1, size(nucleicenter,1));
        mrnapercellc = zeros(1, size(nucleicenter,1));
        
        %%
        
        for i = 1: size((spots),1)
            x0 = spotspos(i,1);
            y0 = spotspos(i,2);
            z0 = spotspos(i,3)+1; %% z value in spots starts from 0, whereas in nucleilist it starts from 1.
            
            %%
            rpxl = floor(y0+0.5);
            cpxl = floor(x0+0.5);
            
            celln = mask3d(rpxl, cpxl, z0);
            if celln > 0
                mrnapercelln(celln) = mrnapercelln(celln)+floor(spots(i,5));
                
            else
                mydist = sqrt((nucleicenter(:,1) - x0).^2 + (nucleicenter(:,2) - y0).^2 + (nucleicenter(:,3) - z0).^2);
                [dist, celln] = min(mydist);
                
                if(dist<cmcenter)
                    mrnapercellc(celln) = mrnapercellc(celln)+floor(spots(i,5));
                end
            end
            
            spotstable(counter,:) = [x0, y0, z0-1, floor(spots(i,5)), celln, channels(ii)];
            counter = counter+1;
        end
        
        %%
        ncolpeaks = size(peaks,2) + 1;
        
        for i = 1:size(nucleicenter,1)
            peaks(i,ncolpeaks) = mrnapercelln(i);
            peaks(i,ncolpeaks+1) = mrnapercellc(i);
        end
        
        
    end
end

if(~(exist('spotstable', 'var')))
    spotstable = 0;
end
%%





