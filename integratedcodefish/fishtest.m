%%
% Make sure that the images folders do not have any subfolders 
% dir1 is the path of directory that contains images of all the samples. 
% Specify the negative sample
% Specify the negative sample threshold as percentage
% Specify the intensity threshold in the function
% 'InitializeSpotRecognitionParameterstest'.
% Tabulated mRNA results are stored in results folder in the matrix finalmat. 


%clear all;
dir1 = '.';
%dir1 = '/Users/sapnac18/Desktop/150712fishmp/imagess1/Test Sample FISH';

allSubFolders = genpath(dir1);

negsamp = 2;%%% Removing False Positives, nch = Specify the negative sample number
negperc = 90;

% Parse into a cell array.
remain = allSubFolders;
listOfFolderNames = {};
while true
	[singleSubFolder, remain] = strtok(remain, ':');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(listOfFolderNames);

sn = numberOfFolders - 1; % sn = no. of samples

%mkdir(dir1, 'masks');

%%
% z = z range (assuming it to be the same for all samples)
% pos =  no. of positions
% sn = no. of different samples (Andor stores images as one folder for
% each sample)
% sname = name of each sample
%nch = channel number to be analysed
%%
m = 1; % variable that stores mask numbers for each frame, m = 1 for frame 0, m = 2 for frame 1 and so on. 
%j = 2;
for j = 2:numberOfFolders

    clear ff;
     ff = readAndorDirectory(listOfFolderNames{j});
     pos(j-1) = length(ff.p);  %%saving parameters
     z1(j-1) = length(ff.z);
     sname{j-1} = ff.prefix;
     l = length (ff.p)-1; %% l: reference to the last position 
     st = ff.p(1);
     imch = length(ff.w)-1;
     
     %i = 0;
     for i = st:l
      
     
        
        
        %load(filen);
        
      %[LcFull]=mask60XCT(ff,i);
     %[LcFull] = mask60Xall(ff,i); % colony as one cell/ cell information not separated. 
%      filen1 = sprintf('fishseg%02d.mat', m);
%      filen = strcat(dir1, '/', 'masks/', filen1);
%      
%       %save(filen,'LcFull');
%       %close all;
%       
%       load(filen, 'LcFull');
%     
%      % Saving imagefiles to the output variable
%       Nucmask{m} = compressBinaryImg(LcFull, size(LcFull));
%       errorstr{m} = sprintf('sample%02d_pos%02d', j-1, i);
%       nucfile{m} = sprintf('sample%02d_pos%02d', j-1, i);
%       smadfile{m} = sprintf('sample%02d_pos%02d', j-1, i);
%      
       nucint2{m} = andorNucIntensity(ff, i, 0, 0); 
       m = m+1;
     end
end


%%
% Making a new folder with just fluorescent images of each channel
% Channel for calculating mRNA 

 %imch = 3;
 %imc=[1:imch]; % Channel no. to be analyzed

 imc = [0];
 %imc = 3;
 for im = 1:length(imc)
 imf =sprintf('images%02d', imc(im)); 
 mkdir(dir1, imf);
 
for k = 2 : numberOfFolders
	% Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    filePattern = sprintf('%s/*_w%04d.tif', thisFolder, imc(im));
	baseFileNames = dir(filePattern);
    nfiles = length(baseFileNames);
    
    for i = 1:nfiles
        s = strcat(thisFolder, '/', baseFileNames(i).name);
        imn =sprintf('/images%02d/', imc(im)); 
        s1 = strcat(dir1, imn);
        
        copyfile(s, s1);
        s2 = strcat(s1,baseFileNames(i).name);
        
        bo = baseFileNames(i).name;
        br = strtok(baseFileNames(i).name, '_');
        bn = sprintf('fish%01d', k-1);
        imgname = strrep(bo, br, bn);
        
        s3 = strcat(s1, imgname);
        movefile(s2,s3);
    end
end
 end
 

 


%% Quantifying mRNA 
% Note: each section below can be run only after the previous one has been
% run.
% 
%Spatzcell code begins!
tic;
nch = 0; %channel to be analysed
dir1 = '.';
z1 = [21 21 21 21 21 21 21 21 21];
pos = [1 1 1 1 1 1 1 1 1];
sn = 9;
for i = 1:sn
    sname{i} = sprintf('fish%01d', i);
end
TestSpotThreshold(dir1, z1, pos, sn, nch, sname); % to determine appropriate threshold
%RunSpotRecognitiontest(dir1, z1, pos, sn, nch, sname);
toc;
%%
nch = 1;
negperc = 90;
negsamp = 2;
z1 = [16 16 16];
pos = [10 9 4];
sn = 3;
dir1 = '.';

for i = 1:sn
    sname{i} = sprintf('sample%d', i);
end
    
%%
negperc = 50;
GroupSpotsAndPeakHistsTest(dir1, z1, pos, sn, nch, negsamp, sname, negperc);

GetSingleMrnaIntTest(dir1, z1, pos, sn, nch, sname);

GroupCellSpotsTest(dir1, z1, pos, sn, nch, sname);

%%
n_ch = [1 2 3]; % Channels that are analysed and need to be tabulated. List out all the channels that need to be tabulated.
sn = 3;
%dir1 = pwd;

%tabulatemRNAposfish(dir1, sn, n_ch, Nucmask, errorstr, nucfile, smadfile);

tabulatemRNAfishnotile(dir1, sn, n_ch);
%%
%mmRNA bar plots
 sn = 3;
 dir1 = '.';
 ncell = zeros(1,sn);
 mRNAch1 = zeros(1,sn);
 m = 1;
 
for i = 1:sn
    
    ncell(i) = 0;
    mRNAch1(m) = 0;
    
    filen = sprintf('sample%dresults', i);
    filen2 = strcat(dir1, '/', filen);
    filen3 = dir(filen2);
    
    n_output = size(filen3,1);
    
    
    for j = 3:n_output
        filen4 = strcat(filen2, '/', filen3(j).name);
        load(filen4);
        
        
        ncell(i) = ncell(i) + size(peaks,1);
        
        mRNAch1(m) =  sum(peaks(:,3));
        m = m+1;
        
    end
            
       
end


 
mbmp4 = mRNAch1(1:7);
mbmp4c = mRNAch1(1:7)./ncbmp;

mntrt = mRNAch1(20:23);
mntrtc = mntrt./ncntrt;

totmRNA = [mbmp4 mntrt];
mRNApercell= [mbmp4c mntrtc];


figure; 
bar(totmRNA);
xlab = { 'B1', 'B2','B3', 'B4', 'B5', 'B6', 'B7', 'N1', 'N2', 'N3', 'N4'};
set(gca, 'XTickLabel', xlab, 'XTick', 1:numel(xlab));
xlabel('Sample');
ylabel('mRNA')
title('Nodal', 'FontWeight', 'Bold', 'FontSize', 18);

figure; 
bar(mRNApercell);
xlab = { 'B1', 'B2','B3', 'B4', 'B5', 'B6', 'B7', 'N1', 'N2', 'N3', 'N4'};
set(gca, 'XTickLabel', xlab, 'XTick', 1:numel(xlab));
xlabel('Sample');
ylabel('mRNA per cell');
title('Nodal', 'FontWeight', 'Bold', 'FontSize', 18);



