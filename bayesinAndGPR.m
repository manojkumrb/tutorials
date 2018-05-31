

%% generating data
F = 6; % number of features
phi = @(a)(bsxfun(@power,a,0:F-1));
xTrain	= (-5:0.5:5)';
y	= sum(phi(xTrain),2);
originalData	= scatter(xTrain,y,'filled');


% prior on w 
F = 2; % number of features
phi = @(a)(bsxfun(@power,a,0:F-1)); % ?(a) = [1; a]
mu = zeros(F,1);
Sigma = eye(F); % p(w) = N (µ; ?)
% implied prior on fx
n = 100;
x = linspace(-8,8,n)'; % ‘test' points
m = phi(x) * mu;
kxx = phi(x) * Sigma * phi(x)'; % p(fx) = N (m; kxx)
s = bsxfun(@plus,m,chol(kxx + 1.0e-8 * eye(n))' * randn(n,3)); % samples from prior
stdpi = sqrt(diag(kxx)); % marginal stddev, for plotting
load('data.mat'); N = length(Y); % gives Y,X,sigma
% prior on Y = fX + 
M = phi(X) * mu;
kXX = phi(X) * Sigma * phi(X)'; % p(fX ) = N (M; kXX ), p(Y ) = N (M; kXX + ?2I)
% inference
G = chol(kXX + sigma^2 * eye(N)); % most expensive step: O(N 3)
kxX = phi(x) * Sigma * phi(X)'; % cov(fx; fX ) = kxX
A = kxX / G; % pre-compute for re-use
mpost = m + A * (G' \ (Y-M)); % p(fx ? Y ) = N (m + kxX (kXX + ?2I)?1(Y ? M);
vpost = kxx - A * A'; % kxx ? kxX (kXX + ?2I)?1kXx)
spost = bsxfun(@plus,mpost,chol(vpost + 1.0e-8 * eye(n))' * randn(n,3)); % samples
stdpo = sqrt(diag(vpost)); % marginal stddev, for plotting