function finalImage = align3by3LSMImage(files, colonyNumber, alignmentChannel, timepoint)
%% returns aligned image for a 2*2, 2*3, 3*2, 3*3 colony
%% ------------Inputs------------
% 1) files = a structure, returned by "readLSMmontageDirectory", contains information about the image directory
% 2) colonyNumber = In the sequence of colonies imaged, which number
% corresponds to this colony?
%%

if ~exist('timepoint', 'var')
    timepoint = 1;
end
% make max_z intensity images - used for aligning.
imagesPerColony = files.imagesPerColony_x.*files.imagesPerColony_y;
img = cell(1, imagesPerColony(colonyNumber));

for ii = 1:imagesPerColony(colonyNumber)
    if colonyNumber == 1
        imageNumber = ii;
    else
        imageNumber = (colonyNumber-1)*imagesPerColony(colonyNumber-1) + ii;
    end
    fileInfo = dir([files.dir filesep sprintf('Track%04d/', imageNumber), '*.oif']);
    fileToRead = [fileInfo(timepoint).folder filesep fileInfo(timepoint).name];
    filereader = bfGetReader(fileToRead);
    channels = 1:filereader.getSizeC;
    img{ii} = MakeMaxZImage(filereader, channels, 1);
    img{ii} = smoothAndBackgroundSubtractOneImage(img{ii});
end
%% align images left-right
rowImageIds = reshape([1:imagesPerColony(1)], [files.imagesPerColony_x(colonyNumber), files.imagesPerColony_y(colonyNumber)])';
alignedImages = cell(1,size(rowImageIds,1));
side = 4;
overlap = 150;

for ii = 1:size(rowImageIds,1)
    img1 = img{rowImageIds(ii,1)};
    img2 = img{rowImageIds(ii,2)};
    alignedImage = alignTwoImagesFourier_multiChannel(img1, img2, side, overlap, alignmentChannel);
    
    if size(rowImageIds,2) == 3
        img3 = img{rowImageIds(ii,3)};
        alignedImages{ii} = alignTwoImagesFourier_multiChannel(alignedImage, img3,  side, overlap, alignmentChannel);
    else
        alignedImages{ii} = alignedImage;
    end
end
%% align images top-bottom
img1 = alignedImages{1};
img2 = alignedImages{2};

side = 1;
overlap = 200;
[img12, ~, ~] = alignTwoImagesFourier_multiChannel(img1, img2,  side, overlap, alignmentChannel);

if size(rowImageIds,1) == 3
    img1 = img12;
    img2 = alignedImages{3};
    [finalImage, ~, ~] = alignTwoImagesFourier_multiChannel(img1, img2,  side, overlap, alignmentChannel);
else
    finalImage = img12;
end

end
