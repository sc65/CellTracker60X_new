%%
% break up track 4 into 2 segments.
% segment1 - 1-84

saveInPath = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/trackingResultsPart1_084';
newImageFullPath = [saveInPath filesep 'track4part2.tif'];
counter = 1;
for ii = 85:165
    im1(:,:,counter) = imread('Track4ch1.tif',ii);
    if ii == 1
        imwrite(im1(:,:,counter), newImageFullPath);
    else
        imwrite(im1(:,:,counter), newImageFullPath, 'writemode', 'append');
    end
    counter = counter+1;
end