function [h, XC, lags, phase, f1] = xcorrelogram(X1, X2, window, fs, params)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

for lag=1:2*window*fs
    XC(lag) = sum(X1((window*fs):(2*window*fs)).*X2(lag:(window*fs+lag)));
end

lags = (1:length(XC))/fs-window;

[S,f,~]=mtspectrumc(XC,params);
f1 = f(find(S==max(S)));

phase = (find(XC(floor((window-1/(2*f1))*fs+2):floor((window+1/(2*f1))*fs))==max(XC(floor((window-1/(2*f1))*fs+2):floor((window+1/(2*f1))*fs))))-floor(fs/(2*f1)))/fs;

%phase = find(XC==max(XC))/fs - window;

h = figure;
plot(lags,XC); 
hold on; plot([0 0], ylim, ':')
hold on; plot((-1/(2*f1))*[1 1], ylim, ':');
hold on; plot((1/(2*f1))*[1 1], ylim, ':');
hold on; plot(phase*[1 1], ylim, ':', 'Color', 'r');

end

