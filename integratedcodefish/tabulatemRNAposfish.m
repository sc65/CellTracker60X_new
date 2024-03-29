function tabulatemRNAposfish (dir1, sn, ch, Nucmask, errorstr, nucfile, smadfile, cen)
%sn: no. of samples
%n_ch = Channels to be analysed

cen = [];
%%
imno = 1;
dir = dir1;

for i = 1:length(ch)
file  =  sprintf('/spots_quantify_t7ntch%d/data/FISH_spots_data_new.mat', ch(i));
ldfile{i} = strcat(dir1, file);
load (ldfile{i});
csi{i} = enlistcell_new;
om{i} = One_mRNA;
end

mresultfold = ([dir '/results']);
mkdir(mresultfold);


%%
%sno = 1;
for sno = 1:sn
clear finalmat csi_ch csi_f;   

resultfold = sprintf('/sample%dresults', sno);
mkdir([mresultfold resultfold]);
iinf = 0;


for nch= 1:length(ch)
csi_ch{nch} = csi{nch};
csi_f{nch} = csi_ch{nch}(sno);
end

finalmat(:,1:2) = [csi_f{1}{1}(:,2), csi_f{1}{1}(:,1)];

col_no = 3;
for nch = 1:length(ch)
    finalmat(:,col_no) = [floor(csi_f{nch}{1}(:,4)/om{nch})];
    col_no = col_no + 1;
end
%%
% peaks contains required details of all the cells in one sample. 
% Column 1: x position of cell's centroid
% Column 2: y position of cell's centroid 
% Column 3: No. of mRNA's identified in channel 1
% Column 4: No. of mRNA's identified in channel 2
% Column 5: No. of mRNA's identified in channel 3
% 
% finalmat is then saved in a mat file: sample(sampleno)results.mat under
% the variable name finalmat.


%%

frames = unique(finalmat(:,1));
jstart = frames(1);
jlim = frames(end);

fmstart = 1;
for j1 = jstart:jlim
  clear s;  
  
  nrow = length(find(finalmat(:,1) == j1));
 
  if( j1 == jstart)
      k = nrow;
  else
      k = k+nrow;
  end
  
  
  filen = sprintf('fishseg%02d', j1); %change to fishseg later
  filenld = strcat(dir,'/masks/', filen);
  load (filenld);
 
  s = regionprops(LcFull, 'Centroid');

for i = fmstart:k

    finalmat(i,col_no:col_no+1) = s(finalmat(i,2)).Centroid;
   
end

   fmstart = k+1; 
    
end
%%
 nsubfiles = length(frames);
 pos(sno) = nsubfiles;
    
    for j = 1:nsubfiles
        matnew{j} = finalmat(finalmat(:,1) == frames(j),:);
        
        col = size(matnew{j},2);
        row = size(matnew{j},1);
        
        fch = col-4;
        
        newmat{j} = zeros(row,col-2);
        newmat{j}(:,1) = matnew{j}(:,end-1); %x value
        newmat{j}(:,2) = matnew{j}(:,end); %y value
        ch1 = 3;
        
        for k = 3:2+fch
            newmat{j}(:,k) = matnew{j}(:,ch1);
            ch1 = ch1+1;
        end
        
     filennew = sprintf('output%02d.mat', iinf);  
     filenews = strcat(mresultfold,resultfold,'/', filennew);
     
     
     peaks = newmat{j};
     
     imgfiles.compressNucMask = Nucmask{imno};
     imgfiles.errorstr = errorstr{imno};
     imgfiles.nucfile = nucfile{imno};
     imgfiles.smadfile = smadfile{imno};
     save(filenews, 'peaks','imgfiles');
     imno = imno+1;
     iinf = iinf + 1;
     
    end
end
        
%centercentroid(cen, dir1, pos, sn);


