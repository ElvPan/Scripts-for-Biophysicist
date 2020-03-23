function [a, res] = gaussfit(corr,type,pixelsize,whitenoise,radius,mode,v,pcftotnorm,runique);

set(gcbf,'pointer','watch');

if (strcmp('2d',type) || strcmp('2dassym',type) || strcmp('time',type) || strcmp('PSFcorrected',type) || strcmp('normcirc',type) || strcmp('two2dassym',type) || strcmp('twosymgauss',type))
[X,Y] = meshgrid(-((size(corr,2)-1)/2)*pixelsize:pixelsize:((size(corr,2)-1)/2)*pixelsize,-((size(corr,1)-1)/2)*pixelsize:pixelsize:(size(corr,1)-1)/2*pixelsize);
grid = [X Y];
elseif strcmp('kics',type)
imageDim1=size(corr,1);
imageDim2=size(corr,2);
maxk = (1/pixelsize)/2*(2*pi);
stepkx = 1/(imageDim2*pixelsize)*(2*pi);
stepky = 1/(imageDim1*pixelsize)*(2*pi);

if ((mod(imageDim2,2)==0)&&(mod(imageDim1,2)==0))
        [X,Y] = meshgrid(-maxk:stepkx:maxk-stepkx,-maxk:stepky:maxk-stepky);
    elseif ((mod(imageDim2,2)==1)&&(mod(imageDim1,2)==1))
        [X,Y] = meshgrid(-stepkx*(imageDim2-1)/2:stepkx:stepkx*(imageDim2-1)/2,-maxk+stepky/2:stepky:maxk-stepky/2);
    elseif mod(imageDim2,2)==1
        [X,Y] = meshgrid(-stepkx*(imageDim2-1)/2:stepkx:stepkx*(imageDim2-1)/2,-maxk:stepky:maxk-stepky);
    else
        [X,Y] = meshgrid(-maxk:stepkx:maxk-stepkx,-maxk+stepky/2:stepky:maxk-stepky/2);
    end
 kSquared = (X.^2 + Y.^2);
 grid=[X Y];
end
 
   
[Y0, X0] = find(ismember(corr,max(max(corr))),size(corr,3));
X0 = mod(X0,size(corr,2));

%EvilX0 and Y0 are where remainder from mod was zero -- these are set to
%the "max" (ie size) of the corr
EvilX0 = find(ismember(X0,0));
X0(EvilX0) = size(corr,2);

    
   % weights = ones(size(corr));
    
    % If there's whitenoise, 2 highest values (NB this might be more than
    % two points!) in corr func are set to zero, and given no weight in the fit
    
% if strcmp(whitenoise,'y')
%     if strcmp('2d',type)
%        for j=1:2
%        i = find(ismember(corr(:,:,:),max(max(corr(:,:,:)))));
%        ZerChan = i;
%        corr(i) = [0];
%        weights(i) = 0;
%        end
%     end
%     if strcmp(type,'time')
%        for j=1:2
%        i = find(ismember(corr(:,:,1),max(max(corr(:,:,1)))));
%        corr(i) = [0];
%        weights(i) = 0;
%        end
%     end    
% end


if nargin < 5
    weights = ones(size(corr));
elseif nargin==5
    if length(radius)==1
    radius2=radius*ones(1,size(corr,3));
    else 
    radius2=radius;
    end
    weights = ones(size(corr));
    for i=1:size(corr,3)
        weights(:,:,i) = circle(size(corr,2),size(corr,1),X0(i), Y0(i),radius2(1,i));
    end
    
