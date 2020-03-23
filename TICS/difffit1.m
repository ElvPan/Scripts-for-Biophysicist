function [a] = difffit1(time,corr,PSFSize,weights);
    
% 'a' contains the coefficients from the diffusion eqn, in the following order:
% f=y0+(g0*tau)/(tau+x)

% If weights isn't given as an input, then all pnts are weighted equally
if nargin == 3
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

curvefitoptions = optimset('Display','final','MaxFunEvals',10000,'MaxIter',5000);

[a,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@diffusionfn,a0,time,corr.*weights,lb,ub,curvefitoptions,weights);

figure

   
    ypred = diffusionfn(a,timeAvg,ones(size(timeAvg)));

    plot(timeAvg,ypred,'-r','LineWidth',2)
    hold on
    plot(timeAvg,corrAvg,'.','MarkerSize',20)

    xlabel('\tau (s)','FontSize',20)
    set(gca,'XScale','log');
    ylabel('r_1_1 (0,0,\tau)','FontSize',20)
    %title('Single Component Diffusion Fit','FontSize',20)
    axis tight
    xlim=get(gca,'XLim');
    ylim=get(gca,'YLim');
    text(0.15*xlim(2),0.9*ylim(2),['D =' num2str(round((PSFSize^2)/(4*a(2)),2,'significant')) ' \mum^{2} s^{-1}'],'Color', [0 0 1],'FontSize',20)
    text(0.15*xlim(2),0.8*ylim(2),['<N> =' num2str(round(1/(a(1)*pi*(PSFSize^2)),2,'significant')) ' particles \mum^{-2}'],'Color', [0 0 1],'FontSize',20)
    set(gca,'FontSize',20)
set(gcf,'Color',[1 1 1])
