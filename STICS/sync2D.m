%define undersampled sync function for image of sizex sizey...


function [syncmatrix]=sync2D(sizex,sizey,v,pixelsize,timelag,totime);

%define the factors in x and y by which images are undersampled
%M=pixelsize/(v(1,1)*timelag);
%N=pixelsize/(v(1,2)*timelag);
M=1;
N=1;

%M=M^-1;
%N=N^-1;

dx=(pixelsize/(v(1,1)*timelag))^-1;
dy=(pixelsize/(v(1,2)*timelag))^-1;

for k=1:totime
%     x0=((M^-1)*k);
%     y0=((N^-1)*k);
    x0=(k*dx);
    y0=(k*dy);
for i=1:sizex
    for j=1:sizey
syncmatrix(i,j,k)=(sin(pi*(i-x0-ceil(sizex/2)))./(pi*(i-x0 -ceil(sizex/2)))).*(sin(pi*(j-y0-ceil(sizey/2)))./(pi*(j-y0-ceil(sizex/2))));
    end
end
end