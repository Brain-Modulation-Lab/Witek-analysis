function [ x ] = SelectMarker(n)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

OriginalXlim = xlim;

x=zeros(n,1);

for i=1:n
    button=0;
    zoom = 5;
    while button ~= 1   
        [x(i),y,button] = ginput(1);
        if button ~= 1
            xlim([x(i)-zoom, x(i)+zoom]);
            zoom = zoom/2;
        end   
    end
    
    xlim(OriginalXlim);
    hold on; plot(x(i)*[1 1], ylim, 'k')
    
end
    
end

