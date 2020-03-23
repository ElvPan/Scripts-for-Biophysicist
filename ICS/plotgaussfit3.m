function [fig] = plotgaussfit3(a, corrFun, pixelsize, whitenoise);

% Plots assymetric 2D Gaussian with one quarter using fit
% by DK modifed by EP 2011
% July 23/04
% Usage: plotgaussfit(coefficients, experimentalcorrfunction, pixelsize, whitenoise);

%corrFun = autocrop(corrFun,pixelsize);

[X,Y] = meshgrid(-((size(corrFun,2)-1)/2)*pixelsize:pixelsize:((size(corrFun,2)-1)/2)*pixelsize,-((size(corrFun,1)-1)/2)*pixelsize:pixelsize:(size(corrFun,1)-1)/2*pixelsize);
grid = [X Y];

Xaxis = X(1,:);
Yaxis = Y(:,1)';

X = grid(:,1:size(grid,2)/2);
Y = grid(:,size(grid,2)/2+1:end);
Xprim=X.*cos(a(1,6))-Y.*sin(a(1,6));
Yprim=X.*sin(a(1,6))+Y.*cos(a(1,6));
x0rot = a(1,2)*cos(a(1,6)) - a(1,4)*sin(a(1,6));
y0rot = a(1,2)*sin(a(1,6)) + a(1,4)*cos(a(1,6));


F = (a(1,1)*exp(    -((Xprim-x0rot ).^2/(a(1,3)^2)+(Yprim-y0rot ).^2/(a(1,5)^2))   ) + a(1,7));

if whitenoise == 'y'
       for j=1:2
       i = find(ismember(corrFun(:,:,:),max(max(corrFun(:,:,:)))));
       corrFun(i) = [NaN];
       end
end

quarter = corrFun;
quarter(1:floor(size(corrFun,1)/2),1:floor(size(corrFun,2)/2)) = F(1:floor(size(corrFun,1)/2),1:floor(size(corrFun,2)/2));

% figure
% 
% surf(Xaxis,Yaxis,quarter,'FaceColor','interp','EdgeColor','none','FaceLighting','phong')
% xlabel('\eta (\mum)','FontSize',12)
% ylabel('\xi (\mum)','FontSize',12)
% zlabel('g(\xi,\eta)')
% axis tight
% camlight left

% If it's being run from the gui, plot in the gui... 
% makes new figure otherwise
if evalin('caller','exist(''h'')') == 1
   evalin('caller','axes(handles.ICSDisplay)')
else
   fig=figure
end

s = surf(Xaxis,Yaxis,corrFun);
set(s,'FaceColor','interp')
set(s,'EdgeColor','none')
set(s,'FaceAlpha',0.7)
hold on
m = mesh(Xaxis,Yaxis,F);
set(m,'EdgeColor',[0.5 0.5 0.5])
set(m,'FaceAlpha',0)
set(gca,'Color','none')
xlabel('\eta (\mum)','FontSize',12,'Color',[1 1 1])
ylabel('\xi (\mum)','FontSize',12,'Color',[1 1 1])
zlabel('r(\xi,\eta)','FontSize',12,'Color',[1 1 1])
set(gca,'XColor',[0.7 0.7 0.7],'YColor',[0.7 0.7 0.7],'ZColor',[0.7 0.7 0.7])
set(gca,'FontSize',10)
set(gcf,'Color','black')
axis tight