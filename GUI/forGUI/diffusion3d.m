function F = diffusion3d(a,xdata,PSFSize,PSFZ,weights)

% Used by the curve fitter to calculate values for the 3d diffusion equation

    F = (a(3) + ( a(1) ./ ((1 + xdata./a(2) ).* sqrt(1 + (PSFSize/PSFZ)^2 .* xdata./a(2))))).*weights;  
