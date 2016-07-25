function [h, XC, lags, phase, f1] = bandpass_xcorrelogram(X1, X2, start, finish, window, band, fs, params)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

X1 = X1(round(start*fs):round(finish*fs));
X2 = X2(round(start*fs):round(finish*fs));

if ~isempty(band(1))
    X1 = highpassfilter(X1, fs, band(1));
    X2 = highpassfilter(X2, fs, band(1));
end

if ~isempty(band(2))
    X1 = lowpassfilter(X1,fs,band(2));
    X2 = lowpassfilter(X2,fs,band(2));
end

[h, XC, lags, phase, f1] = xcorrelogram(X1, X2, window, fs, params);
end

