function [a residual] = halftimefit(time,avint,weights);
    
% 'a' contains the coefficients from the eqn, in the following order:
% f(t)=a1+a2(1-exp(-a3*t))

% If weights isn't given as an input, then all pnts are weighted equally
if nargin == 2
    weights = ones(size(avint));
end

    

a0 = zeros(1,2);

    a0(1) = avint(1,1);
    %a0(2) = avint(1,size(avint,2))-avint(1,1);
    a0(2)= 10+((find(avint==avint(1,size(avint,2)))-find(avint==avint(1,1)))/2)*2;

% Sets curve fit options, and sets lower bounds for amplitude and beam
% radius to zero
lb = [];
ub = [];

curvefitoptions = optimset('Display','final','MaxFunEvals',10000,'MaxIter',5000);

[a,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@halftime,a0,time,avint.*weights,lb,ub,curvefitoptions,weights);


