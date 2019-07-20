function [minIm, meanIm]=mkBackgroundImageLSM(direc, files, channel, quadrant,  maxIm, filterrad)


if ~exist('filterrad','var')
    filterrad=200;
end

if ~exist('quadrant', 'var')
    quadrant = 1;
end

q=1; %------What is q?

xmax = max(files.posX(quadrant));
ymax = max(files.posY(quadrant));
%nIms=xmax*ymax;
nIms = cumsum(files.images1); %-SC

nIms = nIms(quadrant);
ImRange=randperm(nIms);
disp(xmax); disp(ymax);

for jj=1:length(ImRange)
    
    [x, y]=ind2sub([xmax ymax],ImRange(jj));
    
    %     if x == 1 || y == 1 || x == xmax || y == ymax %----- Why exclude these images?
    %         continue;
    %     end
    %
    %Read the corresponding max z intensity image.
    image1dir = [direc filesep sprintf('Track%04d', ImRange(jj))];
    image1info = dir([image1dir filesep '*.oif']);
    
    
    image1path = [image1dir filesep image1info.name];
    maxZ = getMaxZ(image1path, channel);
    
    
    
    if exist('maxIm','var') && q > maxIm %------------What is maxIm?
        break;
    end
    
    imNow=im2double(maxZ);
    
    if min(min(imNow)) == 0
        disp(['here ' int2str([x y])]);
    end
    if q==1
        minIm=imNow;
        meanIm=imNow;
    else
        minIm=min(minIm,imNow);
        meanIm=((q-1)*meanIm+imNow)/q;
    end
    q=q+1;
end

 gfilt=fspecial('gaussian',filterrad,filterrad/5);
% minIm=imfilter(minIm,gfilt,'symmetric');
meanIm=imfilter(meanIm,gfilt,'symmetric'); %---------What is mean image for?
minIm = imopen(imgaussfilt(minIm), strel('disk', filterrad));

end