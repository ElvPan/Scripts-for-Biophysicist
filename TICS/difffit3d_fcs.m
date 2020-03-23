function [a] = difffit3d_fcs(time,corr,PSFSize,PSFZ,weights);
    
% 'a' contains the coefficients from the diffusion eqn, in the following order:
% f=y0+(g0*tau)/(tau+x)

% If weights isn't given as an input, then all pnts are weighted equally
if nargin == 4
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


    hold on
        subplot(3,1,[1 2])
         hold on
    ypred = diffusion3d(a,timeAvg,PSFSize,PSFZ,ones(size(timeAvg)));

    plot(timeAvg,ypred,'-r')
    plot(timeAvg,corrAvg,'.')

        subplot(3,1,[1 2])
    xlabel('\tau (s)','FontSize',10)
    set(gca,'XScale','log');
    ylabel('r_1_1 (0,0,\tau)','FontSize',10)
    title('Single Component 3D Diffusion Fit','FontSize',10)
    axis tight
    xlim=get(gca,'XLim');
    ylim=get(gca,'YLim');
    text(0.1*xlim(2),0.6*ylim(2),['D =' num2str((PSFSize^2)/(4*a(2))) ' \mum^{2} s^{-1}'],'Color', [1 0 0])
    text(0.1*xlim(2),0.8*ylim(2),['<N> =' num2str(1/(a(1)*(pi^1.5)*(PSFZ*PSFSize^2))) ' particles \mum^{-2}'],'Color', [1 0 0])
    
    subplot(3,1,[3])
    hold on
plot(timeAvg,0,'-k')
plot(timeAvg,corrAvg-ypred,'-r')
axis tight
ylabel('Residuals','FontSize',12)
set(gca,'XScale','log');
xlabel('\tau (s)','FontSize',10)
set(gcf,'Color',[1 1 1])
