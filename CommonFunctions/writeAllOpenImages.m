function writeAllOpenImages(imageFolder, imageCompletePath)
%% saving all open figures.
% imageCompletePath - full image path including imageName
 
h = get(0,'children');


extn = '.tif'; %save as both pdf(for ppt) and fig(for later changes).

for ii=1:length(h)
    f = getframe(h(ii));
    image1 = frame2im(f);
    
    if exist('imageCompletePath', 'var')
        imwrite(image1, imageCompletePath);
    else
        mkdir([imageFolder]);
        imwrite(image1, [imageFolder filesep 'image_' int2str(ii) extn]);
    end
end

%%


