function TestIntersect( W )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here


h = plot(W); hold on;
P1 = ginput(1);
plot(P1(1), P1(2), '.', 'MarkerSize', 6, 'Color', 'r');
P2 = ginput(1);
plot(P2(1), P2(2), '.', 'MarkerSize', 6, 'Color', 'r');
plot([P1(1) P2(1)], [P1(2) P2(2)], 'Color', 'r');

if(P1(1)>P2(1))
   temp=P1;
   P1=P2;
   P2=temp;
end

intersect=0;
for x=P1(1):P2(1)
    X = floor(x);
    if SegmentIntersect(P1, P2, [X, W(X)], [X+1, W(X+1)])
        intersect = 1;
        break;
    end
end

if intersect
plot(W, 'r')
end

end
