
%%
saveInFile = '/Volumes/sapnaDrive2/190713_FiguresData/Figure5.mat';
%% %% ------------- Figure 5J
masterFolder = '/Volumes/SAPNA/190405_liveCell_bCat';
metaFile = [masterFolder filesep 'metadata.mat'];
outputFile = [masterFolder filesep 'output.mat'];
load(outputFile);
%%
Fig5J.Control = (squeeze(rA_colonies1(:,:,1:7)))';
Fig5J.SB_0h = (squeeze(rA_colonies1(:,:,8:14)))';
Fig5J.bins = bins;
%%
save(saveInFile, 'Fig5J');
%%
%% -------------- Figure 5E

outputFile1 = '/Volumes/SAPNA/180304_bCat_liveCellImaging_IWR_IWP2/output.mat'; % LDN treatment
load(outputFile1);
%%
Fig5E.Control = permute(rA_colonies1(:,:,colonyIds{2}), [3 2 1]);
Fig5E.IWP2_15h = permute(rA_colonies1(:,:,colonyIds{3}), [3 2 1]);
Fig5E.IWP2_30h = permute(rA_colonies1(:,:,colonyIds{1}), [3 2 1]);
Fig5E.bins = bins;
Fig5E.threshold = threshold;
%%
timepoints = from_ImagingTimepoints_to_timeInHrs(1:105);
%%
Fig5E.timeInHrs = timepoints;
%%
saveInFile = '/Volumes/sapnaDrive2/190713_FiguresData/Figure5.mat';
save(saveInFile, 'Fig5E', '-append');
%%

%% -------------- Figure 5A
outputFile1 = '/Volumes/sapnaDrive2/18055bCatLivecell/output_new.mat'; % LDN treatment
load(outputFile1);
%%
Fig5A.Control = permute(rA_colonies1(:,:,colonyIds{1}), [3 2 1]);
Fig5A.LDN_23h = permute(rA_colonies1(:,:,colonyIds{2}), [3 2 1]);
Fig5A.LDN_11h = permute(rA_colonies1(:,:,colonyIds{3}), [3 2 1]);
Fig5A.LDN_0h = permute(rA_colonies1(:,:,colonyIds{4}), [3 2 1]);
Fig5A.threshold = threshold;
%%
timepoints = from_ImagingTimepoints_to_timeInHrs(1:88);
%%
Fig5A.timeInHrs = timepoints;
%%
save(saveInFile, 'Fig5A', '-append');