else
   if length(radius)==1
    radius2=radius*ones(1,size(corr,3));
    else 
    radius2=radius;
    end
    weights = zeros(size(corr));
    if strcmp(mode,'2peak') %uses vector v=[vx,vy] that tells how fast the peak is moving in simulation
    for i=1:size(corr,3)
        weights1(:,:,i) = circle(size(corr,2),size(corr,1),1+size(corr,1)/2+(v(1,2)/pixelsize)*i, 1+size(corr,1)/2+(v(1,2)/pixelsize)*i,radius2(1,i));
        weights2(:,:,i) = circle(size(corr,2),size(corr,1),1+size(corr,1)/2-(v(1,2)/pixelsize)*i, 1+size(corr,1)/2-(v(1,2)/pixelsize)*i,radius2(1,i));
        weights(:,:,i)=weights1(:,:,i)+weights2(:,:,i);
        X01(i,1)=1+size(corr,1)/2+(v(1,2)/pixelsize)*i;
        Y01(i,1)=1+size(corr,1)/2+(v(1,2)/pixelsize)*i;
        X02(i,1)=1+size(corr,1)/2-(v(1,2)/pixelsize)*i;
        Y02(i,1)=1+size(corr,1)/2-(v(1,2)/pixelsize)*i;
        
    end 
    elseif strcmp(mode,'pos') %uses vector v=[vx,vy] that tells how fast the peak is moving in simulation
    for i=1:size(corr,3)
        weights(:,:,i) = circle(size(corr,2),size(corr,1),size(corr,1)/2+(v(1,2)/pixelsize)*i, size(corr,1)/2+(v(1,2)/pixelsize)*i,radius2(1,i));
        %weights2(:,:,i) = circle(size(corr,2),size(corr,1),-v(1,1)/pixelsize, -v(1,2)/pixelsize,radius2(1,i));
         X0(i,1)=size(corr,1)/2+(v(1,2)/pixelsize)*i;
        Y0(i,1)=size(corr,1)/2+(v(1,2)/pixelsize)*i;
    end
    elseif strcmp(mode,'neg') %uses vector v=[vx,vy] that tells how fast the peak is moving in simulation
    for i=1:size(corr,3)
        weights(:,:,i) = circle(size(corr,2),size(corr,1),size(corr,1)/2-(v(1,2)/pixelsize)*i,size(corr,1)/2-(v(1,2)/pixelsize)*i,radius2(1,i));
        %weights2(:,:,i) = circle(size(corr,2),size(corr,1),-v(1,1)/pixelsize, -v(1,2)/pixelsize,radius2(1,i));
        X0(i,1)=size(corr,1)/2-(v(1,2)/pixelsize)*i;
        Y0(i,1)=size(corr,1)/2-(v(1,2)/pixelsize)*i;
    end
    end    
end


% weights = ones(size(corr));
%mnmnm
y0 =squeeze(min(min(corr)));
g0 =squeeze(max(max(corr)));
wguess = 0.3*ones(size(g0));


% wguess = zeros(size(corr,3),1);
% for i=1:size(corr,3)
% [Wy, Wx] = find(ismember(abs((corr(:,:,i)/g0(i) - exp(-1))),min(min(abs(corr(:,:,i)/g0(i) - exp(-1))))));
% Wx = mod(Wx,size(corr,2));
% wguess(i) = mean(( (Wx - X0(i)).^2  + (Wy - Y0(i)).^2   ).^(1/2))*pixelsize;
% end



% Converts from matrix index to LOCATION in pixelsize units
for i=1:size(corr,3)
  X0(i) = X(1,X0(i)); 
end
for i=1:size(corr,3)
  Y0(i) = Y(Y0(i),1);  
end

   

% Sets curve fit options, and sets lower bounds for amplitude and beam
% radius to zero
lb = [0 0 -1 -size(corr,1)*pixelsize size(corr,1)*pixelsize];
ub = [1 2*size(corr,1)*pixelsize 1 size(corr,1)*pixelsize 2*size(corr,1)*pixelsize];

