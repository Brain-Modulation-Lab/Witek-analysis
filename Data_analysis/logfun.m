function [ y ] = logfun( x )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

y=0;
if x > 0
    y = log(x);
elseif x < 0
    y = -log(-x);
end

end

