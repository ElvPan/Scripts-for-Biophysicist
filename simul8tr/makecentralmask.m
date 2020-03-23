function [mask]=makecentralmask(imagesize,masksize);
% masksize is a number 0 to 1
mask=zeros(imagesize,imagesize);
mask(round(imagesize/2)-round(imagesize*masksize*0.5):round(imagesize/2)+round(imagesize*masksize*0.5),round(imagesize/2)-round(imagesize*masksize*0.5):round(imagesize/2)+round(imagesize*masksize*0.5))=1;
