
function setParamFish 

%%
% sn : no. of samples
% nch: channel to be analysed (if you want to count spots for channel 3,
% then nch = 3)
% z1: no. of z slices for each sample
% pos: no. of positions for each sample
% nframes: total no. of distinct positions in all samples.

global userParam;

userParam.sn = 3;
userParam.pos = [2 2 2];
userParam.z1 = [11 16 7 8 17 13];
userParam.nch = 1;


for i = 1:userParam.sn
    userParam.sname{i} = sprintf('sample%d', i); 
end

