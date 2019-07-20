function setUserParam_rnaSeq_test

global userParam
%% specify input-output paths
% input 
userParam.workingDir = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments'; 
userParam.rawData = 'rnaseqData';
userParam.genomeIndexSTAR = 'STARindex';
userParam.genomeIndexRSEM = 'RSEMindex';
userParam.STAR = '/home/sc65/STAR-2.5.4b/bin/Linux_x86_64_static/STAR';
userParam.RSEM = '/home/sc65/RSEM-1.3.1';

% output 
userParam.starOutput = 'rnaseqData2/alignmentSTAR';
userParam.rsemOutput = 'rsemOutput_test';

% jobscripts
userParam.jobscripts = 'jobscripts';