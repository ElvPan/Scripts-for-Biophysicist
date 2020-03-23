function F = diffusionflow3D(a,data,PSFSize,PSFZ,weights);

% f=g0d*(1+x/td)^-1+g0f*exp(-(v*x/w)^2) + c
% Used by the curve fitter to calculate values for the diffusion flow equation

    F = (( a(1) ./ ((1 + data./a(2) ).* sqrt(1 + (PSFSize/PSFZ)^2 .* data./a(2))))+a(3).*exp(-(data./a(4)).^2) + a(5)).*weights;  
