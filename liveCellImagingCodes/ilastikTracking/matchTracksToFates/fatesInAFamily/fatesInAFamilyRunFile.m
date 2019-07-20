%% fates in a family.
outputFilesPath = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles';

sisterInfo = zeros(200,7);
neighbourInfo = zeros(200,7);
counter1 = 1;
counter2 = 1;

for colonyId = [2 4:6]
    for partId = 1:2
        
        ltCheck = makeLineageDivisionTimeMatrix(outputFilesPath, colonyId, partId);
        [table1, table2]= makeFatePositionTableOneColonyOnePart(outputFilesPath, colonyId, partId, ltCheck);
        
        nCells1 = size(table1,1);
        sisterInfo(counter1:counter1+nCells1-1,1:5) = table1;
        sisterInfo([counter1:counter1+nCells1-1],6:7) = repmat([colonyId partId], [nCells1 1]);
        counter1 = counter1+nCells1;
        
        nCells2 = size(table2,1);
        neighbourInfo(counter2:counter2+nCells2-1,1:5) = table2;
        neighbourInfo([counter2:counter2+nCells2-1],6:7) = repmat([colonyId partId], [nCells2 1]);
        counter2 = counter2+nCells2;
        
    end
end
%%
sisterInfo = sisterInfo(1:counter1-1,:);
neighbourInfo = neighbourInfo(1:counter2-1,:);
%%
xlabels = {'Time of Formation (hrs after treatment)', 'Distance between sister cells(\mum)'};
ylabels =  {'abs(sister1-sister2)', 'abs(sister1-sister2)'};
titles = {'Brachyury/Venus', 'CDX2/Venus'};

nSisters = size(sisterInfo,1);
figure;
counter1 = 1;
for ii = [1 2] % yAxes
    for jj = [3:4] % xAxes
        subplot(2,2,counter1);
        plot(sisterInfo(:,jj), sisterInfo(:,ii), '.', 'Color', [0.5 0 0], 'MarkerSize', 20);
        xlabel(xlabels{jj-2});
        ylabel(ylabels{ii});
        title(titles{ii});
        %
        %         for kk = 1:nSisters
        %             hold on;
        %             text(sisterInfo(kk,jj)+1, sisterInfo(kk,ii), int2str(sisterInfo(kk,6)));
        %         end
        %
        counter1 = counter1+1;
        ax = gca;
        ax.FontSize = 14;
        ax.FontWeight = 'bold';
    end
end

%%
% For all tracked cells with sisters, find the difference in fate levels
% with the closest(<80um) non-sister neighbour in that list.

figure;
titles = {'Brachyury/Venus', 'cdx2/Venus'};
ylabels = {'abs(cell-neighbour)'};


for ii = 1:2
    subplot(1,2,ii);
    plot(neighbourInfo(:,4), neighbourInfo(:,ii),  '.', 'Color', [0.5 0 0], 'MarkerSize', 20);
    xlim([0 100]);
    xlabel('Distance from the cell(\mum)');
    ylabel(ylabels);
    title(titles{ii});
    ax = gca;
    ax.FontSize = 14;
    ax.FontWeight = 'bold';
end

%%
% For tracked cell - give the distance between the cell and neighbour cell
% is <= 10+distance between the cell and sister cell
% calculate - f11 = f1(neighbour)/f1(sister),
% f22 = f2(neighbour)/f2(daughter)

%f1(neighbour) = abs(cell1_t/venus - neighbourCell_t/Venus)
%f1(sister) = abs(cell1_t/venus - sisterCell_t/Venus)


filter1 = abs(neighbourInfo(:,4) - sisterInfo(:,4));
toKeep = find(filter1<30);

neighbourInfo1 = neighbourInfo(toKeep,:);
sisterInfo1 = sisterInfo(toKeep,:);

% just keep the first cousins.
% toKeep = find(neighbourInfo1(:,3)==0);
% neighbourInfo1 = neighbourInfo1(toKeep,:);
% sisterInfo1 = sisterInfo1(toKeep,:);

