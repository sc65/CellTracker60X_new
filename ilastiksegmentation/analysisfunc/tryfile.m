%%
% are the ncells and mrnaresults correct?
% check the original images to see if the number of cells/objects
% identified make sense

segfiledir = '/Volumes/data/Sapna/150813FISH_MP/200um/im1seg'; % ilastik probability maps
rawfiledir = '/Volumes/data/Sapna/150813FISH_MP/200um/images00'; % raw data
outfile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/150813FISHMP/200um/output.mat';

nzslices = 16;
colonyno = 1;
objno = [13 19 71 115 130];
peaks = runmaskone(segfiledir, rawfiledir, nzslices, colonyno, objno);
%%
tic;
runmaskdir(segfiledir, rawfiledir, nzslices, outfile);
toc;

%%

[dirinfo, start] = readdirectory(segfiledir);
[dirinfo1, start1] = readdirectory(rawfiledir);

nzcells = 16;

for i = start1:nzcells:size(dirinfo1,1)
    m = 1;
    for j = i:i+nzcells-1
        im(:,:,m) =  imread(strcat(rawfiledir, '/', dirinfo1(j).name));
        m = m+1;
    end
   
    figure; imshow(mat2gray(sum(im(:,:,1:nzcells),3)));
end

%%
% mrna bar graphs and histograms for all colonies
i = 4;
figure; bar(mrnapcell{i},0.5);
xlabel('Cells', 'FontSize', 14);
ylabel('No. of mrna', 'FontSize', 14);

figure; hist(mrnapcell{i});
xlabel('No. of mrna', 'FontSize', 14);
ylabel('No. of cells', 'FontSize', 14);

%%



