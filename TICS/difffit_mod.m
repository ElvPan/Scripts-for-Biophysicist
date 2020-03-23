function [a residual] = difffit_mod(time,corr,weights);
    
% 'a' contains the coefficients from the diffusion eqn, in the following order:
% f=y0+(g0*tau)/(tau+x)

% If weights isn't given as an input, then all pnts are weighted equally
if nargin == 2
    weights = ones(size(corr));
end

    corrAvg = corr;
    timeAvg = time;

a0 = zeros(1,3);

     a0(1) = (max(corrAvg) - min(corrAvg));
    %a0(1) = (corrAvg(2) - min(corrAvg));
    a0(2) = timeAvg(find(ismember(abs((max(corrAvg) - min(corrAvg))/2 - corrAvg),min(min(abs((max(corrAvg) - min(corrAvg))/2 - corrAvg)))),1,'first'));
    a0(3) = max([min(corrAvg) 0]);

% Sets curve fit options, and sets lower bounds for amplitude and beam
% radius to zero
%lb = [0 0 0];
%ub = [1.5*a0(1) max(time) 1.5*a0(1)];
lb=[];
ub=[];
curvefitoptions = optimset('Display','final','MaxFunEvals',10000,'MaxIter',5000);

[a,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@diffusion2,a0,time,corr.*weights,lb,ub,curvefitoptions,weights);


% lag=a(2);
% D=(0.3)^2/(4*lag);
% 
% scrsz = get(0,'ScreenSize');
% figure('Position',[0 0 scrsz(3) scrsz(4)*0.95]);
% 
% 
%     hold on
%         subplot(3,1,[1 2])
%          hold on
%     ypred = diffusion(a,timeAvg,ones(size(timeAvg)));
% 
%     plot(timeAvg,ypred,'-r')
%     plot(timeAvg,corrAvg,'.')
% 
%         subplot(3,1,[1 2])
%     xlabel('\tau (s)','FontSize',20)
%     set(gca,'XScale','log');
%     ylabel('r_1_1 (0,0,\tau)','FontSize',20)
%     title(['2D Diffusion Fit For Serie' serie ' D = ' num2str(D) '\mu m^{2}/s'],'FontSize',15)
%     axis tight
%     subplot(3,1,[3])
%     hold on
% plot(timeAvg,0,'-k')
% plot(timeAvg,corrAvg-ypred,'-r')
% axis tight
% ylabel('Residuals','FontSize',20)
% set(gca,'XScale','log');
% xlabel('\tau (s)','FontSize',20)
% 
