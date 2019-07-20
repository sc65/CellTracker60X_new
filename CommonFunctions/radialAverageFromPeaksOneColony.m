function [rA, cellsinbin, dmax]=radialAverageFromPeaksOneColony(peaks1, Id,column,ncolumn,binsize, rollSize, dapiNorm, toohigh)
% calculates rolling radial average of cells from the colony edge.
% ---- peaks - cell array, each cell represents a distinct colony.

% if DAPI values across colonies in same timepoint are
% highly variable, normalise those values such that dapi values fall between [0 1].
% dapiNorm = 1;

data = peaks1{Id};
if dapiNorm
    data(:, ncolumn) = data(:,ncolumn)./mean(data(:,ncolumn));
end


%get the distance from the boundary using bwdist. -SC
colmax=max(data(:,1:2));
mask=false(ceil(colmax(1))+10,ceil(colmax(2))+10);
inds=sub2ind(size(mask),ceil(data(:,1)),ceil(data(:,2)));
mask(inds)=1;
mask=bwconvhull(mask);
distt=bwdist(~mask);
dists=distt(inds);

dmax=max(dists);

cellsinbin=zeros(ceil(dmax/binsize),1); rA=cellsinbin;
q=1;

jjValues  = [0:rollSize:dmax-binsize]; %use the roll size to calculate the lower bound for jj values.
for jj=jjValues
    if jj == jjValues(end)
        inds= dists >= jj & dists < dmax;
    else
        inds= dists >= jj & dists < jj+binsize;
    end
    if sum(inds) > 0
        
        if column == 12
            dat = data(inds,column)+data(inds, column+1); %adding cytoplasmic values.
        else
            dat = data(inds,column);
        end
        
        
        if exist('toohigh','var')
            nogood = dat > toohigh;
        else
            nogood = false(size(dat));
        end
        
        %Normalise with DAPI values.
        
        ndat=data(inds,ncolumn);
        dat=dat./ndat;
        
        
        rA(q)=meannonan(dat(~nogood));
        cellsinbin(q)=sum(inds)-sum(nogood);
        
        
    else
        rA(q)=0;
        cellsinbin(q)=0;
    end
    
    q=q+1;
end

end