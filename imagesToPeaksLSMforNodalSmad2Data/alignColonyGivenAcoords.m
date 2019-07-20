


imnums=obj.imagenumbers;
firstimage = min(imnums);
firstcolumn= firstimage:dims(1):(firstimage+dims(1)*100);
endfirstcolumn = firstcolumn(find(ismember(firstcolumn,imnums),1,'last'));
coord2 = (endfirstcolumn-firstimage)/dims(1)+1;
coord1 = length(imnums)/coord2;
ac=obj.imagecoords;
nucpixall = [];

%%
logfile = 'MATL_Mosaic.log';
files = readLSMmontageDirectory(direc, logfile);
tmp1=zeros(1024);
si=size(tmp1);
fullImage = cell(1,3);

for jj = 1:3

fullImage{jj}=uint16(zeros(si(1)*coord2,si(2)*coord1));

for ii=1:length(imnums)
    
    
    over1=floor((imnums(ii)-firstimage)/dims(1));
    over2=imnums(ii)-firstimage-dims(1)*over1;
    
    %calculate alignment
    currinds=[over1*si(1)+1 over2*si(2)+1];
    for kk=1:over1
        currinds(1)=currinds(1)-ac(ii-(kk-1)*dims(1)).wabove(1);
    end
    for mm=1:over2
        currinds(2)=currinds(2)-ac(ii-mm+1).wside(1);
    end
    
    
    image1dir = [direc filesep sprintf('Track%04d', imnums(ii))];
    image1info = dir([image1dir filesep '*.oif']);
    image1path = [image1dir filesep image1info.name];
    currimg = getMaxZ(image1path, jj);
    
    
    %background subtraction
    if exist('backIm','var')
        currimg=imsubtract(currimg,backIm{jj});
    end
    if exist('normIm','var')
        newIm=immultiply(im2double(currimg),normIm{jj});
        newIm=uint16(65536*newIm);
    else
        newIm=currimg;
    end
    
    fullImage{jj}(currinds(1):(currinds(1)+si(1)-1),currinds(2):(currinds(2)+si(2)-1))=newIm;
   
end
 
end
%%
% DAPI, Nodal
im1 = cat(3, imadjust(fullImage{2}), zeros(size(fullImage{1})), imadjust(fullImage{1}));
figure; imshow(im1);
%%
% SMAD@, Nodal.
im2 = cat(3, zeros(size(fullImage{1})), imadjust(fullImage{3}),  imadjust(fullImage{1}));
figure; imshow(im2);
%%
% SMAD2, Nodal.
im3 = cat(3, imadjust(fullImage{2}), imadjust(fullImage{3}), zeros(size(fullImage{1})));
figure; imshow(im3);











