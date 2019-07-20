function [rA, rAerr, rAerr1, cellsinbin, cellserr, dmaxnew]=radialAverageFromPeaks(peaks1,colinds,column,ncolumn,binsize,rollSize, dapiNorm, tooHigh) %-SC

rA=zeros(binsize*100/binsize,1); rA2=rA; counter=rA; dmaxnew =0;  bincolonies = rA; counter2 = rA;
for ii=1:length(colinds)
    [rAnow, cibnow, dmax]=radialAverageFromPeaksOneColony(peaks1, colinds(ii),column,ncolumn,binsize, rollSize, dapiNorm, tooHigh);
    npoints=length(rAnow);
    if npoints > length(rA)
        continue;
    end
    rA(1:npoints)=rA(1:npoints)+rAnow.*cibnow;
    rA2(1:npoints)=rA2(1:npoints)+rAnow.*rAnow.*cibnow;
    counter(1:npoints)=counter(1:npoints)+cibnow;
    counter2(1:npoints)=counter2(1:npoints)+ cibnow.*cibnow;
    bincolonies(1:npoints) = bincolonies(1:npoints)+ 1;
    
    if (dmax>dmaxnew)
        dmaxnew = dmax;
    end
    
end

rA=rA./counter;
rA2=rA2./counter;
rAerr=sqrt(rA2-rA.*rA);
samplesize = length(colinds);
rAerr1=rAerr./sqrt(samplesize); %standard error.
badinds=isnan(rA);
rA(badinds)=[]; rAerr(badinds)=[]; rAerr1(badinds) = [];
counter(badinds) = [];
bincolonies(badinds) = [];
counter2(badinds) = [];
cellsinbin = counter./bincolonies;
avgcells2 = counter2./bincolonies;

cellserr = sqrt(avgcells2-cellsinbin.*cellsinbin);

end
