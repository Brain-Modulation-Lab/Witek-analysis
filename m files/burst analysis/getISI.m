function I = getISI(filename, threshold, polarity)

[name, ext] = strtok(filename, '.');

disp(['opening file ', filename,'...']);
V = open5min(filename);
F = highpass(V);
disp('...done. discriminating spikes...');
if polarity < 0
    H = find_min(F);
else
    H = find_max(F);
end
D = discriminate(H, threshold, polarity);

disp('...done. creating ISI file...');
I = isi(D);
dlmwrite([name, '_ISI.txt'], I, '\t');
disp('...done.');