ell = 3;
sf	= 1;
k	= @(a,b)(sf*exp(-(bsxfun(@minus,a,b').^2)./(2*ell^2)));
nSample		= 5;

nDimension	= 4;
mu			= zeros(nDimension,1);
xTrain		= linspace(-3,3,nDimension)';

kPrior		= k(xTrain,xTrain);





idXTest		= input('Set a Dimension to be fixed:');
YTest		= input('Set the value of the fixed dimension:');

xx			=xTrain;
% xx(idXTest)	=[];
XX			=xTrain(idXTest); % x= unknowns, X= knowns

kxx			=k(xx,xx);
kXX			=k(XX,XX);
kxX			=k(xx,XX);
% bsxfun(@minus,xx',XX)
cholCov		= chol(kXX+1e-8*eye(size(kXX)));
% findind inverse by cholsky factorisation
% V		= G'G
% V^-1	= G^(-1)G'^(-1)


mPost		= mu+(kxX/kXX)*(YTest-mu(idXTest));
varPost		= kxx-(kxX/kXX)*kxX';


factCov		= chol(varPost+1e-12*eye(size(varPost)));
sample		= repmat(mPost,1,nSample)+factCov*randn(nDimension,nSample);


figure
axLinePlt	= gca;
set(axLinePlt,'NextPlot', 'add')
axLinePlt.XTick = 1:1:20;

for i=1:nSample		
	plot(axLinePlt,sample(:,i),'-*')
	pause;
end

