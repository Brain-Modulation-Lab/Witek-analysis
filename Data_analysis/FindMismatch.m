function [ match, mismatch ] = FindMismatch( long, short, minlat, maxlat )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

mismatch = [];

for i=1:length(long)
    if isempty(intersect(find(short < long(i) + minlat), find(short >= long(i) - maxlat)))
        mismatch(end+1)=i;
    end
end

match = setdiff(1:length(long), mismatch);
end

