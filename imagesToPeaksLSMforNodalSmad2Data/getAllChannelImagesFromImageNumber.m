function images = getAllChannelImagesFromImageNumber(imagesDirectory, files, bIms, imageNumber, quadrant)
%% get the maxZ, background subtracted images for all channels, given the image Number

images = zeros(1024, 1024,length(files.ch));
for ch = 1:length(files.ch)
    currimgPath = getImagePath(imagesDirectory, files, imageNumber, quadrant);
    currimg = getMaxZ(currimgPath, ch);
    currimg = imsubtract(currimg, bIms{ch});
    images(:,:,ch) = currimg;    
end
end