

%% make & save overview figures.
btfImagesPath = '/Volumes/SAPNA/170721mpSmad2Lefty30X/epi10X';
% path corresponding to bigtiff (btf) files - images of entire chip. taken on epi 10X.

ff = {'t24.btf', 't32.btf', 't40.btf'};
channels = [{'GFP'}, {'DAPI'}];%Channel order in which images were taken.

%%
for ii = 1:3
    epiExportedFile{1} = [btfImagesPath filesep ff{ii}];
    mmFilesPath = [btfImagesPath filesep 'MMdirec' int2str(ii)];
    
    outputFile = ['output' int2str(ii) '.mat'];
    outputFilePath = strcat(mmFilesPath, filesep, outputFile);
    
    load(outputFilePath);
  
    files = readMMdirectory(mmFilesPath);
    fullImage = StitchPreviewMM(files, acoords, channels);
    figure; imshow(fullImage,[]);
end



