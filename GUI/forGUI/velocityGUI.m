function [Vx,Vy] = velocityGUI(ax,image_data,t,pixelsize,immobile,tauLimit,whitenoise);
%%

t = linspace(0,t*size(image_data,3),size(image_data,3))';
% Calculates speed and direction given the coefficients of the 2D fits
[Gtime] = stics_byfft(image_data,mean(image_data(:)),tauLimit);
cropedGtime=autocrop(Gtime,40);
% Does time fit
[coeffGtime] = gaussfitold(double(Gtime),'time',pixelsize,whitenoise);

          
% Plots magnitude of distance, against time

plot(ax,t(1:tauLimit-1),coeffGtime(1:tauLimit-1,5),'ks','MarkerSize',10)
hold(ax,'on')
plot(ax,t(1:tauLimit-1),coeffGtime(1:tauLimit-1,6),'rs','MarkerSize',10)
xlabel(ax,'\tau (s)','FontSize',20)%,'Color',[1 1 1])
ylabel(ax,'corr peak position','FontSize',20)

regressionX = polyfit(t(1:tauLimit),coeffGtime(1:tauLimit,5),1);
hold(ax,'on')
plot(ax,t(1:tauLimit-1),regressionX(1)*(t(1:tauLimit-1))+regressionX(2),'--','Color',[0 0 1],'LineWidth',2)
Vx = regressionX(1);
regressionY = polyfit(t(1:tauLimit),coeffGtime(1:tauLimit,6),1);
hold(ax,'on')
plot(ax,t(1:tauLimit-1),regressionY(1)*(t(1:tauLimit-1))+regressionY(2),'--','Color',[0 0 1],'LineWidth',2)

Vy = regressionY(1);
xlim=get(ax,'XLim');
ylim=get(ax,'YLim');
text(ax,0.4*xlim(2),0.5+median(ylim),['v_{x} =' num2str(Vx) ' \mum s^{-1}'],'Color', [0 0 0],'FontSize',20)
text(ax,0.4*xlim(2),0.3+median(ylim),['v_{y} =' num2str(Vy) ' \mum s^{-1}'],'Color', [1 0 0],'FontSize',20)
    set(ax,'FontSize',20)