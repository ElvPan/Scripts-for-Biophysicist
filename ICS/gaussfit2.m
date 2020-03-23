function [a, res] = gaussfit2(pcftotnorm,runique);

set(gcbf,'pointer','watch');
weights = ones(size(pcftotnorm));
grid=runique;
    curvefitoptions = optimset('Display','off');
    % Sets curve fit options, and sets lower bounds for amplitude and beam
    % radius to zero
    lb = [0 0 -1 min(min(grid)) min(min(grid))];
    ub = [];
    
    %if you fit to circularly averaged and normalized correlation function
    %like the one obtained frmo stics->pCF transformation...
   
    
    for i=1:size(pcftotnorm,2)
        a0=runique(max(find(0.5<pcftotnorm(:,i))));
        [a(i,:),res(i),RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = lsqcurvefit(@gauss1dnorm,a0,grid,pcftotnorm(:,i).*weights(:,i),lb,ub,curvefitoptions,weights(:,i));
    end
   
    

set(gcbf,'pointer','arrow');