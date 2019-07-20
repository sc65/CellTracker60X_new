function [aligned_image, overlap] = horizontalAlignmentImages(img_path, outputfile, image_positions, timepoint, overlap)


load(outputfile, 'bIms');
channels = 1:3; %[1 2 3] [gfp rfp brightfield] Use RFP channel.


img1_position = image_positions(1);
img2_position = image_positions(2);

%reading images and making max Z projections.
img1path = [img_path sprintf('/Track%04d/Image%04d', img1_position, img1_position), sprintf('_%02d.oif', timepoint)];
img1reader = bfGetReader(img1path);

img2path = [img_path sprintf('/Track%04d/Image%04d', img2_position, img2_position), sprintf('_%02d.oif', timepoint)];
img2reader = bfGetReader(img2path);

if nargin==4
    for ch = 2%Use max z projection in channel2 to find overlap.
        
        img1 = MakeMaxZmovies(img1reader, ch, 1);
        img1 = img1 - background_image(:,:,ch);
        
        img2 = MakeMaxZmovies(img2reader, ch, 1);
        img2 = img2 - background_image(:,:,ch);
        
        cross_correlation = zeros(1,500);
        for ii = 1:500
            pixels1 = img1(:,(end-ii):end);
            pixels2 = img2(:,1:(1+ii));
            
            cross_correlation(ii) = mean2((pixels1-mean2(pixels1)).*(pixels2-mean2(pixels2)));
        end
        
        %subplot(1,3,ch);
        %plot(cross_correlation);
    end
    %%
    [~, overlap] = max(cross_correlation(90:120)); %find the overlap in the range 90:120.
    overlap = overlap + 90 -1;
end

for ch = channels
    img1 = MakeMaxZmovies(img1reader, ch, 1);
    img1 = img1-background_image(:,:,ch);
    
    img2 = MakeMaxZmovies(img2reader, ch, 1);
    img2 = img2-background_image(:,:,ch);
    
    if ch==1
        aligned_image = uint16(zeros(size(img1,1), size(img1,2)+size(img2,2), 3));   
    end
    
    aligned_image(:,1:1024,ch) = img1;
    aligned_image(:,1024:1024+1024-overlap, ch) = img2(:,overlap:end);
    
end


aligned_image = uint16(aligned_image);




