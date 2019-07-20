function [newImage, ind, ind2, scale_fac]=alignTwoImagesLSM(im1,im2,side,parrange,perpsearch,bgIm)

%%
%   side = 1  im2 below im1
%          2  im2 left of im1
%          3  im2 above im1
%          4  im2 right of im1
%%
if ~exist('parrange','var') || isempty(parrange)
    parrange=90:115;
end
if ~exist('perpsearch','var') || isempty(perpsearch)
    perpsearch=20;
end

scale=1;

%get image sizes, check if same size for alignment, if not, pad the small
%image with zeros

si1=size(im1); si2=size(im2);
if (side==1 || side==3) && si1(2)~=si2(2)
    sdiff=si1(2)-si2(2);
    if sdiff > 0 %need to pad
        im2(:,(end+1):(end+sdiff))=0;
    else
        im1(:,(end+1):(end-sdiff))=0;
    end
end

if (side==2 || side==4) && si1(1)~=si2(1)
    sdiff=si1(1)-si2(1);
    if sdiff > 0 %need to pad
        im2((end+1):(end+sdiff),:)=0;
    else
        im1((end+1):(end-sdiff),:)=0;
    end
end


ovbestpar = -1;
cross_correlation = zeros(1, max(parrange));
cc = 0;

%find overlap in primary direction
for ov=parrange
    switch side
        case 1
            pix1=im1((end-ov):end,:);
            pix2=im2(1:(1+ov),:);
        case 2
            pix1=im1(:,1:(1+ov));
            pix2=im2(:,(end-ov):end);
        case 3
            pix1=im1(1:(1+ov),:);
            pix2=im2((end-ov):end,:);
        case 4
            pix1=im1(:,(end-ov):end);
            pix2=im2(:,1:(1+ov));
    end
    cross_correlation(ov) = mean2((pix1-mean2(pix1)).*(pix2-mean2(pix2)));

    if cross_correlation(ov) > cc
        cc = cross_correlation(ov);
        ovbestpar = ov;
        pix1best=pix1; pix2best=pix2;
    end
    
end



cross_correlation = 0;
cc = 0;

for ov=-perpsearch:perpsearch
    pix2b=pix2best; pix1b=pix1best;
    if side==1 || side==3
        if ov < 0
            pix2b(:,(end+ov):end)=[];
            pix1b(:,1:(1-ov))=[];
            cross_correlation = mean2((pix1b-mean2(pix1b)).*(pix2b-mean2(pix2b)));
        else
            pix2b(:,1:(1+ov))=[];
            pix1b(:,(end-ov):end)=[];
            cross_correlation = mean2((pix1b-mean2(pix1b)).*(pix2b-mean2(pix2b)));
        end
    end
    
    if side==2 || side==4
        if ov < 0
            pix2b((end+ov):end,:)=[];
            pix1b(1:(1-ov),:)=[];
            cross_correlation = mean2((pix1b-mean2(pix1b)).*(pix2b-mean2(pix2b)));
        else
            pix2b(1:(1+ov),:)=[];
            pix1b((end-ov):end,:)=[];
            cross_correlation = mean2((pix1b-mean2(pix1b)).*(pix2b-mean2(pix2b)));
        end
    end
    
    if cross_correlation > cc
        cc = cross_correlation;
        ovbestperp=ov;
    end
end


ind=ovbestpar;
ind2=ovbestperp;

if exist('bgIm','var')
    im1return=imsubtract(im1,bgIm);
    im2return=imsubtract(im2,bgIm);
else
    im1return=im1;
    im2return=im2;
end

    scale_fac=sum(sum(pix1))/sum(sum(pix2));
if scale
    im2return=im2return*scale_fac;
end

if side==1 || side==3
    if ind2 < 0
        im2return(:,(end+ind2):end)=[];
        im1return(:,1:(1-ind2))=[];
    else
        im2return(:,1:(1+ind2))=[];
        im1return(:,(end-ind2):end)=[];
    end
elseif side==2 || side==4
    if ind2 < 0
        im2return((end+ind2):end,:)=[];
        im1return(1:(1-ind2),:)=[];
    else
        im2return(1:(1+ind2),:)=[];
        im1return((end-ind2):end,:)=[];
    end
end

half_s=ceil(ind/2);

switch side
    
    
    case 1
        newImage=[im1return(1:(end-half_s),:); im2return((ind+1-half_s):end,:)];
    case 2
        newImage=[im2return im1return(:,(ind+1):end)];
    case 3
        newImage=[im2return; im1return((ind+1):end,:)];
    case 4
        newImage=[im1return im2return(:,(ind+1):end)];
end

