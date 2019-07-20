function [colonies, peaks]=peaksToColoniesIlastik(peaks, acoords, imgfiles,  dims, userParam)
% returns individual colonies and modified peaks information for the chip.


mm = 1; % data is in micro manager format. So, mm is always 1.


if any(dims > 1)
    peaks=removeDuplicateCells(peaks,acoords);
end


k1=num2cell(ones(1,length(peaks)));
lens=cellfun(@size,peaks,k1);
totcells=sum(lens);

%get number of columns from first non-empty image
q=1; ncol=0;
while ncol==0
    if ~isempty(peaks{q})
        ncol=size(peaks{q},2);
    end
    q=q+1;
end

% peaks contains segmented cells for each image
% combine peaks from all images in one big array
% allocate array:
alldat=zeros(totcells,ncol+1);

% combine:
q=1;
for ii=1:length(peaks)
    if ~isempty(peaks{ii})
        currdat=peaks{ii};
        toadd=[acoords(ii).absinds(2) acoords(ii).absinds(1)];
        currdat(:,1:2)=bsxfun(@plus,currdat(:,1:2),toadd);
        alldat(q:(q+lens(ii)-1),:)=[currdat ii*ones(lens(ii),1)];
        q=q+lens(ii);
    end
end
pts=alldat(:,1:2);



disp('Running the alphavol-based colony grouping');
[~, S]=alphavol(pts,userParam.alphavol);% this line was modified
groups=getUniqueBounds(S.bnd);   % S.bnd - Boundary facets (Px2 or Px3)

allinds=assignCellsToColonies(pts,groups);
alldat=[alldat full(allinds)];

%Make colony structure for the alphavol algorythim
for ii=1:length(groups)
    cellstouse=allinds==ii;
    colonies(ii)=colony(alldat(cellstouse,:),acoords,dims,[],imgfiles,mm);
end

%put data back into peaks
for ii=1:length(peaks)
    cellstouse=alldat(:,end-1)==ii;
    peaks{ii}=[peaks{ii} alldat(cellstouse,end-1:end)];
    
    if(~isempty(peaks{ii}))
        
        newcell = peaks{ii};
        
        c1 = newcell(:,5) == newcell(:,6);
        c2 = newcell(:,6) == newcell(:,7);
        
        c_all = c1&c2;
        
        if(unique(c_all ~= 0))
            newcell(c_all,:)
            error('Error.\Caught red handed, %d ', ii);
        end
        
        clear newcell;
    end
end




end




