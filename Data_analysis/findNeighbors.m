function [ aconn ] = findNeighbors( a, Faces )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
aconn = unique([Faces(Faces(:,1)==a,[2 3]); Faces(Faces(:,2)==a,[1 3]); Faces(Faces(:,3)==a,[1 2])]);
end

