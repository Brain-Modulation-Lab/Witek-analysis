function plotLTPnorm(base, test, start, color)

hold on;
span = min(test(start).area)-mean(base.area);
for(k=start:length(test))
    plot((10*(1:length(test(k).area))- 5 + (hms2sec(test(k).tstart) - hms2sec(test(start).tstart)))/60, (test(k).area-mean(base.area))/span, '.', 'color', color);
end