%%
%----------common for both quadrants imaged--------
clearvars;
masterFolder = '/Volumes/sapnaDrive2/withEleana/180924_bCat_T_shapes/rawData';
imagesFolder=  [masterFolder filesep '44h'];
samples = {'180921_bCatT_shapes_q3', '180923_bCatT_shapes_q124'};
channels = {'DAPI', 'T', 'bCatenin'};
mRNA_channel = 0;
%% ---------  making maxZDapi images for all timePoints --------------
% independant of peaks.
tic;
for ii = 1:numel(samples)
    imagesPath1 = [imagesFolder filesep samples{ii}];
    makeMaxZDapi(imagesPath1, channels);
end
toc;
%% ------------- making peaks for a sample -------------
for ii = 2
%for ii = 1:length(samples)
    samplePath = [imagesFolder filesep samples{ii}];
    logfile = 'MATL_Mosaic.log';
    files = readLSMmontageDirectory(samplePath, logfile, channels);
    ilastikMasksPath = [samplePath filesep 'DAPImaxZ'];
    mkdir([samplePath filesep 'outputFiles'])
    %%
    tic;
    %------define a new output file for each quadrant------
    for quadrant = 1:numel(files.images)
    %for quadrant = 1:numel(files.images) % different groups imaged in 1 imaging session.
        outputFile = [samplePath filesep 'outputFiles' filesep 'output_' int2str(quadrant) '.mat'];
        makePeaksLSM(samplePath, ilastikMasksPath, files, quadrant, outputFile, mRNA_channel);
    end
    toc;
end

%%








