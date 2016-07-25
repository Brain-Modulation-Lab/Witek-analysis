function plotstimwindows(W)

dim = size(W);

for i=1:dim(1)
    plot(W(i,:));
    hold on;
end

hold off;