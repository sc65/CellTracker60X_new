function makeMaxZDapi(imagesDirectory, channels)
%%
%save the max z DAPI images for all positions in a different folder.
%Use these to train iLastik.
logfile = 'MATL_Mosaic.log';
files = readLSMmontageDirectory(imagesDirectory, logfile, channels);

dapifolder = 'DAPImaxZ';
makeImagesForIlastik(dapifolder, imagesDirectory, files);

end