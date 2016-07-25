function plotTTnorm(ta, a, tb, b, ts0, ts1)

plot(ta - ts0, a/(mean(a)), '.', 'MarkerSize', 12);
plot(tb - ts0 + ts1, b/(mean(a)), '.', 'MarkerSize', 12);