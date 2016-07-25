function [f, n] = matchsng(Vt, V)

Vtlen = length(Vt);
f = zeros(1000,1);
n = zeros(1000,1);

for i = 1:1000
    f(i) = mean(V(i:i+Vtlen-1)./Vt);
    n(i) = std(V(i:i+Vtlen-1)./Vt);
    %disp('*');
end