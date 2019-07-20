function [pnuc, inuc] = readmaskfiles(maskno, segfile, rawfile, dirinfo, dirinfo1,  nzslices, imageno)

% reading masks
m = 1;
for i = maskno:maskno+nzslices-1
    filename = strcat(segfile,'/', dirinfo(i).name);
    file = h5read(filename, '/exported_data');
    
    nmask1 = squeeze(file(1,:,:));
    nmask2 = squeeze(file(2,:,:));
    nmask1_zero = find(nmask1 ==0);
    nmask2_zero = find(nmask2 == 0);
    
    %if(numel(nmask1_zero)> numel(nmask2_zero))
        %pnuc(:,:,m) = nmask1;
    %else
        pnuc(:,:,m) = nmask2;
    %end
    pnuc(:,:,m) = pnuc(:,:,m)';
    m = m+1;
end


% reading raw data
m1 = 1;
for j = imageno:imageno+nzslices-1
    filename = strcat(rawfile, '/', dirinfo1(j).name);
    inuc(:,:,m1) = imread(filename);
    m1 = m1+1;
end
end

%%
%
