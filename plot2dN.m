function h=plot2dN(x,y,mu,sig)
% plot 2d
% h is the handle to the figure

% data to test funciton
% mu		= [0 0];
% sig		= [.25 .3; .3 1];%[1 0; 0 1];
% x		= -3:.05:3; 
% y		= -3:.05:3;
[X1,X2] = meshgrid(x,y);
P		= mvnpdf([X1(:) X2(:)],mu,sig);
P		= reshape(P,length(y),length(x));

h=figure;
ax=gca;
imagesc(ax,x,(y),(P))
set(gca,'YDir','normal','FontSize',12)
hold all
xlabel('x'); ylabel('y');
colormap(flip(hot));


% probability corresponding to 1 and 2 sigma in MVN not sure of the contour values check later
% contour(ax,x,y,P,[0.0965 0.0215],'linecolor','k');  
axis equal

end