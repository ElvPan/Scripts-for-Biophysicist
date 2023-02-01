function [GtAvg,RawGt,corrpixel] = ticsGUI(ax,imgser,timesize);


       RawGt = zeros(mean(1:size(imgser,3))*(size(imgser,3)),2) - 1;
       GtAvg = zeros(size(imgser,3),2);
     
       cla(ax)
       ylim(ax,[0,1])
       xlim(ax,[0,1])
       ph = patch(ax,[0 0 0 0],[0 0 1 1],[0.67578 1 0.18359]); %greenyellow
       th = text(ax,1,1,'Calculating TICS ACF...0%','VerticalAlignment','bottom','HorizontalAlignment','right');
       %imgser = double(imgser);
       index = 1;
       %Calculates mean of each image before to save time in calculation
       imgSerMean = squeeze(mean(mean(imgser,2)));
       corrpixel=zeros(size(imgser,1),size(imgser,2),size(imgser,3));
       for tau = 0:(size(imgser,3)-1)

           lagcorr = zeros(1,1,(size(imgser,3)-tau)); % preallocation
           lagcorrStd = zeros(1,1,(size(imgser,3)-tau)); % preallocation
           corrpix=zeros(size(imgser,1),size(imgser,2),(size(imgser,3)-tau));
           for pair=1:(size(imgser,3)-tau)
               corrNonAvgNonNorm = (double(imgser(:,:,pair)).*double(imgser(:,:,pair+tau)));
               corrNonAvg = corrNonAvgNonNorm/(imgSerMean(pair)*imgSerMean(pair+tau));
               corrpix(:,:,pair)=corrNonAvg;
               lagcorr(1,1,pair) = mean2(corrNonAvg) - 1;
               %lagcorrStd(1,1,pair) = std2(corrNonAvg);
               clear corrNonAvg;
           end
           corrpixel(:,:,tau+1)=mean(corrpix,3)-1;
           clear corrpix;
           RawGt(index : (size(imgser,3)-tau+index-1),1) = timesize * tau * ones(size(imgser,3)-tau,1);
           RawGt(index : (size(imgser,3)-tau+index-1),2) = squeeze(lagcorr(1,1,:));
           %RawGt(index : (size(imgser,3)-tau+index-1),3) = squeeze(lagcorrStd(1,1,:));
           GtAvg(tau+1,1) = tau * timesize;
           GtAvg(tau+1,2) = squeeze(mean(mean(lagcorr)));
           GtAvg(tau+1,3) = squeeze(std2(lagcorr));
           index = min(find(RawGt(:,1) == -1));
           ph.XData = [0 tau/(size(imgser,3)-1) tau/(size(imgser,3)-1) 0];
           th.String = sprintf('%Calculating TICS ACF....0f%%',round(tau/(size(imgser,3)-1)*100));
           drawnow %update graphics
       end

