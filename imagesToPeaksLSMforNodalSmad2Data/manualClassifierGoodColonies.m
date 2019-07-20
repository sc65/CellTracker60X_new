function manualClassifierGoodColonies(matfile)
%% a function to further classify the shapes belonging to good Colonies.


pp=load(matfile,'plate1', 'userParam', 'goodColonies');
plate1=pp.plate1;
umtopixel = pp.userParam.umtopxl;
goodColonies = pp.goodColonies;

shapes=[plate1.colonies.shape];
rotate=[plate1.colonies.rotate];

% plot all the goodColonies
plotnum = 1;
figure;
for ii = goodColonies
    subplot(10,7, plotnum);
    plotnum = plotnum+1;
    plot(plate1.colonies(ii).data(:,1), -plate1.colonies(ii).data(:,2), 'k.');
    title(['Colony' int2str(ii)]);
end
%%

% set the shape for all the non-goodColonies to zero.
inds2zero = setxor(1:length(plate1.colonies), goodColonies);
for ii = inds2zero
    plate1.colonies(ii).shape = 0;
end
%inds2classify = find(ncells > cellthresh);
inds2classify = goodColonies; %classify only good colonies (filtered earlier)

nc=length(inds2classify);
disp(['There are ' int2str(nc) ' colonies to classify']);

h=figure;
set(h,'WindowStyle','docked');
% subplot(2,1,1);
%imshow('~/work/CellTracker/Cytoo/shapes.png');
for kk=1:nc
    
    
    if exist('savedmat','var') && length(rotate) > kk
        plate1.colonies(inds2classify(kk)).shape=shapes(kk);
        plate1.colonies(inds2classify(kk)).rotate=rotate(kk);
        disp(['filling in' int2str(kk) ]);
        continue;
    end
    
    
    
    ii=inds2classify(kk);
    clf;
    plate1.colonies(ii).plotColonyColorPoints(0);
    axis equal;
    xmin = min(plate1.colonies(ii).data(:,1));
    ymin = min(plate1.colonies(ii).data(:,2));
    xmax = max(plate1.colonies(ii).data(:,1));
    ymax = max(plate1.colonies(ii).data(:,2));
    
    xdist = (xmax-xmin)/umtopixel;
    ydist = (ymax-ymin)/umtopixel;
    
    line([xmin xmax],[ymax+10 ymax+10]);
    text((xmin+xmax)/2,ymax+15,[num2str(xdist) ' \mum']);
    
    line([xmax+10 xmax+10],[ymin ymax]);
    text(xmax+15,(ymin+ymax)/2,[num2str(ydist) ' \mum']);
    
    xx=input(['Colony ' int2str(inds2classify(kk)) '\nEnter shape number.\nEnter a negative number to rotate the colony 180 degrees\nEnter 0 to skip\n']);
    if xx < 0
        plate1.colonies(ii).rotate = 1;
        plate1.colonies(ii).shape = -xx;
    else
        plate1.colonies(ii).rotate = 0;
        plate1.colonies(ii).shape=xx;
    end
    
    shapes=[plate1.colonies.shape];
    rotate=[plate1.colonies.rotate];
    
    save('tmp.mat','shapes','rotate');
    
end


save(matfile,'plate1','-append');
