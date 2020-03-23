function [timecorr] = sticcs(imgser1,imgser2,upperTauLimit);

% July 10, 2003
% David Kolin
% Calculates the full time correlation function given 3D array of image series

set(gcbf,'pointer','watch');

h = waitbar(0,'Calculating time correlation functions...');


% tau is the lag
% pair is the nth pair of a lag time

       timecorr = zeros(size(imgser1,1),size(imgser1,2),upperTauLimit);  % preallocates lagcorr matrix for storing raw time corr functions    
       SeriesMean1 = squeeze(mean(mean(imgser1)));
       SeriesMean2 = squeeze(mean(mean(imgser2)));
       
       for tau = 0:upperTauLimit-1
                  lagcorr = zeros(size(imgser1,1),size(imgser1,2),(size(imgser1,3)-tau));      
           for pair=1:(size(imgser1,3)-tau)
               lagcorr(:,:,pair) = fftshift(real(ifft2(fft2(imgser1(:,:,pair)).*conj(fft2(imgser2(:,:,(pair+tau))))))/(SeriesMean1(pair)*SeriesMean2(pair+tau)));
               %lagcorr(:,:,pair) = fftshift(real(ifft2(fft2(imgser(:,:,pair)).*conj(fft2(imgser(:,:,(pair+tau))))))/(SeriesMean(pair)*SeriesMean(pair+tau)));
           %lagcorr(:,:,pair) = fftshift(real(ifft2(fft2(imgser(:,:,pair)).*conj(fft2(imgser(:,:,(pair+tau)))))));
           end
           timecorr(:,:,(tau+1)) = mean(lagcorr,3);
           if ishandle(h)
               waitbar((tau+1)/(upperTauLimit),h)
           else
               break
           end
       end

if ishandle(h)
close(h)
end
set(gcbf,'pointer','arrow');