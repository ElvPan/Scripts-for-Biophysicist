function [GtAvg] = fcs(intser,timesize);


%h = waitbar(0,'Calculating time correlation functions...');

% tau is the lag
% pair is the nth pair of a lag time

       GtAvg = zeros(length(intser),2);
     
      
       %Calculates mean of each image before to save time in calculation
       intserMean = squeeze(mean(intser));
      
       for tau = 0:(length(intser)-1)

           lagcorr = zeros(1,(length(intser)-tau)); % preallocation
             for pair=1:(length(intser)-tau)
               corrNonAvg = (double(intser(pair)).*double(intser(pair+tau)));
               lagcorr(1,pair) = mean(corrNonAvg)/(intserMean^2) - 1;
             
               clear corrNonAvg;
           end
           GtAvg(tau+1,1) = tau * timesize;
           GtAvg(tau+1,2) = squeeze(mean(lagcorr));
            %waitbar((tau+1)/(size(intser,3)-1),h)
       end

%close(h)