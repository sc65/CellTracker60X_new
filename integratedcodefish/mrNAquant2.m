
dir1 = '.';
dirinfo = dir(dir1);


nelem = size(dirinfo, 1);

%%
% determining the first proper file name

for i = 1:nelem
    fn = dirinfo(i).name;
    
    if(fn(1)~= '.')
        start = i;
        break;
    end
end

%%
path = pwd;
m = 1;

for i = start:nelem
    dir2 = strcat(path,'/', dirinfo(i).name,'/');
    dir3 = dir(dir2);
    
    nelemn = size(dir3, 1);
    
    for j = 1:nelemn
    fn = dir3(j).name;
    
       if(fn(1)~= '.')
        startn = j;
        break;
       end
    end
    
    for i2 = startn:nelemn
        filen = strcat(dir2, '/', dir3(i2).name);
        load(filen);
        ch11(m) = peaks(1,3);
        ch22(m) = peaks(1,4);
        ch33(m) = peaks(1,5);
         m = m+1;
    end
   
end

  
%%
    ch11n = floor(m4.*(ch11./m3));
    ch22n = floor(m4.*(ch22./m3));
    ch33n = floor(m4.*(ch33./m3));

%%
 ch = [{ch11}, {ch22}, {ch33}];
 chn = [{ch11n}, {ch22n}, {ch33n}];
 
 for i = 1:size(chn,2)
     
     figure; bar(chn{i}, 0.5);
     figure; bar(ch{i}, 0.5);
 end
 
 %%
 % Different color bar plots with legends for each sample.
 cc = 'kkkkkbbbbbrrrrr';
 j = 1;
 
 for i=1:15
     
         h(1) = bar(i, chn{3}(i), 0.5, cc(i));
         hold on;
     elseif(i>5 && i<11)
         h(2) = bar(i, chn{3}(i), 0.5, cc(i));
         hold on;
     else
         h(3) = bar(i, chn{3}(i), 0.5, cc(i));
         hold on;
     end
     
         
 end
 
 legend([h(1), h(2), h(3)], 's1', 's2', 's3');
 
 
 