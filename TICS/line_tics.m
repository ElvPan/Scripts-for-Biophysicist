function [Gt,corrpixel] = line_tics(imgser,timesize);

% July 10, 2003
% David Kolin
% Calculates time correlation function given 3D array of image series
% Returns ALL g(0,0) values -- doesn't average them!!!
% Usage: [RawGt,GtAvg] = tics(imgser,timesize);

%h = waitbar(0,'Calculating time correlation functions...');

% tau is the lag
% pair is the nth pair of a lag time

       %timecorr = zeros(size(imgser,1),size(imgser,2),size(imgser,3));  % preallocates lagcorr matrix for storing raw time corr functions    
       %timecorrStdDev = zeros(size(imgser,3)-1,1);
       %%RawGt = zeros(mean(1:size(imgser,3))*(size(imgser,3)),2) - 1;
       Gt = zeros(size(imgser,1),2);
     
       %imgser = double(imgser);
       %%index = 1;
       %Calculates mean of each image before to save time in calculation
       imgSerMean = squeeze(mean(imgser,2));
       corrpixel=zeros(size(imgser,1),size(imgser,2));
       for tau = 0:(size(imgser,1)-1)

           lagcorr = zeros(1,1,(size(imgser,1)-tau)); % preallocation
           lagcorrStd = zeros(1,1,(size(imgser,1)-tau)); % preallocation
           corrpix=zeros((size(imgser,1)-tau),size(imgser,2));
           for pair=1:(size(imgser,1)-tau)
               corrNonAvgNonNorm = (double(imgser(pair,:)).*double(imgser(pair+tau,:)));
               corrNonAvg = corrNonAvgNonNorm/(imgSerMean(pair)*imgSerMean(pair+tau));
               corrpix=corrNonAvg;
               lagcorr(1,1,pair) = mean2(corrNonAvg) - 1;
               %lagcorrStd(1,1,pair) = std2(corrNonAvg);
               clear corrNonAvg;
           end
           corrpixel(tau+1,:)=mean(corrpix,1);
           clear corrpix;
           
           %%RawGt(index : (size(imgser,3)-tau+index-1),1) = timesize * tau * ones(size(imgser,3)-tau,1);
           %%RawGt(index : (size(imgser,3)-tau+index-1),2) = squeeze(lagcorr(1,1,:));
           %RawGt(index : (size(imgser,3)-tau+index-1),3) = squeeze(lagcorrStd(1,1,:));
           Gt(tau+1,1) = tau * timesize;
           Gt(tau+1,2) = squeeze(mean(lagcorr));
           %Gt(tau+1,3) = squeeze(std2(lagcorr));
           %%index = min(find(RawGt(:,1) == -1));
           %waitbar((tau+1)/(size(imgser,3)-1),h)
       end

%close(h)