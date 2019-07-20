%% ------------- For images of a micropatterned chip taken on epi at 10X--------------

% From ilastik mask to peaks and then colonies.

% select a good position with a lot of cells.
% check ilastik segmentation.
% read masks
% get stats
% make peaks
% make colonies
%extract information from bigtiff
%save variable acoords in output file.

clearvars -except metadata;
rawImagesPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/160804_CirclesIF/MMformat';
% path corresponding to bigtiff(btf)/vsi files - images of entire chip. taken on epi 10X.

mmImagesPath = '/Volumes/sapnaDrive2/181213_leftyRemoval_35h_60h/wholeChips/mmImages';

ff = strcat('Process_' , strsplit(int2str([329 370:374]),' '), '.vsi');

% global userParam;
% paramfile = 'setUserParamsapnailastik1'; % standard file for mm chip analyses
% eval(paramfile);

%% -------------------------- Part1: get files in the micro manager format
tic;
for ii = 2
%for ii = 1:length(ff)
    rawImageFile = [rawImagesPath filesep ff{ii}];
    mmFilesPath = [mmImagesPath filesep 'MMdirec' int2str(ii)];
    mkdir(mmFilesPath);
    
    outputFile = ['output' int2str(1) '.mat'];
    outputFilePath = strcat(mmFilesPath, filesep, outputFile);
    
    %convert the big tiff file to Micro Manager(MM) format.
    acoords = olympusToMM_new(mmFilesPath, rawImageFile); %relative coordinates of images.
    %check if the relative coordinates of images are correct.
    %get information about the new file
    
    files = readMMdirectory(mmFilesPath);
    fullImage = StitchPreviewMM(files, acoords, channels);
    figure; imshow(fullImage,[]); title(ff{ii});
    
    save(outputFilePath, 'acoords');
end
toc;
%% ---------------------------- Part 2:  run ilastikmmbatchprocess.sh to get ilastik masks  - go to the terminal %%

%% ------------------ Part 3: run this part to make structure plates --------------
tic;
%for ii = 2
for ii = 3:length(ff)
%for ii = 1:length(btfImagesPath)
    ii
    mmFilesPath = [mmImagesPath filesep 'MMdirec' int2str(ii)]; % for multiple samples in same experiment
    %mmFilesPath = [btfImagesPath{ii} filesep 'MMdirec1']; % for different experiments
    
    files = readMMdirectory(mmFilesPath);
    
    outputFile = 'output1.mat';
    
    outputFilePath = strcat(mmFilesPath, filesep, outputFile);
    load(outputFilePath);
    
    tic;
    [peaks, imgfiles] = ImagesToPeaks(mmFilesPath, files);
    toc;
    %%
    %peaks to colonies
    dIms = [(length(files.pos_x)) (length(files.pos_y))]; %number of rows and columns imaged.
    bIms = zeros(2048);
    nIms = ones(2048);
    [colonies, peaks] = peaksToColoniesIlastik(peaks, acoords, imgfiles,  dIms, userParam);
    %%
    % colonies to plate
    save(outputFilePath, 'acoords', 'peaks','userParam','imgfiles', 'dIms', 'bIms', 'nIms');
    %%
    plate1 = plate(colonies,dIms,mmFilesPath,files.chan,bIms, nIms, outputFile);
    plate1.mm = 1;
    plate1.si = [2048 2048];
    %%
    goodColonies = find([colonies.ncells] > 100 & [colonies.ncells] < 5000); %filter based on cell number
    save(outputFilePath, 'plate1', 'goodColonies', '-append');
    mkFullCytooPlot(outputFilePath, 1); %check if everything is correct.
    
end
toc;


