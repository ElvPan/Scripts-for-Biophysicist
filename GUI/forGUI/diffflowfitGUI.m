function [a] = diffflowfitGUI(ax,ax2,time,corr,PSFSize,weights);
    
% 'a' contains the coefficients from the diffusion flow eqn, in the following order:
% f=g0d*(1+x/td)^-1+g0f*exp(-(v*x/w)^2) + c

% If weights isn't given as an input, then all pnts are weighted equally
if nargin == 5
    weights = ones(size(corr));
end

a0 = zeros(1,5);

    corrAvg = corr;
    timeAvg = time;


    a0(1) = (max(corrAvg) - min(corrAvg))/2;
    a0(2) = timeAvg(find(ismember(abs((max(corrAvg) - min(corrAvg))/2 - corrAvg),min(min(abs((max(corrAvg) - min(corrAvg))/2 - corrAvg)))),1,'first'));;
    a0(3) = (max(corrAvg) - min(corrAvg))/2;
    a0(4) = timeAvg(find(ismember(abs((corrAvg/max(corrAvg) - exp(-1))),min(min(abs(corrAvg/max(corrAvg) - exp(-1))))),1,'first'));
    a0(5) = max([min(corrAvg) 0]);
    
    % Sets curve fit options, and sets lower bounds for amplitude and beam
    % radius to zero
    lb = [];
    ub = [];
    
    curvefitoptions = optimset('Display','final','MaxFunEvals',5000,'MaxIter',5000);

    [a,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@diffusionflow,a0,time,corr.*weights,lb,ub,curvefitoptions,weights);
     ypred = diffusionflow(a,timeAvg,ones(size(timeAvg)));
      hold(ax,'on')
    semilogx(ax,timeAvg,ypred,'-r')
    semilogx(ax,timeAvg,corrAvg,'.')
    xlabel(ax,'\tau (s)','FontSize',20)
    %set(ax,'XScale','log');
    ylabel(ax,'r_{11} (0,0,\tau)','FontSize',20)
    title(ax,'Sum of Diffusing and Flowing Species Fit','FontSize',20)
    %set(ax,'tight')
    xlim=get(ax,'XLim');
    ylim=get(ax,'YLim');
    text(ax,0.1*xlim(2),0.4*ylim(2),['\tau_{D} =' num2str(roundtodecpt((a(2)),2)) ' s'],'Color', [1 0 0],'FontSize',20)
    text(ax,0.1*xlim(2),0.5*ylim(2),['\tau_{f} =' num2str(roundtodecpt((a(4)),2)) ' s'],'Color', [1 0 0],'FontSize',20)
    text(ax,0.1*xlim(2),0.6*ylim(2),['|v| =' num2str(roundtodecpt((PSFSize)/(a(4)),2)) ' \mum s^{-1}'],'Color', [1 0 0],'FontSize',20)
    text(ax,0.1*xlim(2),0.7*ylim(2),['D =' num2str(roundtodecpt((PSFSize^2)/(4*a(2)),2)) ' \mum^{2} s^{-1}'],'Color', [1 0 0],'FontSize',20)
    text(ax,0.1*xlim(2),0.8*ylim(2),['<N_{D}>/<N_{f}> =' num2str(roundtodecpt(a(1)/a(3),2))],'Color', [1 0 0],'FontSize',20)
    semilogx(ax2,timeAvg,0,'-k')
    semilogx(ax2,timeAvg,corrAvg-ypred,'-r')
    %axis tight
    ylabel(ax2,'Residuals','FontSize',15)
   % set(ax2,'XScale','log');
    xlabel(ax2,'\tau (s)','FontSize',20)

