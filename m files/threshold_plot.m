function threshold_plot(F, D, sf, threshold, filename)

figure;
plot((1:length(F))/sf, F)
title([filename, ' threshold = ', num2str(threshold), ' uV']);
xlabel('seconds');
ylabel('uV');
hold on;
plot(find(D~=0)/sf, nonzeros(D), '+', 'color', 'red');