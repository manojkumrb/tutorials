%% Bayesian and GP Regression demo
% Inspired by D J Mackay lecture (http://videolectures.net/gpip06_mackay_gpb/)

close all; clear
dbstop if error
run C:\Users\babu_m\Documents\GitHub\source\initFiles.m

%{
%% gp conceptual
ell = 3;
sf	= 1;
k	= @(a,b)(sf*exp(-(bsxfun(@minus,a,b').^2)./(2*ell^2)));
nSample		= 5;

%%%%%one dimensional
oneDx	= linspace(-3,3,400);
mu1		= 0;
var1	= 1;
%%%%%%%%%%%%%%%%%%%%%%%%

p1D	= normpdf(oneDx, mu1, sqrt(var1));

oneDfig = figure;
axoned	= subplot(1,2,1, 'NextPlot', 'add');
axline	= subplot(1,2,2, 'NextPlot', 'add');
plot(axoned,oneDx,p1D,'m')
hold all

for i=1:nSample
	
	oneDxSample(i)	= randn()*sqrt(var1)+mu1;
	plot(axoned,oneDxSample(i),0.2,'*')
	
	plot(axline,1,oneDxSample(i),'*')
	%%%%%%%
	%pause;
	%%%%%%%
end
%%
%%% 2 dimensional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x	= linspace(-3,3,400);
y	= linspace(-3,3,400);
mu	= [0  0];
sig	= [1 .3;.3,1];
h	= plot2dN(x,y,mu,sig);

figure
axLinePlt	= gca;
set(axLinePlt,'NextPlot', 'add')

R	= chol(sig);
z	= repmat(mu,nSample,1) + randn(nSample,2)*R;

for i=1:nSample	
	plot(h.Children,z(i,1),z(i,2),'*')
	plot(axLinePlt,z(i,:),'-*')
	%pause;
end
%%
% higher dimensions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nDimension	= 6;
mu			= zeros(1,nDimension);
xD			= linspace(-3,3,nDimension);
kxx			= k(xD,xD);
factCov		= chol(kxx+1e-8*eye(size(kxx)));

sample		= repmat(mu,nSample,1)+randn(nSample,nDimension)*factCov;


figure
axLinePlt	= gca;
set(axLinePlt,'NextPlot', 'add')
axLinePlt.XTick = 1:1:20;

for i=1:nSample		
	plot(axLinePlt,sample(i,:),'-*')
	%pause;
end


%% conditioning

ell = 3;
sf	= 1;
k	= @(a,b)(sf*exp(-(bsxfun(@minus,a,b').^2)./(2*ell^2)));
nSample		= 5;


x	= linspace(-3,3,400);
y	= linspace(-3,3,400);
mu	= [0 0];
sig	= [1 .3;.3,1];
bvnFig = plot2dN(x,y,mu,sig);

% bivariate conditional normal mean and variance
meanXGivenY		= @(mu,y,sigma) (mu(1)+(sigma(1,2)/sigma(2,2))*(y-mu(2)));
varXgivY		= @(sigma) (sigma(1,1)-(sigma(1,2)^2/sigma(2,2)));

meanYGivenX		= @(mu,x,sigma) (mu(2)+(sigma(1,2)/sigma(2,2))*(x-mu(1)));
varYgivX		= @(sigma) (sigma(2,2)-(sigma(1,2)^2/sigma(1,1)));

%%%%%input%%%%%%%
xCond	= 1;%input('condition for value of x:');
%%%%%%%%%%%%%%%%%
nMeanY	= meanYGivenX(mu,xCond,sig);
NvarY	= varYgivX(sig);
conDeny	= normpdf(y, nMeanY, sqrt(NvarY));
plot(bvnFig.Children,conDeny+xCond.*ones(size(y)),y, 'g', 'linewidth', 2);
plot(bvnFig.Children,xCond.*ones(size(x)),y, 'k', 'linewidth', 2);



figure
axLinePlt	= gca;
set(axLinePlt,'NextPlot', 'add')
axLinePlt.XTick = 1:1:20;


z(:,2)	= repmat(nMeanY,nSample,1) + randn(nSample,1)*sqrt(NvarY);
z(:,1)	= xCond;

for i=1:nSample	
	plot(bvnFig.Children,z(i,1),z(i,2),'*')
	plot(axLinePlt,z(i,:),'-*')
	%pause;
end
%}
%%%%%%%%%%%%%%%
% for a line , giff generated

ell = 2;
sf	= 1;
k	= @(a,b)(sf*exp(-(bsxfun(@minus,a,b').^2)./(2*ell^2)));


nSample		= 10;
nDimension	= 8;
mu			= zeros(nDimension,1);
xTrain		= linspace(1,8,nDimension)';

kPrior		= k(xTrain,xTrain);


idXTest		= [2;5];%input('Set a Dimension to be fixed (Enter multiple \n values as a column vector):');
YTest		= [1;0];%input('Set the value of the fixed dimension (Enter multiple \n values as a column vector):');

xx			=xTrain;
XX			=xTrain(idXTest); % x= unknowns, X= knowns

kxx			=k(xx,xx);
kXX			=k(XX,XX);
kxX			=k(xx,XX);
cholCov		= chol(kXX+1e-8*eye(size(kXX)));
% findind inverse by cholsky factorisation
% V		= G'G
% V^-1	= G^(-1)G'^(-1)
mPost		= mu+(kxX/kXX)*(YTest-mu(idXTest));
varPost		= kxx-(kxX/kXX)*kxX';
factCov		= chol(varPost+1e-12*eye(size(varPost)));

sample		= repmat(mPost,1,nSample)+factCov'*randn(nDimension,nSample);

condFig		=figure;

set(gcf,'color',[1 1 1])
set(gca,'color',[1 1 1])

axLinePlt	= gca;
set(axLinePlt,'NextPlot', 'add')
axLinePlt.XTick = 1:1:20;
axLinePlt.YTick = -3:1:3;
axLinePlt.YLim  = [-3 3];
xlabel('X','fontweight','bold');
ylabel('F(X)','fontweight','bold');

fill(axLinePlt,[xx; flip(xx)],...
			[mPost+2*sqrt(diag(varPost));...
			flip(mPost-2*sqrt(diag(varPost)))], [189,215,231]/256,'facealpha',0.4,'lineStyle','none');

for i=1:nSample	
	
	hPline = plot(axLinePlt,xx,sample(:,i),'-','color',[56,108,176]/256,'linewidth',1.5);
	
	if i==1
		scatter(axLinePlt,XX,YTest,'r','filled');
		gif('1dConditonal.gif','frame',condFig,'DelayTime',0.3);
	else
		gif
	end
	
	delete(hPline);
end

% Un conditional 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


factCov		= chol(kPrior+1e-8*eye(size(kPrior)));

sample		= repmat(mu,1,nSample)+factCov'*randn(nDimension,nSample);

for i=1:nSample		
	plot(axLinePlt,sample(:,i),'-')
	
end

unCondFig		=figure;

set(gcf,'color',[1 1 1])
set(gca,'color',[1 1 1])

axLinePlt	= gca;
set(axLinePlt,'NextPlot', 'add')
axLinePlt.XTick = 1:1:20;
axLinePlt.YTick = -3:1:3;
axLinePlt.YLim  = [-3 3];
xlabel('X','fontweight','bold');
ylabel('F(X)','fontweight','bold');


fill(axLinePlt,[xx; flip(xx)],...
			[mu+2*sqrt(diag(kPrior));...
			flip(mu-2*sqrt(diag(kPrior)))], [189,215,231]/256,'facealpha',0.4,'lineStyle','none');

for i=1:nSample	
	
	
	
	if i==1
		hPline	= plot(axLinePlt,xx,sample(:,i),'-','color',[56,108,176]/256,'linewidth',1.5);
		hPoints = scatter(axLinePlt,XX,sample(idXTest,i),'r','filled');
		gif('1dUnConditonal.gif','frame',unCondFig,'DelayTime',0.3);
	else
		hPline	= plot(axLinePlt,xx,sample(:,i),'-','color',[56,108,176]/256,'linewidth',1.5);
		hPoints = scatter(axLinePlt,XX,sample(idXTest,i),'r','filled');
		gif
	end
	
	delete(hPline);
	delete(hPoints);
	
end
