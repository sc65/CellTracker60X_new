function setUserParam_rnaSeq

global userParam
%% specify input-output paths
% input 
userParam.workingDir = '$SHARED_SCRATCH/$USER'; 
userParam.rawData = 'rnaseqData2/rawData';
userParam.genomeIndexSTAR = 'STARindex';
userParam.genomeIndexRSEM = 'RSEMindex';
userParam.STAR = '/home/sc65/STAR-2.5.4b/bin/Linux_x86_64_static/STAR';
userParam.RSEM = '/home/sc65/RSEM-1.3.1';

% output 
userParam.starOutput = 'rnaseqData2/alignmentSTAR';
userParam.rsemOutput = 'rnaseqData2/rsemOutput';

% jobscripts
userParam.jobscripts = 'jobscripts';
