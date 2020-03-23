function [cropcorr]=cropcentral(data,masksize);
imagesize=size(data,1);
range=round(imagesize/2)-round(imagesize*masksize*0.5):round(imagesize/2)+round(imagesize*masksize*0.5);
n1=1:floor(imagesize/2)-round(imagesize*masksize*0.5)-5;
for i=1:size(data,3)
    
    cropdata=data(range,range,i);
    noisematrix=data(n1,n1,i);
    cropcorr(:,:,i) = cropdata - ceil(mean2(noisematrix));
end