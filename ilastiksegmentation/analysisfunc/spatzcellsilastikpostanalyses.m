
%%

chan = [0 1];

inputdirec = '/Users/sapnachhabra/Desktop/160724FISH2060Confocal/FISH60XAndorformat';
alignedimagesdirec = '/Users/sapnachhabra/Desktop/160724FISH2060Confocal/60Xspatzcellsformat/alignedimages';
outputmatfilepath = '/Users/sapnachhabra/Desktop/160724FISH2060Confocal/60Xspatzcellsformat/newoutput_matfiles';
sample_normalize = 2;
mkdir(alignedimagesdirec);
% until I figure out a better way to initialise dimens for all colonies.

dimens{1} = [1 1]; % NC
dimens{2} = [4 5]; % t0
dimens{3} = [5 5]; % t0
% dimens{4} = [6 3]; % t6
% dimens{5} = [6 3]; % t6
% dimens{6} = [6 3]; % t12
% dimens{7} = [6 3]; % t12
% dimens{8} = [3 6]; % t24
% dimens{9} = [3 6]; % t24
% dimens{10} = [6 4];% t36
% dimens{11} = [6 3];% t36
% dimens{12} = [7 3];% t42
% dimens{13} = [7 3];% t42

% for i = chan
%     newfolder = strcat(alignedimagesdirec, filesep, sprintf('channel%02d', i));
%     mkdir(newfolder);
% end
%%
% aligning images and getting acoords

[fileinfo, start] = postart(inputdirec);
samplenumlist = start:length(fileinfo);
samplenumlist(samplenumlist == sample_normalize+start-1) = [];
i_values = [start+sample_normalize-1 samplenumlist];
samplenum = numel(i_values);

%%
%for i = 5
for i = i_values
    
    clear acoords fullIm;
    
    dims = dimens{i-start+1};
    parrange = [200:300];
    filepath = strcat(inputdirec, filesep,fileinfo(i).name);
    
    [acoords, fullIm] = alignManyPanelsAndorZstackMontagediffchan(filepath, dims,chan,parrange);
    channels = [{'DAPI'}, {'Noggin'},{'Lefty'}, {'Nodal'}];
    
    for ch = 1:numel(chan)
        %         if(i==start+sample_normalize-1)
        %             intensity{ch} = stretchlim(fullIm{ch});
        %         end
        %         fullIm{ch} = imadjust(fullIm{ch}, [intensity{ch}(1) intensity{ch}(2)], []);
        %
        figure;
        imshow(fullIm{ch});
        %title(channels{ch}, 'FontWeight', 'bold', 'FontSize', 12);
        file2write = strcat(alignedimagesdirec, filesep, sprintf('channel%02d', ch-1), filesep, sprintf('sample%02d.tif', i-start+1));
        
        imwrite(fullIm{ch}, file2write);
        
        close all;
        
        
    end
    
            outputfile = strcat(outputmatfilepath, filesep, sprintf('sample%02dout.mat', i-start+1));
            load(outputfile);
    
           save(outputfile, 'acoords', '-append');
end
%%
% remove duplicate cells and store cells information in a new variable
% peaksnew.


for i = 1:samplenum
    clear peaks acoords
    outputfile = strcat(outputmatfilepath, filesep, sprintf('sample%02dout.mat', i));
    load(outputfile);
    
    peaksnew = removeDuplicateCells(peaks, acoords);
    save(outputfile, 'peaksnew', '-append');
end
%%
% make spotsnew: information of all the spots in a colony(all positions combined) identified in each channel
% modify peaksnew: information of all cells in a colony(all positions
% combined) identified in each channel.
% in each position in a sample - add another column(5) that represents the position that spot corresponds to.

% 1)Correcting indices

for sample = 1:samplenum
    clear alldatacorrect peaksnew currdat lens totcells
    outputfile = strcat(outputmatfilepath, filesep, sprintf('sample%02dout.mat', sample));
    load(outputfile);
    k1=num2cell(ones(1,length(peaksnew)));
    lens=cellfun(@size,peaksnew,k1);
    totcells=sum(lens);
    q = 1;
    for ii=1:length(peaksnew)
        if ~isempty(peaksnew{ii})
            currdat=peaksnew{ii};
            toadd=[acoords(ii).absinds(2) acoords(ii).absinds(1)];
            currdat(:,1:2)=bsxfun(@plus,currdat(:,1:2),toadd);
            alldatacorrect(q:(q+lens(ii)-1),:)=[currdat ii*ones(lens(ii),1)];
            q=q+lens(ii);
        end
    end
    save(outputfile, 'alldatacorrect', '-append');
