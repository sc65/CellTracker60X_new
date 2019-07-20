function img3 = horizontalAlignmentImages(img1_position, img2_position)

channels = 1:3; %[1 2 3] [gfp rfp brightfield] Use RFP channel.
timepoint = 1;


%reading images and making max Z projections.
img1path = [sprintf('Track%03d/Image%03d', img1_position), sprintf('_%02d.oif', timepoint)];
img1reader = bfGetReader(img1path);

img2path = [sprintf('Track%03d/Image%03d', img2_position), sprintf('_%02d.oif', timepoint)];
img2reader = bfGetReader(img2path);

for ch = 2 %Use channel2 to find overlap. 
    
    img1 = MakeMaxZmovies(img1reader, ch, timepoint);
    img2 = MakeMaxZmovies(img2reader, ch, timepoint);
    
    
    cross_correlation = zeros(1,500);
    for ii = 1:500
        pixels1 = img1(:,(end-ii):end);
        pixels2 = img2(:,1:(1+ii));
       
        cross_correlation(ii) = mean2((pixels1-mean2(pixels1)).*(pixels2-mean2(pixels2)));
    end
    
    
end
%%
[~, overlap] = max(cross_correlation);
img3 = uint16(zeros(1024, 2048, 3));

for ch = channels
    img1 = MakeMaxZmovies(img1reader, ch, timepoint);
    img2 = MakeMaxZmovies(img2reader, ch, timepoint);
    
    img3(:,1:1024,ch) = img1;
    img3(:,1024:1024+1024-overlap, ch) = img2(:,overlap:end);
    
end


img3 = uint16(img3);




