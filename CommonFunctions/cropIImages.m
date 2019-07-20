
%%
masterFolder = '/Users/sapnachhabra/Desktop/figuresForPaper/figures/trophectoderm/standardCulture';
rawImages = [masterFolder filesep 'sampleImages'];
croppedImages = [masterFolder filesep 'croppedImages'];
mkdir(croppedImages);

samples = dir(rawImages);
toKeep =  find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{samples.name},'UniformOutput',false))); % remove non-named folders
samples = samples(toKeep);
%%
for ii = 1:numel(samples)
    newFolder = [croppedImages filesep samples(ii).name];
    mkdir(newFolder);
    
    images = dir([samples(ii).folder filesep samples(ii).name filesep '*.tif']);
    for jj = 1:numel(images)
        image1 = imread([images(jj).folder filesep images(jj).name]);
        image2 = image1(624:1423, 624:1623);
        imwrite(image2, [newFolder filesep images(jj).name]);
    end
end

%%
height = 80;
xStart  = round(size(image1,2)/2);
yStart = round(size(image1,1)/2) - height/2;
yEnd = round(size(image1,1)/2) + height/2;

for ii = 1:numel(samples)
    
    image1 = imread([samples(ii).folder filesep samples(ii).name]);
    image2 = image1([yStart:yEnd], [xStart:size(image1,2)]);
    imwrite(image2, [croppedImages filesep samples(jj).name]);
    
end