function makeSameSizeImages(imagesPath)
%%  makes all images in a folder the size of the largest image

%%
images = dir(imagesPath);
toKeep = ~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{images.name},'UniformOutput',false));
images = images(toKeep);

allImages = cell(1, numel(images));
for ii = 1:numel(images)
    allImages{ii} = imread([images(ii).folder filesep images(ii).name]);
end

rows = cellfun(@(x) size(x,1), allImages);
columns = cellfun(@(x) size(x,2), allImages);
rows_max = max(rows);
columns_max = max(columns);
size_new = [rows_max columns_max];


% if image is smaller than [rows_max, column_max], pad it with zeros
for ii = 1:numel(images)
    newImage = makeImageSizeX(allImages{ii}, size_new);
    imwrite(newImage, [images(ii).folder filesep images(ii).name]);    
end

end