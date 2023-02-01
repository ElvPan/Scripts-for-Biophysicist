function [] = plotgaussfitForPubGUI(ax,a, corrFun, pixelsize, whitenoise);

% Plots expt 2D Gaussian with one quarter using fit
% by DK
% July 23/04
% Usage: plotgaussfit(coefficients, experimentalcorrfunction, pixelsize, whitenoise);

%corrFun = autocrop(corrFun,pixelsize);

[X,Y] = meshgrid(-((size(corrFun,2)-1)/2)*pixelsize:pixelsize:((size(corrFun,2)-1)/2)*pixelsize,-((size(corrFun,1)-1)/2)*pixelsize:pixelsize:(size(corrFun,1)-1)/2*pixelsize);
grid = [X Y];

Xaxis = X(1,:);
Yaxis = Y(:,1)';

F = (a(1)*exp(    -((X-a(5)).^2/(a(2)^2)+(Y-a(6)).^2/(a(3)^2))   ) + a(4));
%F = (a(1)*exp(-1*((X-a(4)).^2+(Y-a(5)).^2)/(a(2)^2)) + a(3));

if whitenoise == 'y'
       for j=1:2
       i = find(ismember(corrFun(:,:,:),max(max(corrFun(:,:,:)))));
       corrFun(i) = [NaN];
       end
end

quarter = corrFun;
quarter(1:floor(size(corrFun,1)/2),1:floor(size(corrFun,2)/2)) = F(1:floor(size(corrFun,1)/2),1:floor(size(corrFun,2)/2));



s = surf(ax,Xaxis,Yaxis,corrFun);
set(s,'FaceColor','interp')
set(s,'EdgeColor','none')
set(s,'FaceAlpha',0.7)
hold(ax,'on')
m = mesh(ax,Xaxis,Yaxis,F);
set(m,'EdgeColor',[0.5 0.5 0.5])
set(m,'FaceAlpha',0)
set(ax,'Color','none')
xlabel(ax,'\eta (\mum)','FontSize',20)
ylabel(ax,'\xi (\mum)','FontSize',20)
zlabel(ax,'r(\xi,\eta)','FontSize',20)
%set(gca,'XColor',[0.7 0.7 0.7],'YColor',[0.7 0.7 0.7],'ZColor',[0.7 0.7 0.7])
%set(gca,'FontSize',10)
%set(gcf,'Color','black')
%axis tight