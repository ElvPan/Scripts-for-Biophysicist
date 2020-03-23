function [a] = diffflowfit(time,corr,PSFSize,weights);
    
% 'a' contains the coefficients from the diffusion flow eqn, in the following order:
% f=g0d*(1+x/td)^-1+g0f*exp(-(v*x/w)^2) + c

% If weights isn't given as an input, then all pnts are weighted equally
if nargin == 3
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
% 
    

        subplot(3,1,[1 2])
        plot(timeAvg,ypred,'-r')
        hold on
    plot(timeAvg,corrAvg,'.')
    xlabel('\tau (s)','FontSize',10)
    set(gca,'XScale','log');
    ylabel('r_1_1 (0,0,\tau)','FontSize',10)
    title('Sum of Diffusing and Flowing Species Fit','FontSize',10)
    axis tight
    xlim=get(gca,'XLim');
    ylim=get(gca,'YLim');
    text(0.2*xlim(2),0.4*ylim(2),['\tau_{D} =' num2str((a(2))) ' s'],'Color', [1 0 0])
    text(0.2*xlim(2),0.5*ylim(2),['\tau_{f} =' num2str((a(4))) ' s'],'Color', [1 0 0])
    text(0.2*xlim(2),0.6*ylim(2),['|v| =' num2str((PSFSize)/(a(4))) ' \mum s^{-1}'],'Color', [1 0 0])
    text(0.2*xlim(2),0.7*ylim(2),['D =' num2str((PSFSize^2)/(4*a(2))) ' \mum^{2} s^{-1}'],'Color', [1 0 0])
%     text(0.2*xlim(2),0.8*ylim(2),['<N_{D}> =' num2str(1/(a(1)*pi*(PSFSize^2))) ' particles \mum^{-2}'],'Color', [1 0 0])
%     text(0.2*xlim(2),0.9*ylim(2),['<N_{f}> =' num2str(1/(a(3)*pi*(PSFSize^2))) ' particles \mum^{-2}'],'Color', [1 0 0])
    text(0.2*xlim(2),0.8*ylim(2),['<N_{D}>/<N_{f}> =' num2str(a(1)/a(3))],'Color', [1 0 0])
    
    subplot(3,1,[3])
    hold on
plot(timeAvg,0,'-k')
plot(timeAvg,corrAvg-ypred,'-r')
axis tight
ylabel('Residuals','FontSize',12)
set(gca,'XScale','log');
xlabel('\tau (s)','FontSize',10)