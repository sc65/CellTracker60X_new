
%%
sampleDir = '/Volumes/sapnaDrive2/190225_checkBMPActivity/smad4cells_20190225_50003 PM';
files = readAndorDirectory(sampleDir);

%%
saveInDir = '/Volumes/sapnaDrive2/190225_checkBMPActivity/maxZ';
mkdir(saveInDir);
% make maxz files, background subtract, save.
for ii = files.p
    newFile = [saveInDir filesep 'position' int2str(ii+1) '.tif'];
    dapiFile = [saveInDir filesep 'position' int2str(ii+1) '_ch1.tif'];
    
    for jj = files.w
        maxZ = andorMaxIntensity(files,ii,0,jj);
        maxZ = SmoothAndBackgroundSubtractOneImage(maxZ);
        
        if jj == 0
            imwrite(maxZ, newFile);
            imwrite(maxZ, dapiFile);
        else
            imwrite(maxZ, newFile, 'WriteMode', 'append');
        end
    end
    
end


% make nuclear masks, read files,masks quantify.

