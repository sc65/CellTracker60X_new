function centercentroid(cen, dir1, pos, sn)

%%
% Replacing centroid of voronoi with center values. 
center1 = cen;
nimages = numel(center1);
dir1 = strcat(dir1, '/masks');


%%
% Replacing centroid of voronoi with center values. 

%i = 1;
for i = 1:nimages
    clear pxl LcFull
    filen = sprintf('/fishseg%02d.mat',i);  
    filen1 = strcat(dir1, filen);
    load(filen1);
    pxl = regionprops(LcFull, 'PixelList', 'Centroid');
    
    for i1 = 1:size(center1{i},1)
        c(i1) = ceil(center1{i}(i1,1));
        r(i1) = ceil(center1{i}(i1,2));
        
        for i2 = 1:numel(pxl)
          plist = pxl(i2).PixelList; 

          for i3 =1:size(plist,1)
            if(c(i1) == plist(i3,1) && r(i1) == plist(i3,2))
            m{i}(i1) = i2;
            end
          end
        end
    end
end
 
%%
dir1 = 'Volumes/data/spatzcells_quant/150712fishmp/150722FISHMP/testim/masks/';


for i = 1:nimages
    
    mxlim = numel(m{i});
    newpos{i}= zeros(mxlim,2);
    
    for j = 1:mxlim
        
        
        if(m{i}(j) ~= 0)
          newpos{i}(m{i}(j),1) = center1{i}(j,1);
          newpos{i}(m{i}(j),2) = center1{i}(j,2);
        end 
            
    end
end

    
%%
% Replacing zeroes with adjacent centroid. 

% dir1 = 'Volumes/data/spatzcells_quant/150712fishmp/150722FISHMP/testim/masks/';
% dir1 = '.';

for i = 1:numel(newpos)
    
    clear pxl LcFull
    filen = sprintf('/fishseg%02d.mat',i);  
    filen1 = strcat(dir1, filen);
    load(filen1);
    pxl = regionprops(LcFull, 'PixelList', 'Centroid');
    mxmlim = size(newpos{i},1);
    
    for j = 1:mxmlim
        if(newpos{i}(j,1) == 0 || newpos{i}(j,2) == 0)
            
            if(isnan(pxl(j).Centroid(1)))
            newpos{i}(j,1) = pxl(j+1).Centroid(1);
            newpos{i}(j,2) = pxl(j+1).Centroid(2);
            else
               newpos{i}(j,1) = pxl(j).Centroid(1);
               newpos{i}(j,2) = pxl(j).Centroid(2); 
            end
        end
    end
    %newpos{i}( ~any(newpos{i},2), : ) = []; 
   
end
            
  %%
  % checking if everything looks fine
  %dir1 = 'Volumes/data/spatzcells_quant/150712fishmp/150722FISHMP/testim/masks/';
  %dir1 = '.';
%   i = 24;
%   close all;
% %for i = 1:numel(newpos)
%     mxlim = size(newpos{i},1);
%     clear pxl LcFull
%     filen = sprintf('/fishseg%02d.mat',i);  
%     filen1 = strcat(dir1, filen);
%     load(filen1);
%     pxl = regionprops(LcFull, 'PixelList', 'Centroid');
%     
%     figure; showImg({LcFull});
%     
%     for j = 1:size(newpos{i},1)
%         hold on;
%         text(newpos{i}(j,1),newpos{i}(j,2), sprintf('%02d', j));
%     end
%     
    
%%

m = 1;
for sample = 1:sn
    
for i = 0:pos(sample)-1
    filen = strcat(dir1, '/results/', sprintf('sample%01d/output%02d.mat',sample, i));
    load(filen);
    
    for j = 1:size(peaks,1)
        peaks(j,1) = newpos{m}(j,1);
        peaks(j,2) = newpos{m}(j,2);
        m = m+1;
    end
    
    save(filen, 'peaks', 'imgfiles');
end

end 
end

