function writeAllOpenFigures(writePath)
%% saving all open figures.
h = get(0,'children');

mkdir([writePath])
extn = '.tif'; %save as both pdf(for ppt) and fig(for later changes).

for ii=1:length(h)
     f = getframe(h(ii));
    image1 = frame2im(f);  
    imwrite(image1, [writePath filesep 'image_' int2str(ii) extn]);
end

%%


