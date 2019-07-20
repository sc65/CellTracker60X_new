function fiAllChannels = applyImageAlignment(image1, image2, side,  rowshift, colshift)
%% for images which need to be aligned with a certain overlap, use this function  
%% Inputs---------------%
% 1,2) image1/2 - images that need to be aligned.
% 3) side =1  im2 below im1
%          2  im2 left of im1
%          3  im2 above im1
%          4  im2 right of im1
% 4) maxov - same as in function alignTwoImagesFourier
% 5,6) rowShift1, colShift1 - overlaps as returned by function
% registerTwoImages.

%%
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

si = size(image1(:,:,1));
%%
for ch = 1:size(image1,3)
    im1 = image1(:,:,ch);
    im2 = image2(:,:,ch);
    
    if side == 1 || side == 3
        fi = uint16(zeros(2*si(1)-abs(rowshift),si(2)+abs(colshift),2));
    else
        fi = uint16(zeros(si(1)+abs(rowshift),2*si(2)-abs(colshift),2));
    end
    
    switch side
        case 1
            if colshift > 0
                fi(1:si(1),1:si(2),1) = im1;
                fi(si(1)-abs(rowshift)+1:end,colshift+1:end,2) = im2;
            else
                fi(1:si(1),abs(colshift)+1:end,1) = im1;
                fi(si(1)-abs(rowshift)+1:end,1:si(2),2) = im2;
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
                fi(rowshift+1:end,si(1)-abs(colshift)+1:end,2) = im2;
            else
                fi(abs(rowshift)+1:end,1:si(2),1) = im1;
                %fi(1:si(1),si(1)-abs(colshift)+1:end,2) = im2;
                fi(1:si(1),si(2)-abs(colshift)+1:end,2) = im2; %----SC
            end
    end
    
    
    m1 = fi(:,:,1);
    m2 = fi(:,:,2);
    
    m1(m1==0) = m2(m1==0);
    m2(m2==0) = m1(m2==0);
    
    fi = mean(cat(3,m1,m2),3);
    fiAllChannels(:,:,ch) = uint16(fi);
    
end