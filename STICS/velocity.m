function [Vx,Vy] = velocity(image_data,timesize,pixelsize,immobile,tauLimit,whitenoise);
%%
t = linspace(0,timesize*size(image_data,3),size(image_data,3))';

% Calculates speed and direction given the coefficients of the 2D fits

% Filters immobile fraction
% if strcmp('y',immobile)
%     image_data = immfilter(image_data);
% end

[Gtime] = stics(image_data,tauLimit);
cropedGtime=autocrop(Gtime,40);
% Does time fit
[coeffGtime] = gaussfitold(Gtime,'time',pixelsize,whitenoise);
%         if tauLimit>size(coeffGtime,2)
%             tauLimit=size(coeffGtime,2);
%         end
            
% Plots magnitude of distance, against time
figure
%subplot(3,4,1)
pos1 = [0.1 0.7 0.2 0.2];
subplot('Position',pos1)
plotgaussfit(coeffGtime(1,1:6),cropedGtime(:,:,1),pixelsize,'n');
zlabel(['r(\xi,\eta,\tau=' num2str(1*timesize) ' s)'],'FontSize',20,'Color',[0 0 0])
 set(gca,'FontSize',10)
%subplot(3,4,5)
pos2 = [0.1 0.4 0.2 0.2];
subplot('Position',pos2)
plotgaussfit(coeffGtime(round(tauLimit/2),1:6),cropedGtime(:,:,round(tauLimit/2)),pixelsize,'n');
zlabel(['r(\xi,\eta,\tau=' num2str(round(tauLimit/2)*timesize) ' s)'],'FontSize',20,'Color',[0 0 0])
 set(gca,'FontSize',10)
%subplot(3,4,9)
pos3 = [0.1 0.1 0.2 0.2];
subplot('Position',pos3)
plotgaussfit(coeffGtime(tauLimit,1:6),cropedGtime(:,:,tauLimit),pixelsize,'n');
zlabel(['r(\xi,\eta,\tau=' num2str(tauLimit*timesize) ' s)'],'FontSize',20,'Color',[0 0 0])
 set(gca,'FontSize',10)
%subplot(3,4,[2:4 6:8 10:12])
pos4 = [0.5 0.15 0.4 0.8];
subplot('Position',pos4)
plot(t(1:tauLimit-1),-coeffGtime(1:tauLimit-1,5),'ok','MarkerSize',10)
hold on
plot(t(1:tauLimit-1),-coeffGtime(1:tauLimit-1,6),'ok','MarkerSize',10)
xlabel('\tau (s)','FontSize',20)%,'Color',[1 1 1])
ylabel('corr peak position','FontSize',20)%,'Color',[1 1 1])
set(gcf,'Color',[1 1 1])

% Prompts user to select end of non noisy data
% [ xlim , ylim ] = ginput(1);
% coeffGtime = coeffGtime(1:max(find(t<=xlim)),:);
% t = t(1:max(find(t<=xlim)),:);
regressionX = polyfit(t(1:tauLimit),-coeffGtime(1:tauLimit,5),1);
hold on
plot(t(1:tauLimit-1),regressionX(1)*(t(1:tauLimit-1))+regressionX(2),'--','Color',[0 0 1],'LineWidth',2)
Vx = regressionX(1);
regressionY = polyfit(t(1:tauLimit),-coeffGtime(1:tauLimit,6),1);
hold on
plot(t(1:tauLimit-1),regressionY(1)*(t(1:tauLimit-1))+regressionY(2),'--','Color',[1 0 0],'LineWidth',2)

Vy = regressionY(1);
xlim=get(gca,'XLim');
ylim=get(gca,'YLim');
text(0.4*xlim(2),1.35+median(ylim),['v_{x} =' num2str(Vx) ' \mum s^{-1}'],'Color', [0 0 1],'FontSize',20)
text(0.4*xlim(2),0.3+median(ylim),['v_{y} =' num2str(Vy) ' \mum s^{-1}'],'Color', [1 0 0],'FontSize',20)
    set(gca,'FontSize',20)