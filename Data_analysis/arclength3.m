function L = arclength3( curve )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
L=0;
for t=1:size(curve,1)-1
    L = L + sqrt((curve(t+1,1)-curve(t,1))^2 + ...
        (curve(t+1,2)-curve(t,2))^2 + ...
        (curve(t+1,3)-curve(t,3))^2);
end
end

