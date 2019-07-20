%clear all;
dir1 = '.';
nch = 2; % channel no. to be analysed
sample_num = 23;  % no. of different samples
positions = [1 25 10 10 25 25 12 12 15 25 15 15 15 20 15 12 4 15 25 25 15 15 12];
z1 = [14 14 14 14 21 15 10 8 12 14 14 14 14 17 20 14 14 14 18 14 14 14 14];

negative_sample = 1;

for i = 1:sample_num
    sample_names{i} = sprintf('sample%d', i);
end

%% Quantifying mRNA 
% Note: each section below can be run only after the previous one has been
% run.
% 
%Spatzcell code begins!
tic;

%TestSpotThreshold(dir1, z1, pos, sn, nch, sname);
RunSpotRecognitiontest(dir1, z1, positions, sample_num, nch, sample_names);
toc;

%or
%Run Spatzcells.
dir1 = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/Cher/161010BetaCatCellsDkk1/SpatzcellsFormat';

tic;
for ii = 1:3
    for jj = 1:2
        samplenum = ii;
        framenum = jj;
        RunSpotRecognitiontestcluster(dir1,paramfile, samplenum, framenum);
    end
end
toc;
%%
global userParam;
setParamFish;

nch = userParam.nch; %channel quantified.
z1 = userParam.z1;
sample_num = userParam.sn; %total number of different samples.
positions = userParam.pos; %number of positions imaged for each sample.
sample_names = userParam.sname;

negative_sample = 2;
spot_threshold = 40; %threshold for false positive spots. 

dir1 = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/Cher/161010BetaCatCellsDkk1/SpatzcellsFormat';
GroupSpotsAndPeakHistsTest(dir1, z1, positions, sample_num, nch, negative_sample, sample_names, spot_threshold);

%%
GetSingleMrnaIntTest(dir1, z1, positions, sample_num, nch, sample_names);
GroupCellSpotsTest(dir1, z1, positions, sample_num, nch, sample_names);
%%
spotinfo(dir1, nch, sample_num)

%%
