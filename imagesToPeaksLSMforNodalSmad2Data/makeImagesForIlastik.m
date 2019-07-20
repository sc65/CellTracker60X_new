function makeImagesForIlastik(dapifolder, imagesDirectory, files)
%save the max z DAPI images for all positions in a different folder.
%Use these to train iLastik

mkdir([imagesDirectory filesep dapifolder]);
totalImages = sum(files.images);
channel = 1; %DAPI channel.
for ii = 1:totalImages
    image1dir = [imagesDirectory filesep sprintf('Track%04d', ii)];
    image1info = dir([image1dir filesep '*.oif']);
    if ~isempty(image1info)
        image1path = [image1dir filesep image1info.name];
        maxz = getMaxZ(image1path, channel);
        image2 = [imagesDirectory filesep dapifolder filesep sprintf('Image%04d_01.tif', ii)];
        imwrite(maxz, image2);
    end
end