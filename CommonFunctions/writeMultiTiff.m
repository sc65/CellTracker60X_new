function writeMultiTiff(data, saveInPath)
%% writing a 3d image data to a tiff file

for ii = 1:size(data,3)
    
    if ii == 1
        imwrite(data(:,:,ii), saveInPath);
    else
        imwrite(data(:,:,ii), saveInPath, 'writeMode', 'append');
    end
    
end