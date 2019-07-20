function makePeaksLSM(imagesPath, ilastikMasksPath, files, quadrant, outputFile, mRNA_channel)
%% a function that saves all the relevant variables for a quadrant imaged in a particular outputfile.
%---Inputs-----
% imagesDirectory: Path of the directory that contains all the tracks.
% files: output from the function readLSMmontageDirectory.
% quadrant: some directories have images taken from >1 quadrant. Specify
% the one for which you want to make peaks array.


% make background image for every channel
 channels = 1:length(files.ch);
% load(outputFile);

bIms= cell(1,length(channels));
for ii = channels
    [bgImage,~] = mkBackgroundImageLSM(imagesPath, files, ii, quadrant);
    bIms{ii}=uint16(2^16*bgImage);
end

save(outputFile, 'bIms');
%%
%make the array peaks.
 tic;
 peaks = cell(1, files.images1(quadrant));
 imgfiles = struct;
% 
% %for ii = 18
 for ii = 1:files.images1(quadrant)
    ii
    
    endPositions = cumsum([0 files.images]);
    imgPosition = endPositions(quadrant)+ii;
    
    maskname = [ilastikMasksPath filesep sprintf('Image%04d_01_Simple Segmentation.h5', imgPosition)];
    ilastikMask = readIlastikFile(maskname);
    areaThreshold = 40; %removes bright spots smaller than 40 pixels.
    ilastikMask = IlastikMaskPreprocess(ilastikMask, areaThreshold);
    

    rawImages = getRawImages_allChannels_allz_LSM(imagesPath, imgPosition);    

    %[ilastikMask, ~] = MakeNuclearMaskAndGetStats(ilastikMask, image1(:,:,1)); %if
    %oversegmented, uncomment this,
    nuclearMask = ilastikMask;
    donutSize = 6;
    [nuclearMask, cytoplasmicMask] = MakeCytoplasmicMaskDonut(nuclearMask, donutSize);
    properties = regionprops(nuclearMask, 'PixelIdxList');
    
    peaks{ii} = MasksToPeaks1(rawImages, nuclearMask, cytoplasmicMask, mRNA_channel); %call to peaks function
    
    %add some strings to the structure imgfiles in order to prevent the peaks to colonies from crashing.
    imgfiles(ii).nucfile = 'toMakeColonies'; 
    imgfiles(ii).errorstr = imgfiles.nucfile;
    if ~isempty(cat(1,properties.PixelIdxList))
        imgfiles(ii).compressNucMask = compressBinaryImg(cat(1, properties.PixelIdxList)', size(nuclearMask));
    else
        imgfiles(ii).compressNucMask = [];
    end
    
    for jj = 2:length(files.ch)
        imgfiles(ii).smadfile{jj-1} = imgfiles.nucfile;
    end
 end
 toc;
%
save(outputFile, 'peaks', 'imgfiles', '-append');
%%
% % get relative coordinates for all image positions.
channel = 1; %Use DAPI channel.
parrange = 115;
[acoords, fullIm] = alignPanelsgetAcoords(imagesPath, files, bIms, channel, quadrant, parrange);
figure; imshow(fullIm,[]);
%%
% save everything - peaks, acoords, imgfiles, dims, userParam, bIms in an output file
dims = [files.posX(quadrant), files.posY(quadrant)];

global userParam;
paramfile = 'setUserParamsapnailastik1';
eval(paramfile);

save(outputFile, 'files', 'peaks', 'acoords', 'imgfiles', 'dims', 'bIms', 'userParam', 'imagesPath', 'quadrant', '-append');
%%
% first attempt at making colonies.
mm = 0;
nIms = ones(1024);
[colonies, ~, ~] = peaksToColoniesLSM(outputFile,mm);
plate1 = plate(colonies,dims,'',files.ch,bIms, nIms, outputFile);
plate1.mm = 0;
plate1.si = [1024 1024];
save(outputFile, 'plate1', '-append');
%%
mkFullCytooPlot(outputFile, 1);

end