function [ D ] = I2D( I )
% convert list of ISIs to a Boolean time-series of spike occurance
%   

D = zeros(sum(I)+1,1);
D(1) = 1;
for i=1:length(I)
    D(1+sum(I(1:i))) = 1;
end

end

