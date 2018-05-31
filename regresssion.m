close all; clear
dbstop if error
run C:\Users\babu_m\Documents\GitHub\source\initFiles.m

% %% auto mpg
% data = xlsread('autoMPEG.xlsx');
% scatter(data(1:10,5),data(1:10,6));
% title('Auto Miles per gallon Data')
% xlabel('Weight')
% ylabel('Miles per Gallon(MpG)')

% generating  data
F = 6; % number of features
phi = @(a)(bsxfun(@power,a,0:F-1));
xTrain	= (-5:0.5:5)';
y	= sum(phi(xTrain),2);
fig =figure;
originalData	= scatter(xTrain,y,'filled');
dataOrder		= sprintf('Data of order %d',F-1);
title(dataOrder)
hold all
%%

xTest		= (-7:0.5:7)';

% Fitting various functions
F = 1; % number of features
phi		= @(a)(bsxfun(@power,a,0:F-1));
phix	= phi(xTrain);
w		= (phix'*phix)\phix'*y;

phixTest	= phi(xTest);
yFit	= phixTest*w;
regOrder = sprintf('Fit of order %d',F-1);
fittedCur = scatter(xTest,yFit);
legend(fittedCur,regOrder)

%%
F = 3; % number of features
phi		= @(a)(bsxfun(@power,a,0:F-1));
phix	= phi(xTrain);
w		= (phix'*phix)\phix'*y;

phixTest	= phi(xTest);
yFit	= phixTest*w;
regOrder = sprintf('Fit of order %d',F-1);
fittedCur = scatter(xTest,yFit);
legend(fittedCur,regOrder)

%%
F = 5; % number of features
phi		= @(a)(bsxfun(@power,a,0:F-1));
phix	= phi(xTrain);
w		= (phix'*phix)\phix'*y;

phixTest	= phi(xTest);
yFit	= phixTest*w;
regOrder = sprintf('Fit of order %d',F-1);
fittedCur = scatter(xTest,yFit);
legend(fittedCur,regOrder)
%%
F = 10; % number of features
phi		= @(a)(bsxfun(@power,a,0:F-1));
phix	= phi(xTrain);
w		= (phix'*phix)\phix'*y;

phixTest	= phi(xTest);
yFit	= phixTest*w;
regOrder = sprintf('Fit of order %d',F-1);
fittedCur = scatter(xTest,yFit);
legend(fittedCur,regOrder)
%%
F = 20; % number of features
phi		= @(a)(bsxfun(@power,a,0:F-1));
phix	= phi(xTrain);
w		= (phix'*phix)\phix'*y;

phixTest	= phi(xTest);
yFit	= phixTest*w;
regOrder = sprintf('Fit of order %d',F-1);
fittedCur = scatter(xTest,yFit);
legend(fittedCur,regOrder)

%% rbf 

ell =2;
phi = @(a)(exp(-0.5 * bsxfun(@minus,a,-5:1:5).^2 ./ell.^2));

phix	= phi(xTrain);
w		= (phix'*phix)\phix'*y;

phixTest	= phi(xTest);
yFit	= phixTest*w;
regOrder = 'RBF regression';
fittedCur = scatter(xTest,yFit,'*');
legend(fittedCur,regOrder)

%% truth

F = 6; % number of features
phi = @(a)(bsxfun(@power,a,0:F-1));
y	= sum(phi(xTest),2);
originalData	= scatter(xTest,y,'filled');

% ell =1;
% phi = @(a)(exp(-0.5 * bsxfun(@minus,a,linspace(-8,8,16)).^2 ./ell.^2));
% k = @(a,b)(5*exp(-0.25*bsxfun(@minus,a,b').^2));
% filename = 'test';
% 
% MakeGaussPlot(k,filename)