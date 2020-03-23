%% Basic ICS, TICS and STICS
% following part prompts user what type of analysis to perform...depending
% of data simulated, if FCS then user should choose FCS, otherwise choose
% one of ICS analysis depending of what was simulated and suggested in the
% guide...
choice = chooseMethod;
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';

% correct for noise if central reagion plus 'outside of the cell' noisy
% data present
if masksize>0
    %crop data to central area of interest
    [image_data]=cropcentral(image_data,masksize);
end
if strcmp(choice,'Image Correlation Spectroscopy (ICS) for <N>')
    prompt = {'Pixel size (\mum)','Analyse image #','Fit Average (y or n)','Exclude G(0,0) from fit (y or n)?'};
dlg_title = 'Enter analysis Parameters';
defaultans = {num2str(pixelsize),num2str(1),'n','n'};
answer = inputdlg(prompt,dlg_title,[1 100],defaultans,options);
pixelsize=str2double(answer{1});
im=str2double(answer{2});
analyseAve=answer{3};
removeG00=answer{4};

% calculate ICS and display results
ICS2DCorr = corrfunc(image_data);
ICS2DCorrCrop = autocrop(ICS2DCorr,20);
%do ICS on a specific image and no averaging over all CF...
if strcmp(analyseAve,'n')
   a  = gaussfitold(ICS2DCorrCrop(:,:,im),'2d',pixelsize,removeG00);
   
   figure
  [X,Y] = meshgrid(-((size(ICS2DCorrCrop,2)-1)/2)*pixelsize:pixelsize:((size(ICS2DCorrCrop,2)-1)/2)*pixelsize,-((size(ICS2DCorrCrop,1)-1)/2)*pixelsize:pixelsize:(size(ICS2DCorrCrop,1)-1)/2*pixelsize);
   grid = [X Y];
   subplot(1,2,1)
   s=surf(X,Y,ICS2DCorrCrop(:,:,im));
   axis tight
   colormap(jet)
   xlabel('\eta (\mum)','FontSize',13)
   ylabel('\xi (\mum)','FontSize',13)
   zlabel('r(\xi,\eta)','FontSize',13)
   set(s,'LineStyle','none')
   title('Average Cropped Spatial Autocorrelation Function')
    subplot(1,2,2)
   
    plotgaussfitForPub(a(1,1:6),ICS2DCorrCrop(:,:,im),pixelsize,removeG00);
    title('Fit of Average Cropped Spatial Autocorrelation Function')
    % results of fit
    particlesPerBeamArea = 1/a(1,1);
    beamArea = pi*a(:,2)*a(:,3);
    density = particlesPerBeamArea/beamArea;
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
%    subplot(1,2,1)
%    s=surf(ICS2DCorrCrop(:,:,im));
%    axis tight
%    colormap(jet)
%    xlabel('\eta','FontSize',12)
%    ylabel('\xi','FontSize',12)
%    zlabel('r(\xi,\eta)','FontSize',12)
%    set(s,'LineStyle','none')
%    title(['Cropped Spatial Autocorrelation Function for Image' num2str(im)])
%    set(gcf,'Color','black') 
%    subplot(1,2,2)
%    title(['Fit for Cropped Spatial Autocorrelation Function for Image' num2str(im)])
%     plotgaussfit(a(1,1:6),ICS2DCorrCrop(:,:,im),pixelsize,removeG00);
%     set(gcf,'Position',[30 30 1015 466])
%     % results of fit
%     particlesPerBeamArea = 1/a(1,1)
%     beamArea = pi*a(:,2)*a(:,3)
%     density = particlesPerBeamArea/beamArea
%      zlim=get(gca,'ZLim');
%     xlim=get(gca,'XLim');
%     ylim=get(gca,'YLim');
%     text(xlim(2),ylim(2),0.9*zlim(2),['Beam Area =' num2str(beamArea) ' \mum^{2}'],'Color',[1 1 1])
%     text(xlim(2),ylim(2),0.8*zlim(2),['Particles Per Beam Area =' num2str(particlesPerBeamArea)],'Color',[1 1 1])
%     text(xlim(2),ylim(2),0.7*zlim(2),['Particles Density =' num2str(density) ' \mum^{-2}'],'Color',[1 1 1])
% do ICS on all images and then average CF before fitting...
elseif strcmp(analyseAve,'y')
    aveCropCorr=mean(ICS2DCorrCrop,3);
     a  = gaussfitold(aveCropCorr,'2d',pixelsize,removeG00);
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
    particlesPerBeamArea = 1/a(1,1);
    beamArea = pi*a(:,2)*a(:,3);
    density = particlesPerBeamArea/beamArea;
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
else
     error('Answer should either be ''y'' or ''n''.')
