% Gaussian Bayes demo (adapted from kevin murhpy's code)
close all
clear

% true param
nSample	= 30;
mu		=3;
sigma	= 1;

% data fron given idst
y	= bsxfun(@plus,randn(1,nSample).*sqrt(sigma),mu);
hist(y)

% prior
mu_0 = 0;
%sigma2_0 = 10;
sigma2_0 = 1;
%%

meanOld =0; % for iterative update
sigma2 = 1;

for i= 1:nSample
 % lik -  using sufficient statatistic and avoiding likelihood
 % multiplication (refer kevin murphy tutorial)
 mu_ML = meanOld+(y(i)-meanOld)/(i+1);   % iterative mean update
 meanOld =mu_ML;
 N = i;
 
 
 % post
 sigma2_N = (sigma2 * sigma2_0) / (N*sigma2_0 + sigma2);
 mu_N = sigma2_N*(N*mu_ML/sigma2 + mu_0/sigma2_0);
 
 figure(2); clf
 xs = -5:0.01:5;
 prior = normpdf(xs, mu_0, sqrt(sigma2_0));
 lik = normpdf(xs, mu_ML, sigma2/N);
 post = normpdf(xs, mu_N, sqrt(sigma2_N));
 plot(xs, prior, 'r-', 'linewidth', 2);
 hold on
 plot(xs, lik, 'g:', 'linewidth', 2);
 plot(xs, post, 'b-.', 'linewidth', 2);
 legend('prior','lik','post')
 title(sprintf('prior sigma %4.3f', sigma2_0)) 
 scatter(y(1:i),ones(1,i),'filled');
 drawnow
 pause
end

