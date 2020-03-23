
figure
[X,Y] = meshgrid(-((size(aveCropCorr,2)-1)/2)*pixelsize:pixelsize:((size(aveCropCorr,2)-1)/2)*pixelsize,-((size(aveCropCorr,1)-1)/2)*pixelsize:pixelsize:(size(aveCropCorr,1)-1)/2*pixelsize);
grid = [X Y];
subplot(1,2,1)
   s=surf(X,Y,aveCropCorr);
   axis tight
   colormap(jet)
   xlabel('\eta (\mum)','FontSize',13)
   ylabel('\xi (\mum)','FontSize',13)
   zlabel('r(\xi,\eta)','FontSize',13)
   set(s,'LineStyle','none')
   title('Average Cropped Spatial Autocorrelation Function')
    subplot(1,2,2)
   
    plotgaussfitForPub(a(1,1:6),aveCropCorr,pixelsize,removeG00);
    title('Fit of Average Cropped Spatial Autocorrelation Function')
    % results of fit
    particlesPerBeamArea = 1/a(1,1)
    beamArea = pi*a(:,2)*a(:,3)
    density = particlesPerBeamArea/beamArea
    zlim=get(gca,'ZLim');
    xlim=get(gca,'XLim');
    ylim=get(gca,'YLim');
    text(xlim(2),ylim(2),0.9*zlim(2),['Beam Area =' num2str(round(beamArea,2,'significant')) ' \mum^{2}'],'Color',[1 0 0])
    text(xlim(2),ylim(2),0.8*zlim(2),['Particles Per Beam Area =' num2str(round(particlesPerBeamArea,2,'significant'))],'Color',[1 0 0])
    text(xlim(2),ylim(2),0.7*zlim(2),['Particles Density =' num2str(round(density,2,'significant')) ' \mum^{-2}'],'Color',[1 0 0])
    %set(gcf,'Position',[109.5000  239.0000  891.0000  451.0000])
    set(gcf,'Position',[30 30 1015 466])
    set(gcf,'Color',[1 1 1])
    %set(gca,'FontSize',15)