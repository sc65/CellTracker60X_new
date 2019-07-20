function AndorMontageTile(listOfFolderNames, sn, pos)


%% merge results

for i = 2:sn+1
    direc = listOfFolderNames{i+1};

for ii=0:pos(i-1)
   
    filename = [sprintf('results/sample%01dresults/output%02d',i, ii)  '.mat'];
    load(filename);
    peaksall{ii+1}=peaks;
    imgall(ii+1)=imgfiles;
end

peaks = peaksall;
imgfiles = imgall;

outfile = [ direc filesep 'outall.mat'];
save(outfile,'peaks','imgfiles');

%% do the alignment and save
dims = [4 3];
[acoords, dapi]=alignManyPanelsAndorZstackMontage(direc,dims,0,150:520);
save(outfile,'acoords','dims','-append');
%% get pictures for other channels
[~,c1]=alignManyPanelsAndorZstackMontage(direc,dims,1,150:520,acoords);
[~,c2]=alignManyPanelsAndorZstackMontage(direc,dims,2,150:520,acoords);
[~,c3]=alignManyPanelsAndorZstackMontage(direc,dims,3,150:520,acoords);
%% set the alphavol parameter
userParam.alphavol = 300;
save(outfile,'userParam','-append');
%% generate the colony object
[colonies, peaks]=peaksToColonies(outfile,0);
%% check that the data is put together correctly
imshow(dapi,[]); hold on;
plot(colonies.data(:,1),colonies.data(:,2),'r.');
%% reassemble the images directly from the colony. overlay with data. note these will
% work to show images of 1 colony even the tiling contains many colonies.
fullIms = colonies(1).assembleColonyAndor(direc,dims);
figure; imshow(fullIms{1},[]); hold on; plot(colonies.data(:,1),colonies.data(:,2),'r*');
end
