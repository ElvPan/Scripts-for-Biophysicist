function F = halftime(a,data,weights);

% Used by the curve fitter to calculate values for the diffusion equation

    %F = (a(1)+a(2).*(1-exp(-a(3)*abs(data)))).*weights;  
F = (a(1)+(1-exp(-a(2)*abs(data)))).*weights;  