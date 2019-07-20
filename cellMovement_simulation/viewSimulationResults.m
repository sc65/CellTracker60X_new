%%

files = dir(['*.mat']);

counter = 1;
d1 = zeros(1, numel(files));

for ii = 1:numel(files)
    load([files(ii).name], 'displacement');
    d1(counter:counter+49) = displacement; 
    counter = counter+50;
end
%%
figure; 
h = histogram(d1, 'BinWidth', 20, 'Normalization', 'probability');
h.FaceColor = [0.4 0 0];
xlabel('Displacement (\mum)');
ylabel('Fraction of cells');
ax = gca;
ax.FontWeight = 'Bold';
ax.FontSize = 12;