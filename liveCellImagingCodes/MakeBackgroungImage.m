%%
% Making background Image for Live Cell Imaging data
%%
images_masterFolder = '/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616';
positions = 1:15;
channels = 1:3;
timepoint = 1;

erosion_radius = 100;

for ii = positions
    image1_name = [images_masterFolder sprintf('/Track%04d/Image%04d_01.oif', ii,ii)];
    image1reader = bfGetReader(image1_name);
    image1maxz = MakeMaxZmovies(image1reader, channels, timepoint);
    
    smooth_image = imgaussfilt(image1maxz);
    
    if ii==1
        background_image = smooth_image;    
    else
        background_image = min(background_image, smooth_image);
    end
end
    background_image = imopen(background_image, strel('disk', erosion_radius));
  
   
    
