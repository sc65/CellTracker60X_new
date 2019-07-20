%%

moveFrom = '35_40h';
moveTo = '40h';
mkdir(moveTo);

counter = 1;

for ii = 7:12
    movefile([moveFrom filesep 'Colony_' int2str(ii) '_ch1.tif'], ...
        [moveTo filesep 'Colony_' int2str(counter) '_ch1.tif']);
    
     movefile([moveFrom filesep 'Colony_' int2str(ii) '.tif'], ...
        [moveTo filesep 'Colony_' int2str(counter) '.tif']);  
    
    counter = counter+1;
end