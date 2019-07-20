function [titles, functions] = defineFunctions()
%% defines various possible interesting data to consider for plotting.

fun1 = @(x) x(:,5); %dapi

fun2 = @(x) x(:,6)./x(:,5); %nuclear smad2/dapi
%fun2 = @(x) x(:,6);

fun3 = @(x) (x(:,6) + x(:,7))./x(:,5); %total smad2/dapi
fun4 = @(x) x(:,6)./x(:,7); %nuclear/cytoplasmic smad2

fun5 = @(x) floor(x(:,8));%./x(:,5); %nuclear nodal/dapi
fun6 = @(x) floor(x(:,8) + x(:,9));%./x(:,5); %total nodal/dapi
fun7 = @(x) floor(x(:,8)./x(:,9)); %nuclear/cytoplasmic nodal.

fun8 = @(x) floor(x(:,9));%./x(:,5); %nuclear lefty/dapi
fun9 = @(x) floor(x(:,10) + x(:,11)); %./x(:,5); %total lefty/dapi
fun10 = @(x) floor(x(:,10)./x(:,11)); %nuclear/cytoplasmic lefty

titles = {'DAPI', 'nuclear smad2',  'total smad2/DAPI', 'nuclear/cytoplasmic smad2', ...
    'nuclear nodal/DAPI', 'nodal mRNA/DAPI', 'nuclear/cytoplasmic nodal', ...
    'nuclear lefty/DAPI', 'lefty mRNA/DAPI', 'nuclear/cytoplasmic lefty'};

functions = {fun1, fun2, fun3, fun4, fun5, fun6, fun7, ...
    fun8, fun9, fun10};