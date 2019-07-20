function peaks = peakscelltrackerformat(peaks1)

ncolumn = size(peaks1,2);


peaks(:,1:3) = peaks1(:,1:3);


% arbitrary values for columns 4, 5 - just to make the output
% compatible with celltracker peaks output.

%peaks(:,3) = 1000;
peaks(:,4) = -1;
peaks(:,5) = 100;

channelno = 4;
if(ncolumn > 3)
    
    for i = 6:6+(ncolumn-3-1)
        peaks(:,i) = peaks1(:,channelno);
        channelno = channelno+1;
    end
end
end


