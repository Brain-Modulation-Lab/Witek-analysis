
PRE = 200;
OFFSET = 750;
LENGTH = 1000;

figure; hold on;

for j = 1:length(meanLFP)
    plot((1:1050)/10 - 5, meanLFP(j).VV((PRE-49):(PRE+LENGTH)) - OFFSET*(j-1));
    plot([-5 100], -OFFSET*(j-1)*[1 1], ':');
    text(-10, -OFFSET*(j-1), meanLFP(j).label);
    
    plot( meanLFP(j).tmax, -OFFSET*(j-1)+meanLFP(j).max, '*');
    
    plot( meanLFP(j).tmin, -OFFSET*(j-1)+meanLFP(j).min, '*');
    
    current(j) = str2num(meanLFP(j).label);
    
    amplitude(j) = meanLFP(j).min - meanLFP(j).max;
    
    %plot((meanLFP(j).T1 - PRE)*[1 1]/10, -OFFSET*(j-1)*[1 1], 'color', 'red', 'marker', '+');
    %plot((meanLFP(j).T2 - PRE)*[1 1]/10, -OFFSET*(j-1)*[1 1], 'color', 'red', 'marker', '+');
%     text( meanLFP(j).tmin, -OFFSET*(j-1)+meanLFP(j).min/2, num2str(meanLFP(j).min), 'HorizontalAlignment', 'center');
end

xlabel('time (ms)');

xlim([-10 100])
ylim([-OFFSET*(j+1) OFFSET])
set(gca, 'ytick', 2*OFFSET*j);

figure;

plot(current, amplitude, 'o');
xlim([0 1200])
ylabel('N1-P1 amplitude (uV)')
xlabel('current (uA)');