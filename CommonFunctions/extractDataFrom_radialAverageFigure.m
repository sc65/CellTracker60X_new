%% given a .m figure, this function extracts x, y and error bar values. 

h = gcf;
axesObjs = get(h, 'Children');  %axes handles
dataObjs = get(axesObjs, 'Children'); 

ydata = get(dataObjs, 'YData');
xdata = get(dataObjs, 'XData');
%%
errorbars = [1 3 5]; % position in dataObjs
rA = [2 4 6]; 

rA_new = zeros(25,3);
error_new = rA_new;
%%
for ii = 1:3
    rA1 = ydata{rA(ii)};
    error1 = get( dataObjs(errorbars(ii)), 'YPositiveDelta');
    
    rA_new(:,ii) =  rA1./max(rA1);
    error_new(:,ii) = error1;
end