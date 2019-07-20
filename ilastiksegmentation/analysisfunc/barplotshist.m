%%
for ch = 1:2
    resultpath = '/Users/sapnac18/Desktop/Experiments/1508FISHMP200um/';
    
    % mrna bar plots and histograms
    
    file1 = sprintf('/Users/sapnac18/Desktop/Experiments/1508FISHMP200um/mrnapercell%02d', ch);
    mkdir(file1);
    file2 = sprintf('/Users/sapnac18/Desktop/Experiments/1508FISHMP200um/mrnahistograms%02d', ch);
    mkdir(file2);
    
    for i = 1:25
        
        figure('visible', 'off');
        
        bar(mrnapcell{i}{ch},0.5);
        xlabel('Cells', 'FontSize', 14);
        ylabel('No. of mrna', 'FontSize', 14);
        
        filename = sprintf('colony%02d', i);
        file = strcat(file1,'/', filename);
        set(gcf,'PaperPositionMode','auto');
        saveas(gcf, file, 'pdf');
        
        
        figure('visible', 'off');
        
        hist(mrnapcell{i}{ch});
        xlabel('No. of mrna', 'FontSize', 14);
        ylabel('No. of cells', 'FontSize', 14);
        
        filename = sprintf('colony%02d', i);
        file = strcat(file2,'/', filename);
        set(gcf,'PaperPositionMode','auto');
        saveas(gcf, file, 'pdf');
        
    end
end
