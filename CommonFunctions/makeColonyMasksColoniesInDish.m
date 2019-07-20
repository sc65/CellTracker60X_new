
% read dapi files
files = dir(['*ch1.tif']);
%%

for ii = 1:numel(files)
    dapi1 = imread(files(ii).name);
    % convert dapi image to binary
    minI = double(min(dapi1(:)));
    maxI = double(max(dapi1(:)));
    forIlim = mat2gray(dapi1);
    t = 0.8*graythresh(forIlim)*maxI + minI;
    dapi2 = dapi1 > 0.4*t;
    
    xres = double(metadata.xres);
    s = round(20/xres); % assuming a cell diameter is 20 microns
    dapi2 = imclose(dapi2, strel('disk', s));
    dapi2 = imfill(dapi2,'holes');
    dapi2 = imopen(dapi2, strel('disk',round(0.5*s)));
    
    minArea = floor((pi*((2*10/xres).^2))/2); % atleast 2 cells across
    dapi2 = bwareaopen(dapi2,minArea);
    %%
    % remove object if >10% boundary pixels fall on image edge
    [B,L] = bwboundaries(dapi2);
    for jj = 1:size(B,1)
        edgePixels = numel(find(ismember(B{jj}, [1,1024])));
        edgeFraction = edgePixels/(size(B{jj},1)*2);
        if edgeFraction>0.1
            L(L==jj) = 0;
        end
    end
    %%
    L = logical(L);
    filePrefix = strtok(files(ii).name, '_');
    imwrite(L, [filePrefix '_colonyMask.tif']);
end
