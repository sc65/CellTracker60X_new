
%%

% newfolder = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/160314_Fixadensity/density3_1.7mn/shapeaverages';
% mkdir(newfolder);

%%
%climits = [1200, 40000 16000];
%climits = [0.4 8 8];
shapestotry = 14;
channels = [10 8 6];
markermax = [750 5100 4500];
markermin = [400 400 400];

climitstart = (markermin./markermax); 

titlelab = [{'Cdx2'}, {'Sox17'}, {'Eomes'}];
figure;
plotnum = 1;

binsize = 50;

%normfactor = pcolorplotnormalise;

for shapenum = shapestotry
    
    nrows = numel(shapestotry);
    if(shapenum == 15)
        alpharad = 88; 
    else
        alpharad = 100;
    end
    
    
    clear coloniesnum marker avgOut
    coloniesnum = find([plate1.colonies.shape] == shapenum);
     
     
    if(~isempty(coloniesnum))
        
        avgOut = computeShapeAverages(plate1.colonies, shapenum, coloniesnum, [], binsize, channels);
        
        for i = 1:3
            marker = avgOut.markerAvgs(:,:,i);
            marker(~any(~isnan(marker), 2),:)=[];
            marker(:,~any(~isnan(marker),1)) = [];
            
            
            marker = marker - markermin(i);
           
            marker = marker/normfactor(i);
           
            subplot(nrows,3,plotnum);
            pcolor(marker);
            title(sprintf('n = %01d', numel(coloniesnum)), 'FontWeight', 'bold', 'FontSize', 14);
            colorbar;
            caxis([0 1]);
            
            ax = gca;
            ax.XTickLabel = [];
            ax.YTickLabel = [];
            
            plotnum = plotnum+1;
              
        end 
        
    end
    
end