f11 = neighbourInfo1(:,1)./(sisterInfo1(:,1));
f22 = neighbourInfo1(:,2)./(sisterInfo1(:,2));
%%
c1 = f11 < 100;
c2 = f22<1800;
toKeep = c1&c2;
neighbourInfo1 = neighbourInfo1(toKeep,:);
sisterInfo1 = sisterInfo1(toKeep,:);
%%
f11 = neighbourInfo1(:,1)./(sisterInfo1(:,1));
f22 = neighbourInfo1(:,2)./(sisterInfo1(:,2));

figure; subplot(1,2,1); histogram(f11, 'BinWidth', 1); subplot(1,2,2); histogram(f22, 'BinWidth', 1);
%%
notSimilar1 = sum(f11<1)/numel(f11);
notSimilar2 = sum(f22<1)/numel(f22);

figure;
h = bar([1-notSimilar1, notSimilar1], 0.5);
h.FaceColor = [0.4 0 0];
ax = gca;
ax.XTickLabels = {'Sister is more similar', 'Neighbor is more similar'};
title('Brachyury/Venus');
ax.FontSize = 14;
ax.FontWeight = 'bold';
ylabel('Fraction of cells');


figure;
h = bar([1-notSimilar2, notSimilar2], 0.5);
h.FaceColor = [0.4 0 0];
ax = gca;
ax.XTickLabels = {'Sister is more similar', 'Neighbor is more similar'};
title('CDX2/Venus');
ax.FontSize = 14;
ax.FontWeight = 'bold';
ylabel('Fraction of cells');
%%
% plot a histogram of distance between the sisters and distance between the
% neighbors in case of similar and not-similar cases for both Brachyury and
% CDX2.

% brachyury:-
similar = find(f11>1);
distance1 = sisterInfo1(similar,4) - neighbourInfo1(similar,4);
lin1 = neighbourInfo1(similar,3);
time1 =  sisterInfo1(similar,3);
time2 = sisterInfo1(notSimilar,3);

notSimilar = find(f11<1);
distance2 = sisterInfo1(notSimilar,4) - neighbourInfo1(notSimilar,4);
lin2 = neighbourInfo1(notSimilar,3);

figure;
xlabels = {'d(sister) - d(neighbor)'};
titles = {'sister is more similar', 'neighbor is more similar'};

toPlot = {distance1, distance2};
for ii = 1:2
    subplot(1,2,ii); 
    h = histogram(toPlot{ii}, 'Binwidth', 10 );
    mean(toPlot{ii})
    h.FaceColor = [0.4 0 0 ];
    xlabel(xlabels{1});
    title(titles{ii});
    ax = gca;
    ax.FontSize = 12;
    ax.FontWeight = 'bold';
end
%%
% are cells similar to their sisters because they divide later?
toPlot = {time1, time2};
xlabels = {'time(h) after treatment'};
figure;
for ii = 1:2
    subplot(1,2,ii); 
    h = histogram(toPlot{ii}, 'Binwidth', 4 );
    mean(toPlot{ii})
    h.FaceColor = [0.4 0 0 ];
    xlabel(xlabels{1});
    title(titles{ii});
    ax = gca;
    ax.FontSize = 12;
    ax.FontWeight = 'bold';
end

%%
xlabels = {'d(sister) - d(neighbor)'};
titles = {'sister is more similar', 'neighbor is more similar'};
% CDX2
similar = find(f22>1);
distance1 = sisterInfo1(similar,4) - neighbourInfo1(similar,4);
mean(distance1)

notSimilar = find(f22<1);
distance2 = sisterInfo1(notSimilar,4) - neighbourInfo1(notSimilar,4);
mean(distance2)

time1 =  sisterInfo1(similar,3);
time2 = sisterInfo1(notSimilar,3);

figure;
toPlot = {distance1, distance2};
for ii = 1:2
    subplot(1,2,ii); 
    h = histogram(toPlot{ii}, 'Binwidth', 15 );
    h.FaceColor = [0.4 0 0 ];
    xlabel(xlabels{1});
    title(titles{ii});
    ax = gca;
    ax.FontSize = 12;
    ax.FontWeight = 'bold';
end
%%

























