function [ pts ] = SubCurve( curve, N )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

L = arclength3(curve);

pts(1,:) = curve(1,:);

t=1;
l=0;
 T(1)=1;
for p=2:N-1
    while l<((p-1)*L/(N-1))
        t=t+1;
        l = arclength3(curve(1:t,:));
    end
     T(p) = t;
    pts(p,:) = curve(t,:);
end

 T(N) = size(curve,1);
pts(N,:) = curve(end,:);


 for t=1:length(T)-1
     fprintf('Segment %d: %4.2f\n', t, arclength3(curve(T(t):T(t+1),:)));
 end
end

