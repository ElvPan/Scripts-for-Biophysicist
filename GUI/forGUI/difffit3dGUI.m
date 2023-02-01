function [a] = difffit3dGUI(ax,ax2,time,corr,PSFSize,PSFZ,weights);
    
% 'a' contains the coefficients from the diffusion eqn, in the following order:
% f=y0+(g0*tau)/(tau+x)

% If weights isn't given as an input, then all pnts are weighted equally
if nargin == 6
    weights = ones(size(corr));
end

    corrAvg = corr;
    timeAvg = time;

a0 = zeros(1,3);

    a0(1) = (max(corrAvg) - min(corrAvg));
    a0(2) = timeAvg(find(ismember(abs((max(corrAvg) - min(corrAvg))/2 - corrAvg),min(min(abs((max(corrAvg) - min(corrAvg))/2 - corrAvg)))),1,'first'));
    a0(3) = max([min(corrAvg) 0]);

% Sets curve fit options, and sets lower bounds for amplitude and beam
% radius to zero
lb = [];
ub = [];

curvefitoptions = optimset('Display','off','MaxFunEvals',10000,'MaxIter',5000);

[a,resnorm,residual] = lsqcurvefit(@diffusion3d,a0,time,corr.*weights,lb,ub,curvefitoptions,PSFSize,PSFZ,weights);
    ypred = diffusion3d(a,timeAvg,PSFSize,PSFZ,ones(size(timeAvg)));
  hold(ax,'on')
    semilogx(ax,timeAvg,ypred,'-r')
    semilogx(ax,timeAvg,corrAvg,'.')
    xlabel(ax,'\tau (s)','FontSize',20)
    %set(ax,'XScale','log');
    ylabel(ax,'r_{11} (0,0,\tau)','FontSize',20)
    title(ax,'Single Component 3D Diffusion Fit','FontSize',20)
    %set(ax,'tight')
    xlim=get(ax,'XLim');
    ylim=get(ax,'YLim');
    text(ax,0.1*xlim(2),0.6*ylim(2),['D =' num2str((PSFSize^2)/(4*a(2))) ' \mum^{2} s^{-1}'],'Color', [1 0 0],'FontSize',20)
    text(ax,0.1*xlim(2),0.8*ylim(2),['<N> =' num2str(1/(a(1)*(pi^1.5)*(PSFZ*PSFSize^2))) ' particles \mum^{-2}'],'Color', [1 0 0],'FontSize',20)
    semilogx(ax2,timeAvg,0,'-k')
    semilogx(ax2,timeAvg,corrAvg-ypred,'-r')
    %axis tight
    ylabel(ax2,'Residuals','FontSize',15)
   % set(ax2,'XScale','log');
    xlabel(ax2,'\tau (s)','FontSize',20)

