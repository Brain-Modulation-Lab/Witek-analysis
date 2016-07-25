function [filt] = lowpassfilter(dat,Fs,Flp,N,type)

% LOWPASSFILTER removes high frequency components from EEG/MEG data
% 
% Use as
%   [filt] = lowpassfilter(dat, Fsample, Flp, N, type)
% where
%   dat        data matrix (Nchans X Ntime)
%   Fsample    sampling frequency in Hz
%   Flp        filter frequency
%   N          optional filter order, default is 6 (but) or 25 (fir)
%   type       optional filter type, can be
%                'but' Butterworth IIR filter (default)
%                'fir' FIR filter using Matlab fir1 function 
%
% See also HIGHPASSFILTER, BANDPASSFILTER

% Copyright (c) 2003, Robert Oostenveld
%
% $Log: lowpassfilter.m,v $
% Revision 1.3  2004/02/11 08:55:13  roberto
% added optional fir1 filter (default still is butterworth), changed
% layout of code for better support of multiple optional arguments,
% extended documentation
%
% Revision 1.2  2003/06/12 08:40:44  roberto
% added variable option to determine filter order
% changed default order from 6 to 4 for notch and bandpass
%
% Revision 1.1  2003/04/04 09:53:37  roberto
% new implementation, using 6th order Butterworth FIR filter
%

% set the default filter order later
if nargin<4
    N = [];
end

% set the default filter type
if nargin<5
  type = 'but';
end

% Nyquist frequency
Fn = Fs/2;

% compute filter coefficients and apply the filter to the data
switch type
  case 'but'
    if isempty(N)
      N = 6;
    end
    [B, A] = butter(N, max(Flp)/Fn);
  case 'fir'
    if isempty(N)
      N = 25;
    end
    [B, A] = fir1(N, max(Flp)/Fn);
end  
filt = filtfilt(B, A, dat')';                  

