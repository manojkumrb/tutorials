close all; clear
run C:\Users\babu_m\Documents\GitHub\source\initFiles.m

F = 3; % number of features
% phi = @(a)(bsxfun(@power,a,0:F-1));
ell =2;
phi = @(a)(exp(-0.5 * bsxfun(@minus,a,linspace(-8,8,30)).^2 ./ell.^2));
k = @(a,b)(5*exp(-0.25*bsxfun(@minus,a,b').^2));
filename = 'test';

MakeGaussPlot(k,filename)