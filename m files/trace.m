function trace(V, sf, filename)

figure;
plot((1:length(V))/sf, V);
xlabel('seconds');
ylabel('mV');
title(filename);