end
%%
% % 2) Making spotsnew
% 
% %for ii =1;
% for ii = 1:samplenum;
%     outputfile = strcat(outputmatfilepath, filesep, sprintf('sample%02dout.mat', sample));
%     clear allspots;
%     load(outputfile);
%     allspots = cell(1,3);
%     positions = unique(allcells(:,5));
%     for pos = 1:numel(positions)
%         cellid = allcells((allcells(:,5) == positions(pos)),4);
%         for cellnum = 1:numel(cellid)
%             if(~isempty(spotsinfo{pos}))
%                 spots = spotsinfo{pos}(spotsinfo{pos}(:,5)== cellid(cellnum),:);
%                 spots(:,7) = pos;
%                 for ch = 1:3
%                     spotsreq = spots(spots(:,6) == ch,:);
%                     spotsreq(:,6) = [];
%                     
%                     if((pos ==1)&&(cellnum ==1))
%                         allspots{ch} = spotsreq;
%                     else
%                         allspots{ch} = [allspots{ch}; spotsreq];
%                     end
%                 end
%             end
%         end
%         
%         
%     end
%     save(outputfile, 'allspots', '-append');
% end

%%
% make pcolor plots using alldatacorrect

ch = 6;
rotmat = [0 -1;1 0];

plotnum = 1;

for i = 2
    %for i = 1:samplenum
    figure;
    clear alldatacorrect nodalsum
    outputfile = strcat(outputmatfilepath, filesep, sprintf('sample%02dout.mat', i));
    load(outputfile);
    
    %alldatacorrect(alldatacorrect(:,ch+1) == 0,:) = [];
    
    nodalsum = alldatacorrect(:,ch)+alldatacorrect(:,ch+1);%./alldatacorrect(:,ch+1);
    
    maxns = max(nodalsum);
    
    scatter(alldatacorrect(:,1), -alldatacorrect(:,2), 70, nodalsum, 'Filled');
    
    ncells = size(nodalsum,1);
    %     end
    colorbar;
    
    climit_min = min(nodalsum./maxns);
    caxis([0 250]);
    
    %caxis([climit_min 1]);
    title(sprintf('sample%02d #%02d', i,ncells));
    xlim([0 4000]);
    ylim([-4000 -400]);
    
    plotnum = plotnum+1;
    
end

%%
% make radial average plots for these two colonies
% 1) Find the center of the colony.
% 2) Remove cells that do not beong to the colony.
% 3) At a particular distance from the edge of the colony, bin the cells.
% 4) Find the radial average of those cells.


for i = [3 2]
clear alldatacorrect xyvalues nodalvalues

outputfile = strcat(outputmatfilepath, filesep, sprintf('sample%02dout.mat', i));
load(outputfile);

xyvalues = [alldatacorrect(:,1), -alldatacorrect(:,2)];
nodalvalues = alldatacorrect(:,6)+alldatacorrect(:,7);

c_center = [mean(xyvalues(:,1)), mean(xyvalues(:,2))];
% figure;
% plot(xyvalues(:,1), xyvalues(:,2), 'k.');
% hold on;
% plot(c_center(1), c_center(2), 'r*');
%%
clear dists rowstodelete
coord=bsxfun(@minus,xyvalues,c_center);
dists=sqrt(sum(coord.*coord,2));

distlimit = 1800;
rowstodelete = find(dists>distlimit);

xyvalues(rowstodelete,:) = [];
nodalvalues(rowstodelete,:) = [];
%%
%compute distance from boundary using bwdist
xyvalues(:,2) = xyvalues(:,2)+4000;

clear mask inds dists distt
xyvalues = ceil(xyvalues);
colmax = max(xyvalues);
mask=false(colmax(1)+10,colmax(2)+10);
inds=sub2ind(size(mask),xyvalues(:,1),xyvalues(:,2));
mask(inds)=1;
mask=bwconvhull(mask);
distt=bwdist(~mask);
dists=distt(inds);
%%
dmax=max(dists);
binsize = 300;

clear rA cellsinbin
cellsinbin=zeros(ceil(dmax/binsize),1); rA=cellsinbin;
q=1;
for jj=0:binsize:dmax
    inds= dists >= binsize*(q-1) & dists < binsize*q;
    if sum(inds) > 0
        dat=nodalvalues(inds);
       
        if exist('toohigh','var')
            nogood = dat > toohigh;
        else
            nogood = false(size(dat));
        end
        rA(q)=meannonan(dat(~nogood));
        cellsinbin(q)=sum(inds)-sum(nogood);
        
        
    else
        rA(q)=0;
        cellsinbin(q)=0;
    end
    
    q=q+1;
end


% Plotting distance from the boundary
clear xaxisvalues

xaxisvalues = linspace(0, 350, numel(rA));

if i==3
    maxrA = max(rA);
end

figure;
plot(xaxisvalues, rA./maxrA, '-', 'LineWidth', 4);

end






















