function [acoords, fullIm]=alignPanelsgetAcoords(direc, files, bIms, channel, quadrant, parrange,acoords)

%%
%----Inputs----
%--direc: directory with the raw images from andor.
%--dims: dimension of the image, e.g:[1024 1024];
%--channel(1): Different channel(1)s, if you have 2 channel(1)s, DAPI and one
%fluorescent channel(1); then specify channel(1) = [0 1];
%put the channel(1) number corresponding to DAPI channel(1) first in the array.
%--parrange: range(in pixels) over which the software searches for an overlap.
%Try multiple ranges.
%--accords: leave blank for now.

%-----Outputs----
%--fullIm: A cell array of aligned images for each channel(1).
%%
if ~exist('parrange','var')
    parrange = 200;
end

if ~exist('quadrant', 'var')
    quadrant = 1;
end

tot_imgs = files.images1(quadrant);
dims = [files.posX(quadrant), files.posY(quadrant)]; %number of positions imaged in the x and y direction.

%get the maxZ intensity image for the first position imaged in the
%quadrant.
startPosition = 1;
previmgPath = getImagePath(direc, files, startPosition, quadrant);
previmg = getMaxZ(previmgPath, channel(1));
currimg = imsubtract(previmg, bIms{channel(1)});

si=size(previmg);

if exist('acoords','var')
    fullIm=zeros(si(1)*dims(1),si(2)*dims(2));

    for ii=0:tot_imgs

        currinds = acoords(ii).absinds;
        if nargout == 2
            currimg=andorMaxIntensity(imFiles,ii,0,channel(1));
            fullIm(currinds(1):(currinds(1)+si(1)-1),currinds(2):(currinds(2)+si(2)-1))=currimg;
        end
    end
    return;
end


%%

zz=zeros(tot_imgs,2);
zz=mat2cell(zz,ones(tot_imgs,1));
acoords=struct('wabove',zz,'wside',zz,'absinds',zz);

for ii=1:tot_imgs
    coord2 = ceil(ii/dims(1));
    coord1 = ii-(coord2-1)*dims(1);

    currimgPath = getImagePath(direc, files, ii, quadrant);
    currimg = getMaxZ(currimgPath, channel(1));
    currimg = imsubtract(currimg, bIms{channel(1)});

    if coord1 > 1 %if not in left, align with left
        
        %[~ , ind, ind2]=alignTwoImagesLSM(previmg,currimg,4,parrange);
        %[ind, ind2] = [rowShift, colShift].
        [~ , ind2, ind]=alignTwoImagesFourier(previmg,currimg,4,parrange);
        
        acoords(ii).wside=[ind ind2];
    else
        acoords(ii).wside=[0 0];
    end
    previmg=currimg;
    if coord2 > 1 %align with top
        topimgind=ii-dims(1)

        topimgPath = getImagePath(direc, files, topimgind, quadrant);
        topimg=getMaxZ(topimgPath, channel(1));
        topimg = imsubtract(topimg, bIms{channel(1)});

        %[~, ind, ind2]=alignTwoImagesLSM(topimg,currimg,1,parrange);
        [~, ind, ind2]=alignTwoImagesFourier(topimg,currimg,1,parrange);
        acoords(ii).wabove=[ind ind2];
    else
        acoords(ii).wabove=[0 0];
    end

end

%put it together

if nargout == 2
    fullIm=zeros(si(1)*dims(2),si(2)*dims(1));
end
%%

currinds=[1 1];
for ii=1:tot_imgs
    coord2 = ceil(ii/dims(1));
    coord1 = ii-(coord2-1)*dims(1);
    
    currinds=[(coord2-1)*si(1)+1 (coord1-1)*si(2)+1];
    for kk=2:coord2
        currinds(1)=currinds(1)-acoords(ii-(kk-2)*dims(1)).wabove(1);
    end
    for mm=2:coord1
        currinds(2)=currinds(2)-acoords(ii-mm+2).wside(1);
    end
    acoords(ii).absinds=currinds;
    %if nargout == 2
    
    currimgPath = getImagePath(direc, files, ii, quadrant);
    currimg = getMaxZ(currimgPath, channel);
    currimg = imsubtract(currimg, bIms{channel});
    
    fullIm(currinds(1):(currinds(1)+si(1)-1),currinds(2):(currinds(2)+si(2)-1))=currimg;

%end

end
