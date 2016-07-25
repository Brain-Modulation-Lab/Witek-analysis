function plot_trace(data, sf, pre)

figure;
plot(1000*(1:length(mean(data.VV,2)))/sf - pre, mean(data.VV,2));
xlabel('time (ms)');