%%%%%%%% This function is used as a times series simulator %%%%%%%
%%%%%%%%% Prompt user to define simulation parameters %%%%%%%%

% this part prompts user to select parameters for simulation
clear all
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
prompt = {'# of dynamical species','Image size in x (pixels)','Image size in y (pixels)','# of images in series','Pixel size (\mum)','Frame time (s)','PSF type (g for Gaussian and a for Airy)','PSF lateral e^{-2} radius (\mum) a.k.a. \omega_{0}','PSF axial e^{-2} radus (\mum) a.k.a. \omega_{z}','Images bit depth (8, 12 or 16)','Detector counting Noise (1 to 20)','Gaussian background Noise (0 to 1)','Bleaching (none,mono or qd)','FCS (y or n)','mask size (0 to 1)'};
dlg_title = 'Enter Simulation Parameters';
defaultans = {num2str(1),num2str(256),num2str(256),num2str(100),num2str(0.1),num2str(1),'g',num2str(0.4),num2str(0),num2str(12),num2str(0),num2str(0),'none','n',num2str(0)};
answer = inputdlg(prompt,dlg_title,[1 70],defaultans,options);
numPops=str2double(answer{1});
sizeXdesired=str2double(answer{2}); 
sizeYdesired=str2double(answer{3}); 
sizeT=str2double(answer{4});
pixelsize=str2double(answer{5});
timesize=str2double(answer{6});
PSFType=answer{7};
PSFSize=str2double(answer{8});
PSFZ=str2double(answer{9});
noBits=str2double(answer{10});
countingNoise=str2double(answer{11});
backgroundNoise=str2double(answer{12});
bleachType=answer{13};
FCS=answer{14};
masksize=str2double(answer{15});
% now for every dynamical population prompt to get density, qYield, etc
 density=[];
 bleachDecay=[];
 qYield=[];
 diffCoeff=[];
 flowX=[];
 flowY=[];
 flowZ=[];
 % here we prompt user to define the parameters specific to each dynamical
 % population, such as density, quantum yield, bleaching decay if any, as
 % well as dynamics (diffusion coefficient or flow speeds).
for i=1:numPops
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
prompt = {'Particle density (per \mum^{2})','Bleaching decay constant','Quantum yield of fluorophore','Diffusion coefficient (\mum^{2}/s)','Flow in x (\mum/s)','Flow in y (\mum/s)','Flow in z (um/s)'};
dlg_title = ['For particle population ' num2str(i) ' enter:'];
defaultans = {num2str(3),num2str(0),num2str(1),num2str(0),num2str(0),num2str(0),num2str(0)};
answer = inputdlg(prompt,dlg_title,[1 100],defaultans,options);
 density=[density str2double(answer{1})];
 bleachDecay=[bleachDecay str2double(answer{2})];
 qYield=[qYield str2double(answer{3})];
 diffCoeff=[diffCoeff str2double(answer{4})];
 flowX=[flowX str2double(answer{5})];
 flowY=[flowY str2double(answer{6})];
 flowZ=[flowZ str2double(answer{7})];
end
% simulator proceeds here!
[image_data] = simul8tr2(sizeXdesired,sizeYdesired,sizeT,density,bleachType,bleachDecay,qYield,pixelsize,timesize,PSFType,PSFSize,PSFZ,noBits,diffCoeff,flowX,flowY,flowZ,countingNoise,backgroundNoise,FCS,masksize);
% displays time trace if FCS data or opens stack viewer to display time
% series if image time series is simulated.
if strcmp(FCS,'n')
sv(image_data,'c',5)
elseif strcmp(FCS,'y')
plot((1:length(image_data))*timesize,image_data)
xlabel('time (s)','FontSize',16)
ylabel('Intensity (A.U.)','FontSize',16)
title('Simulated FCS experiment','FontSize',20)
set(gcf,'Color',[1 1 1])
set(gca,'FontSize',20)
end
