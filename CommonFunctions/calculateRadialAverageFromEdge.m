function [rA, rAerr, xValues] = calculateRadialAverageFromEdge(plate1, coloniesToUse, fChannels, ...
    nChannel,binSize, rollSize, dapiNorm, umToPixel, tooHigh)
%% returns the radial Average (rA) and standard error in rA(rAerr) for colonies, specified by colony number(s) coloniesToUse,
% rA - column vector, each column - radial average for one channel.
% xValues - Distance from the edge for each bin.
%% ---------- Input ---------------
% fChannels - columns corresponding to fluorescent channels.
% nChannel - column corresponding to normalization channel, usually DAPI.
% binSize - size in pixels across which radial average is calculated.
% tooHigh - max fluorescence value for each channel.
%%

rA = zeros(100, numel(fChannels));
rAerr = rA;
m = 1;
for jj = fChannels
    
    if iscell(plate1) 
        [rA1, ~, rAerr1, ~, ~, dmax] = radialAverageFromPeaks(plate1, coloniesToUse,jj,nChannel,binSize,rollSize, dapiNorm, tooHigh(m));
    else
        [rA1, ~, rAerr1, ~, ~, dmax] = plate1.radialAverageOverColonies(coloniesToUse,jj,nChannel,binSize,rollSize, dapiNorm);
    end
    
    rA(1:size(rA1,1),m) = rA1;
    rAerr(1:size(rA1,1), m) = rAerr1;
    m = m+1;
end

deleteRows = find(all(rA==0,2));
rA(deleteRows,:) = [];
rAerr(deleteRows,:) = [];


xlimit = dmax/umToPixel; 
xstart = binSize/(2*umToPixel);
xValues = linspace(xstart,xlimit, size(rA,1));
end