%mnmnm
    curvefitoptions = optimset('Display','off');
    %h = waitbar(0,'Fitting correlation functions...');
    
    % Fits each corr func separately
    if strcmp('2d',type)
    for i=1:size(corr,3)
        a0 = initguess(i,:);
        a0xy(1:2) = initguess(i,1:2);
        a0xy(3) = a0xy(2);
        a0xy(4:6) = initguess(i,3:5);
        %[xCurrent,Resnorm,FVAL,EXITFLAG,OUTPUT,LAMBDA,JACOB] = lsqnonlin(FUN,xCurrent,LB,UB,options,varargin)
        [a(i,:),res(i),RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = lsqcurvefit(@gauss2dwxy,a0xy,grid,corr(:,:,i).*weights(:,:,i),lb,ub,curvefitoptions,weights(:,:,i));

    end
    end

    if strcmp('2dassym',type)
    for i=1:size(corr,3)
        a0 = initguess(i,:);
        a0xy(1:2) = initguess(i,1:2);
        a0xy(3) = a0xy(2);
        a0xy(4:6) = initguess(i,3:5);
        a0xy(7)=pi/9;
        %[xCurrent,Resnorm,FVAL,EXITFLAG,OUTPUT,LAMBDA,JACOB] = lsqnonlin(FUN,xCurrent,LB,UB,options,varargin)
        [a(i,:),res(i),RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = lsqcurvefit(@gauss2dwxyassymetric,a0xy,grid,corr(:,:,i).*weights(:,:,i),lb,ub,curvefitoptions,weights(:,:,i));

    end
    end
    
    if strcmp('two2dassym',type)
    for i=1:size(corr,3)
        a0 = initguess(i,:);
        a0xy(1:2) = initguess(i,1:2);
        a0xy(3) = a0xy(2);
        a0xy(4:6) = initguess(i,3:5);
        a0xy(7)=pi/9;
        a0xy(8)=initguess(i,1);
        a0xy(9:10)= a0xy(2);
        a0xy(11:12)=initguess(i,4:5);
        %[xCurrent,Resnorm,FVAL,EXITFLAG,OUTPUT,LAMBDA,JACOB] = lsqnonlin(FUN,xCurrent,LB,UB,options,varargin)
        [a(i,:),res(i),RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = lsqcurvefit(@twogauss2dwxyassymetric,a0xy,grid,corr(:,:,i).*weights(:,:,i),lb,ub,curvefitoptions,weights(:,:,i));

    end
    end
%     
    if strcmp('twosymgauss',type)
        initguess=[g0 wguess y0 X01 Y01 X02 Y02];
    for i=1:size(corr,3)
        % initguess = [g0 wguess y0 X0 Y0];
        a0 = initguess(i,:);
        a0xy(1) = initguess(i,1);
        a0xy(2:3) = initguess(i,4:5);
        a0xy(4) = initguess(i,1);
        a0xy(5:6)=initguess(i,6:7);
        a0xy(7)=initguess(i,2);
        a0xy(8)= initguess(i,3);
       
        %[xCurrent,Resnorm,FVAL,EXITFLAG,OUTPUT,LAMBDA,JACOB] = lsqnonlin(FUN,xCurrent,LB,UB,options,varargin)
        [a(i,:),res(i),RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = lsqcurvefit(@twosymmetricgaussians,a0xy,grid,corr(:,:,i).*weights(:,:,i),lb,ub,curvefitoptions,weights(:,:,i));

    end
    end
    
    
    if strcmp('time',type)
        initguess=[g0 wguess y0 X0 Y0];
    for i=1:size(corr,3)
        a0 = initguess(i,:);
        [a(i,:),res(i),RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = lsqcurvefit(@gauss2d,a0,grid,corr(:,:,i).*weights(:,:,i),lb,ub,curvefitoptions,weights(:,:,i));
    end
    end
    
    %if you fit to circularly averaged and normalized correlation function
    %like the one obtained frmo stics->pCF transformation...
   
    if strcmp('normcirc',type)
    for i=1:size(pcftotnorm,2)
        a0=runique(max(find(0.5<pcftotnorm(:,i))));
        [a(i,:),res(i),RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = lsqcurvefit(@gauss1dnorm,a0,runique,pcftotnorm(:,i),lb,ub,curvefitoptions);
    end
    end
    
    %used to fit normalized kics functions
    if strcmp('kics',type)
    for i=1:size(corr,3)
        a0 = initguess(i,:);
        [a(i,:),res(i),RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = lsqcurvefit(@gauss2d,a0,grid,corr(:,:,i).*weights(:,:,i),lb,ub,curvefitoptions,weights(:,:,i));
    end
    end
    
    %%%%used to fit the real space correlation function but with PSF/immobile part
    %%%%removed (divided by) in real space. First code fitsa the zero lag
    %%%%correlation function with centered Gaussian to extract the estimate
    %%%%for the the PSF waist and then uses the corrected function to fit
    %%%%for other temporal lags...
    
    if strcmp('PSFcorrected',type)
    for i=1:size(corr,3)
        a0xy(1) = initguess(i,1); %amplitude
        a0xy(2) = initguess(i,2)^2; %omega square
        a0xy(3) = initguess(1,2)^2; %PSF square
        a0xy(4) = 1-a0xy(1) ; %offset
        [a(i,:),res(i),RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = lsqcurvefit(@gauss2dPSFremoved,a0xy,grid,corr(:,:,i).*weights(:,:,i),lb,ub,curvefitoptions,weights(:,:,i));
    end
    end

set(gcbf,'pointer','arrow');