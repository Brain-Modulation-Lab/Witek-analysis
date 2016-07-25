
disp('Opening file...');
V = open5min(filename);
disp('done.');
disp('Filtering...');
F = highpass(V);
disp('done.');
if (polarity < 0)
    disp('Finding minima...');
    H = find_min(F);
else
    disp('Finding maxima...');
    H = find_max(F);
end
disp('done.');
disp('Discriminating...');
D = discriminate(H, threshold, polarity);
i = find(D~=0);
D(i) = threshold;
disp('done.');

%create 
plot(F);
title([filename, ' filtered trace; threshold = ', threshold]);
xlim([0 100000]);
xlabel('samples @10kHz');
ylabel('mV @ gain = 10000');
hold on;
plot(D, '*', 'color', 'red');


%I = isi(H);
%[ISIH, t] = hist(I, 200);
%bar(t, ISIH);
%[S, vo] = spikehist(D);

%[S, vo] = spikehist(H);
%bar(vo, S);
