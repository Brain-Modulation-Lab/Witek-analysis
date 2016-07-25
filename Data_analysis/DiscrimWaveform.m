function [ind, D] = DiscrimWaveform( W, ind, D )
%


h = plot(W, 'k'); hold on;
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

n=0;
rejected =[];
for i=1:size(W,2)
    for x=P1(1):P2(1)
        X = floor(x);
        if SegmentIntersect(P1, P2, [X, W(X,i)], [X+1, W(X+1,i)])
            n=n+1;
            rejected(n)=i;
            plot(W(:,i), 'r')
            break;
        end
    end
end

D(ind(rejected)) = 0;
ind(rejected) = [];

end

