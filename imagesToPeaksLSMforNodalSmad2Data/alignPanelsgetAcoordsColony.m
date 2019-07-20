function [colonyCoords, fullIm]=alignPanelsgetAcoordsColony(direc, outputfile, colonynum, channel, quadrant, parrange)

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
load(outputfile); 
if ~exist('parrange','var')
    parrange = 90:115;
end

if ~exist('quadrant', 'var')
    quadrant = 1;
end

imageNumbers = plate1.colonies(colonynum).imagenumbers'; %images that form the colony.
tot_imgs = length(imageNumbers); %number of images that make up the colony.

dims1 = [files.posX(quadrant), files.posY(quadrant)]; %number of positions imaged in the x and y direction.
dims(2) = ceil(max(imageNumbers)/dims1(1)) - ceil(min(imageNumbers)/dims1(1))+ 1; %number of rows that colony image spans.
dims(1) = tot_imgs/dims(2); %number of columns that colony image spans. 

%get the maxZ intensity image for the first position imaged in the
%quadrant.
startPosition = min(imageNumbers);
previmgPath = getImagePath(direc, files, startPosition, quadrant);
previmg = getMaxZ(previmgPath, channel(1));
si=size(previmg);


%%
perpsearch = 20;
zz=zeros(tot_imgs,2);
zz=mat2cell(zz,ones(tot_imgs,1));
colonyCoords=struct('wabove',zz,'wside',zz,'absinds',zz);

for ii=1:tot_imgs
    coord2 = ceil(ii/dims(1));
    coord1 = ii-(coord2-1)*dims(1);

    currimgPath = getImagePath(direc, files, imageNumbers(ii), quadrant);
    currimg = getMaxZ(currimgPath, channel(1));
    currimg = imsubtract(currimg, bIms{channel(1)});

    if coord1 > 1 %if not in left, align with left
        [~ , ind, ind2, sf]=alignTwoImagesLSM(previmg,currimg,4,parrange,perpsearch);
        colonyCoords(ii).wside=[ind ind2 sf];
    else
        colonyCoords(ii).wside=[0 0];
    end
    previmg=currimg;
    if coord2 > 1 %align with top
        topimgind=ii-dims(1);

        topimgPath = getImagePath(direc, files, imageNumbers(topimgind), quadrant);
        topimg=getMaxZ(topimgPath, channel(1));
        topimg = imsubtract(topimg, bIms{channel(1)});

        [~, ind, ind2, sf]=alignTwoImagesLSM(topimg,currimg,1,parrange,perpsearch);
        colonyCoords(ii).wabove=[ind ind2 sf];
    else
        colonyCoords(ii).wabove=[0 0];
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
        currinds(1)=currinds(1)-colonyCoords(ii-(kk-2)*dims(1)).wabove(1);
    end
    for mm=2:coord1
        currinds(2)=currinds(2)-colonyCoords(ii-mm+2).wside(1);
    end
    colonyCoords(ii).absinds=currinds;
    %if nargout == 2
    
    currimgPath = getImagePath(direc, files, imageNumbers(ii), quadrant);
    currimg = getMaxZ(currimgPath, channel);
    currimg = imsubtract(currimg, bIms{channel});
    
    fullIm(currinds(1):(currinds(1)+si(1)-1),currinds(2):(currinds(2)+si(2)-1))=currimg;

%end

end
