%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SPIKEHIST() function
%
%   Construct spike histogram data given a vector of minima or
%   maxima in the signal (see find_min() or find_max() function)
%   Voltage range is binned into 200 bins.
%   To plot the histogram at command line use:
%
%       bar(vo, S);
%_______________________________________________________________
%   Arguments:
%       H = vector of minima or maxima in the signal.
%           (see find_min() or find_max() function)
%_______________________________________________________________
%   Returns:
%       S = vector of count values (y-axis)
%       vo = vector of voltage values (x-axis)
%_______________________________________________________________
%   (c) 2003 Witold J. Lipski.  Please feel free to copy
%   and/or modify this code. Questions/Comments: wjl3@pitt.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [S, vo] = spikehist(H)

spikeindex = find(H~=0);
spikes = H(spikeindex);

[S, vo] = hist(spikes, 200);