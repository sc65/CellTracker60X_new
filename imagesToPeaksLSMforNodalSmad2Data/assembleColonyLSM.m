function [alignedColonyImage, alignedColonyData] = assembleColonyLSM(outputfile,  colonyNum)
%% a function to make aligned images for a colony in a given quadrant.
load(outputfile);
imageNumbers = sort(plate1.colonies(colonyNum).imagenumbers);
%%
%dims - [columnsImaged rowsImaged] in the quadrant.
dims = [files.posX(quadrant) files.posY(quadrant)];
nRows = ceil(max(imageNumbers)/dims(1)) - ceil(min(imageNumbers)/dims(1))+1 ;
nColumns = length(imageNumbers)/nRows;

imageNumbersInOrder = zeros(nColumns, nRows);
imageNumbersInOrder = reshape(imageNumbers', size(imageNumbersInOrder));
imageNumbersInOrder = imageNumbersInOrder'; %because reshape arranges data column-wise, I want row-wise.
data = plate1.colonies(colonyNum).data;
%%
% make an aligned image for each row.
imagesInRow = cell(1,nRows);
rowImagesData = imagesInRow;

for ii = 1:nRows
    imagesInColumn = cell(1,nColumns-1);
    for jj = 1:nColumns-1
        imageNumbersToAlign = imageNumbersInOrder(ii,jj:jj+1);
        for kk = 1:2 %get all channel images as a stack for both the images to align.
            
            currimg = getAllChannelImagesFromImageNumber(imagesPath, files, bIms, imageNumbersToAlign(kk), quadrant);
            if kk == 1
                image1 = currimg;
            else
                image2 = currimg;
            end
        end
        
%         image1data = data(data(:,end-1) == imageNumbersToAlign(1),:);
%         image2data = data(data(:,end-1) == imageNumbersToAlign(2),:);
        
         image1data = peaks{imageNumbersToAlign(1)};
         image2data = peaks{imageNumbersToAlign(2)};
        [imagesInColumn{jj}, ~, ~, newdata] = alignTwoImagesFourierCorrectData(image1, image2, 4, 200, image1data, image2data);
    end
    if jj == 2 %If there are three aligned images in a row, perform another alignment to get just one aligned image per row.
        %image3data =  data(data(:,end-1) == imageNumbersInOrder(ii,3),:);
        image3data = peaks{imageNumbersInOrder(ii,3)};
        [imagesInRow{ii}, ~, ~, rowImagesData{ii}] = alignTwoImagesFourierCorrectData(imagesInColumn{1}, imagesInColumn{2}, 4, 1024, newdata, image3data);
    elseif jj == 1
        imagesInRow{ii} = imagesInColumn{jj};
        rowImagesData{ii} = newdata;
        
    end
end
%%
if nColumns == 1
    for ii = 1:nRows
        imagesInRow{ii} = getAllChannelImagesFromImageNumber(imagesPath, files, bIms, imageNumbersInOrder(ii), quadrant);
        %rowImagesData{ii} =data(data(:,end-1) == imageNumbersInOrder(ii));
        rowImagesData{ii} = peaks{imageNumbersInOrder(ii)};
    end   
end


%align the aligned images - top to bottom for all the column wise aligned
%images for every row.
alignedImage = cell(1,nRows-1);
for ii = 1:nRows-1
     side = 1;
     maxOverlap = 200; %keeping padding into consideration. 
    [alignedImage{ii}, ~, ~, newdata]  = alignTwoImagesFourierCorrectData(imagesInRow{ii}, imagesInRow{ii+1}, 1, maxOverlap, rowImagesData{ii}, rowImagesData{ii+1});
    
    if ii == 2 %If there are three aligned images in a column, perform another alignment to get just one aligned image per row.
      
        maxOverlap = 1200;
        [alignedColonyImage, ~, alignedColonyData] = alignTwoImagesFourierCorrectData(alignedImage{1}, alignedImage{2}, side, maxOverlap, newdata, rowImagesData{3});
    else
        alignedColonyImage = alignedImage{ii};
        alignedColonyData = newdata;
    end
end

if nRows == 1
    %if there is only one row of images.
    alignedColonyImage = imagesInRow{1};
    alignedColonyData = rowImagesData{1};
end