end
% do TICS on data and depending of choice of fitting model, perform fitting
% and dispay raw correlation function with fit results superimposed...
elseif strcmp(choice,'Temporal-ICS for speed and diffusion') % TICS menu
    close
    GtDiff = tics(image_data,1);
    plot(GtDiff(:,1),GtDiff(:,2),'o')
    set(gca,'XScale','log');
    xlabel('\tau (frames)','FontSize',20)
    ylabel('<r_{11}(0,0,\tau)>','FontSize',20)
    set(gcf,'Color',[1 1 1])
    set(gca,'FontSize',20)
    %choicetics = menu('Choose which model to fit TICS fn ','1 component Diffusion','1 component flow','Sum of 1 component diffusing and 1 component flowing','Single component 3D diffusion');
    choicetics = chooseFitting;
    close 
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='tex';
     prompt = {'Frame Time (s)','PSF e^{-2} radius (um)','\tau_{max} to fit (frames)','Axial PSF e^{-2} radius (um)'};
     dlg_title = 'Enter analysis Parameters';
     defaultans = {num2str(timesize),num2str(PSFSize),num2str(round(sizeT/5)),num2str(PSFZ)};
     answer = inputdlg(prompt,dlg_title,[1 100],defaultans,options);
     timesize=str2double(answer{1});
     PSFSize=str2double(answer{2});
     taumax=str2double(answer{3});
     PSFZ=str2double(answer{4});
    if strcmp(choicetics,'1 component Diffusion')
    diffFitting = difffit(GtDiff(1:taumax,1)*timesize,GtDiff(1:taumax,2),PSFSize); 
     elseif strcmp(choicetics,'1 component flow')
    flowFitting = flowfit(GtDiff(1:taumax,1)*timesize,GtDiff(1:taumax,2),PSFSize);
     elseif strcmp(choicetics,'Sum of 1 component diffusing and 1 component flowing')
     diffflowFitting= diffflowfit(GtDiff(1:taumax,1)*timesize,GtDiff(1:taumax,2),PSFSize);   
     elseif strcmp(choicetics,'Single component 3D diffusion')
     Dfif3dFitting = difffit3d(GtDiff(1:taumax,1)*timesize,GtDiff(1:taumax,2),PSFSize,PSFZ);    
    end
    % if choice of analysis was STICS, then proceed with STICS for flow
    % recovery...
elseif strcmp(choice,'Spatio-Temporal-ICS for flow')
    close
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='tex';
    prompt = {'Frame Time (s)','Pixel size (\mum)','\tau_{max} to fit (frames)','Immobile filtering (y or n)'};
     dlg_title = 'Enter analysis Parameters';
     defaultans = {num2str(timesize),num2str(pixelsize),num2str(round(sizeT/5)),'n'};
     answer = inputdlg(prompt,dlg_title,[1 100],defaultans,options);
     timesize=str2double(answer{1});
     pixelsize=str2double(answer{2});
     taumax=str2double(answer{3});
     filtering=answer{4};
     if strcmp(filtering,'y');
         image_data=immfilter(image_data);
     end
     corr=stics_byfft(image_data,mean(image_data(:)),taumax);
     %sv(corr,'c',5)
     % stics proceeds!
    [Vx,Vy] = velocity(image_data,timesize,pixelsize,filtering,taumax,'n');
    set(gcf,'Units','normalized', 'Position',[.05,.05,.8,.8])
    % if simulated data is FCS like, and choice of analysis is FCS, then
    % perform FCS analysis...prompt for fitting model and display fitted
    % results in an image...
elseif strcmp(choice,'FCS')
  close
%  choice
    [corr,lags]=fcs_byfft(image_data,round(sizeT/100));
    figure
    plot((1:length(image_data))*timesize,image_data)
    xlabel('time (s)','FontSize',16)
    ylabel('Intensity (A.U.)','FontSize',16)
    title('Simulated FCS experiment','FontSize',20)
    set(gcf,'Color',[1 1 1])
    set(gca,'FontSize',20)
    set(gcf,'Units','normalized', ...
    'Position',[.1,.4,.4,.4])
    figure
    plot(lags,corr,'o')
    set(gca,'XScale','log');
    xlabel('\tau (time points)','FontSize',20)
    ylabel('<G(\tau)>','FontSize',20)
    set(gcf,'Color',[1 1 1])
    set(gca,'FontSize',20)
    set(gcf,'Units','normalized', ...
    'Position',[.5,.4,.4,.4])
    %choicetics = menu('Choose which model to fit FCS fn ','1 component Diffusion','1 component flow','Sum of 1 component diffusing and 1 component flowing','Single component 3D diffusion');
    choicefcs = chooseFitting;
    close all
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='tex';
     prompt = {'Sampling time (s)','PSF e^{-2} radius (\mum)','\tau_{max} to fit','Axial PSF e^{-2} radius (\mum)'};
     dlg_title = 'Enter analysis Parameters';
     defaultans = {num2str(timesize),num2str(PSFSize),num2str(round(sizeT/100)),num2str(PSFZ)};
     answer = inputdlg(prompt,dlg_title,[1 100],defaultans,options);
     timesize=str2double(answer{1});
     PSFSize=str2double(answer{2});
     taumax=str2double(answer{3});
     PSFZ=str2double(answer{4});
     % depending of fitting model selected, proceed with fitting...
      if strcmp(choicefcs,'1 component Diffusion')
    diffFitting = difffit_fcs(lags(1:taumax)*timesize,corr(1:taumax),PSFSize,PSFZ); 
     elseif strcmp(choicefcs,'1 component flow')
    flowFitting = flowfit_fcs(lags(1:taumax)*timesize,corr(1:taumax),PSFSize,PSFZ);
     elseif strcmp(choicefcs,'Sum of 1 component diffusing and 1 component flowing')
     diffflowFitting= diffflowfit_fcs(lags(1:taumax)*timesize,corr(1:taumax),PSFSize,PSFZ);   
     elseif strcmp(choicefcs,'Single component 3D diffusion')
     Diff3dFitting = difffit3d_fcs(lags(1:taumax)*timesize,corr(1:taumax),PSFSize,PSFZ);    
    end
end