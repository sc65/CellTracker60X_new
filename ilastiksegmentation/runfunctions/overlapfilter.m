function [nucleinmod, masterCCnmod]  =  overlapfilter(PILsn, PILsSourcen, masterCCn, nuclein1, Inuc, zrange, overlapthresh, imview)
% pixel intersection matrix

%zlim = zstart:zend;
zstart = zrange(1);
zend = zrange(end);
nobj = size(nuclein1,1);
p_intmat = zeros(nobj);

PILsnmod = PILsn;
masterCCnmod = masterCCn;
PILsSourcenmod = PILsSourcen;


for i = 1:nobj
    for j = 1:nobj
        p_intmat(i,j) = nnz(ismember(PILsnmod{i}, PILsnmod{j}))/numel(PILsnmod{i});
    end
end

%%

%separate overlapping objects
clear rwcl r c
[r, c] = find(p_intmat > overlapthresh);
rwcl = [r c];
m = 1;


% remove the diagonals.


%%
% find symmetrically overlapping objects
% rcnew saves the rows that should be deleted
if(~isempty(rwcl))
    rwcl = rwcl(rwcl(:,1) ~= rwcl(:,2),:);
    m = 1;
    lim1 = size(rwcl);
    rowno = 1;
    i = 1;
    [elementr, elementc] = find(rwcl(:,1) == rwcl(i,2));
    
    while(i<lim1)
        
        if(~ isempty(elementr))
            if(rwcl(elementr, 2) == rwcl(i,1))
                ol1 = p_intmat(rwcl(i,1), rwcl(i,2));
                ol2 = p_intmat(rwcl(i,2), rwcl(i,1));
                
                if(ol1>ol2)
                    rcnew(m,:) = [rwcl(i,2), rwcl(i,1)];
                    rdel = i;
                else
                    rcnew(m,:) = [rwcl(i,1), rwcl(i,2)];
                    rdel = find(rwcl(:,1) == rwcl(i,2));
                end
                
                rwcl(rdel,:) = [];
                m = m+1;
            end
        end
        
        lim1 = size(rwcl,1);
        i = i+1;
        if(i<lim1)
            rowno = i;
            [elementr, elementc] = find(rwcl(:,1) == rwcl(i,2));
        end
    end
end
%%
% deleting pixels corresponding to a repeated object
if(exist('rcnew', 'var'))
    for i = 1:size(rcnew,1)
        ovlappxl = intersect(PILsnmod{rcnew(i,1)}, PILsnmod{rcnew(i,2)});
        PILsnmod{rcnew(i,1)} = [];
        masterCCnmod.PixelIdxList{rwcl(i,1)} = [];
        PILsSourcenmod(rcnew(i,1)) = [];
        nuclein1(rcnew(i,1),:) = [];
    end
end
masterCCnmod.PixelIdxList = masterCCnmod.PixelIdxList(~cellfun('isempty',masterCCnmod.PixelIdxList));
masterCCnmod.NumObjects = size(masterCCnmod.PixelIdxList,2);
PILsnmod = PILsnmod(~cellfun('isempty', PILsnmod));
%%
masterLntr = labelmatrix(masterCCnmod);

rgbLntr = label2rgb(masterLntr, 'jet', 'k', 'shuffle');
overlayntr = zeros(size(rgbLntr));
for c1 = 1:3
    overlayntr(:,:,c1) = 0.5*mat2gray(rgbLntr(:,:,c1)) +...
        mat2gray(sum(Inuc(:,:,zstart:zend),3));
end

%%
nucleinmod = nuclein1;
ncells = masterCCnmod.NumObjects;

if(imview)
    figure; imshow(overlayntr)
    figure; imshow(masterLntr, []);
end

