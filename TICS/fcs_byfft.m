function [corr,lags]=fcs_byfft(intser,maxtau);


[corr,lags] = xcorr(intser,'unbiased');

corr = corr(lags>0);
corr=corr/mean(intser(:))^2-1;
lags = lags(lags>0);
corr=corr(1:maxtau);
lags=lags(1:maxtau);

% fftser=fft(intser);
% spectrum=fftser.*conj(fftser);
% corr=