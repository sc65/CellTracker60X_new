function ff = readFISHdir(direc, diffsamples)

%%

%direc: nuc chnnel image directory
%diffsamples: number of different samples/conditions. Each separate
%chip/dish refers to a separate sample.

%%

for i = 1:diffsamples
    ff.samples(i) = i;
    
    
    prefix = sprintf('fish%02d',i);
    
    clear filesnew z_indices;
    
    filesnew = dir([direc filesep strcat(prefix, '_*tif')]);
        
    
    nImagesnew = length(filesnew);
    
    lastImagenew = filesnew(nImagesnew).name;
    
    positioncheck_exp = '_f';
    
    f_index = regexp(lastImagenew, positioncheck_exp);
    
    if isempty(f_index)
        positioncheck_exp = '_m';
        f_index = regexp(lastImagenew, positioncheck_exp);
    end
    
    f_indexn = str2num(lastImagenew(f_index+2:f_index+5));
    
    ff.positions(i) = f_indexn+1;
    
    for j = 1:f_indexn+1
        posname  = strcat(positioncheck_exp, sprintf('%04d', j-1));
        posnew = dir([direc filesep prefix strcat(posname, '*')]);
        nimages = length(posnew);
        pos_lastimage = posnew(nimages).name;
        
        z_index = regexp(pos_lastimage, '_z');
        z_indexn = str2num(pos_lastimage(z_index+2: z_index+5));
        
        z_indices(j) = z_indexn+1;
        
        
    end
    
    ff.zslices{i} = z_indices; %if each position has a different number of
    %z slices, uncomment this, and comment out the following line. 
    
    %ff.zslices(i) = unique(z_indices); 
end


end