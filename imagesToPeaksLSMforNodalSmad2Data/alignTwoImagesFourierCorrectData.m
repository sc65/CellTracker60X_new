function [fiAllChannels, rowshift, colshift, newdata] = alignTwoImagesFourierCorrectData(image1, image2, side,maxov, data1, data2)
%-----------Inputs--------------
%   side = 1  im2 below im1
%          2  im2 left of im1
%          3  im2 above im1
%          4  im2 right of im1

% data1, data2 = peaks data for image1, image2.

%----------Outputs----------------
%  newdata: combining peaks data from image1 and image2 and returning the data corresponding to the aligned image.
%------------------------------------
%%
ov = maxov;

%get image sizes, check if same size for alignment, if not, pad the small
%image with zeros
si1=size(image1); si2=size(image2);

sdiff1=si1(2)-si2(2);
if sdiff1 > 0 %need to pad
    image2(:,(end+1):(end+sdiff1),:)=0;
else
    image1(:,(end+1):(end-sdiff1),:)=0;
end

sdiff2=si1(1)-si2(1);
if sdiff2 > 0 %need to pad
    image2((end+1):(end+sdiff2),:,:)=0;
else
    image1((end+1):(end-sdiff2),:, :)=0;
end


% -- Use DAPI images to find overlap.
im1 = image1(:,:,1);
im2 = image2(:,:,1);

%%
% find the best pixel overlap.
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

[~, rowshift1, colshift1] = registerTwoImages(pix1,pix2);
si = size(im1);

% apply it to all channel images.

for ch = 1:size(image1,3)
    
    im1 = image1(:,:,ch);
    im2 = image2(:,:,ch);
    
    if side == 1 || side == 3
        rowshift = maxov - abs(rowshift1);
        colshift = colshift1;
        fi = uint16(zeros(2*si(1)-abs(rowshift),si(2)+abs(colshift),2));
    else
        colshift = maxov-colshift1;
        rowshift  = rowshift1;
        fi = uint16(zeros(si(1)+abs(rowshift),2*si(2)-abs(colshift),2));
    end
    switch side
        case 1
            if colshift > 0
                fi(1:si(1),1:si(2),1) = im1;
                fi(si(1)-abs(rowshift)+1:end,colshift+1:end,2) = im2;
                
                %remove duplicate data and correct indices.
                indstoremove = abs(data2(:,1)) < colshift;
                data2(indstoremove,:) = [];
            else
                fi(1:si(1),abs(colshift)+1:end,1) = im1;
                fi(si(1)-abs(rowshift)+1:end,1:si(2),2) = im2;
                
                indstoremove = abs(data1(:,1))<abs(colshift);
                data1(indstoremove,:) = [];
                
            end
            
            indstoremove = abs(data2(:,2)) < rowshift-20;
            data2(indstoremove,:) = [];
            
            if ch == 1
                data2(:,2) = data2(:,2) + si(1) - rowshift + 1;
            end
            
        case 2
            
        case 3
            if colshift > 0
                fi(1:si(1),1:si(2),1) = im2;
                fi(si(1)-abs(rowshift)+1:end,colshift+1:end,2) = im1;
            else
                fi(1:si(1),1:si(2),1) = im2;
                fi(si(1)-abs(rowshift)+1:end,abs(colshift)+1:end,2) = im1;
            end
        case 4
            if rowshift > 0
                fi(1:si(1),1:si(2),1) = im1;
                fi(rowshift+1:end,si(2)-abs(colshift)+1:end,2) = im2;
                
                %correct indices.
                indstoremove = abs(data2(:,2))<abs(rowshift);
                data2(indstoremove,:) = [];
            else
                fi(abs(rowshift)+1:end,1:si(2),1) = im1;
                %fi(1:si(1),si(1)-abs(colshift)+1:end,2) = im2;
                fi(1:si(1),si(2)-abs(colshift)+1:end,2) = im2; %----SC
                
                indstoremove = abs(data1(:,2)) < abs(rowshift);
                data1(indstoremove,:) = [];
            end
            
            indstoremove = abs(data2(:,1)) < abs(colshift);
            data2(indstoremove,:) = [];
            
            if ch == 1
                data2(:,1) = data2(:,1)+ si(2) - colshift + 1;
            end
            
    end
    
    newdata = [data1; data2];
    
    m1 = fi(:,:,1);
    m2 = fi(:,:,2);
    
    m1(m1==0) = m2(m1==0);
    m2(m2==0) = m1(m2==0);
    
    fi = mean(cat(3,m1,m2),3);
    
    fiAllChannels(:,:,ch) = fi;
    
end
end