title('03050309 ISIH');
title('03050310 ISIH');
V = open5min('03050315.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
H(find(H<-1000))=0;
[S, vo] = spikehist(H);
bar(vo, S)
bar(vo, S)
xlabel('microvolts');
ylabel('cts/bin');
title('03050315 Spike histogram');
D = discriminate(H, -325, -1);
i = find(D~=0);
D(i) = -325;
plot(F)
title('03050315 filtered trace; threshold = -325uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03050315 waveform mean +/- std');
bar(vo, S)
xlabel('microvolts');
ylabel('cts/bin');
title('03050315 Spike histogram');
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03050315 ISIH');
V = open5min('03050316.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
xlabel('microvolts');
ylabel('cts/bin');
title('03050316 Spike histogram');
V = open5min('03050317.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
xlabel('microvolts');
ylabel('cts/bin');
title('03050317 Spike histogram');
D = discriminate(H, -350, -1);
i = find(D~=0);
D(i) = -350;
plot(F)
title('03050317 filtered trace; threshold = -350uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03050317 waveform mean +/- std');
I = isi(D);
[ISIH, t] = hist(I, 200);
[ISIH, t] = hist(I, 200);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03050317 ISIH');
[ISIH, t] = hist(I, 2400);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03050317 ISIH (1-500ms)');
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03050317 ISIH (1-500ms)');
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03050317 ISIH (1-500ms)');
bar(vo, S)
bar(vo, S)
xlabel('microvolts');
ylabel('cts/bin');
title('03050316 Spike histogram');
%--  9:56 AM 5/07/03 --%
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
nds2bin('.');
dir
dir *.nds
V = open5min('03170306.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
xlabel('microvolts');
ylabel('cts/bin');
title('03170306 Spike histogram');
D = discriminate(H, -350, -1);
i = find(D~=0);
D(i) = -350;
plot(F)
title('03050317 filtered trace; threshold = -350uV');
plot(F)
title('03050317 filtered trace; threshold = -350uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
plot(F)
title('03050317 filtered trace; threshold = -350uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03170306 waveform mean +/- std');
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03170306 ISIH');
V = open5min('03170307.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
xlabel('microvolts');
ylabel('cts/bin');
title('03170307 Spike histogram');
D = discriminate(H, -400, -1);
i = find(D~=0);
D(i) = -400;
plot(F)
title('03170307 filtered trace; threshold = -350uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03170307 waveform mean +/- std');
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03170307 ISIH');
V = open5min('03170308.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
xlabel('microvolts');
ylabel('cts/bin');
title('03170308 Spike histogram');
D = discriminate(H, -400, -1);
i = find(D~=0);
D(i) = -400;
plot(F)
title('03170308 filtered trace; threshold = -400uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
plot(Wavg-Wstd, '--')
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03170308 waveform mean +/- std');
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03170308 ISIH');
V = open5min('03170309.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
xlabel('microvolts');
ylabel('cts/bin');
title('03170309 Spike histogram');
D = discriminate(H, -400, -1);
i = find(D~=0);
D(i) = -400;
plot(F)
plot(F)
title('03170309 filtered trace; threshold = -400uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
plot(Wavg-Wstd, '--')
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03170309 waveform mean +/- std');
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03170309 ISIH');
bar(vo, S)
xlabel('microvolts');
ylabel('cts/bin');
title('03170309 Spike histogram');
V = open5min('03170310.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
V = V(1:3000000/5);
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
xlabel('microvolts');
ylabel('cts/bin');
title('03170310 (1.0 min) Spike histogram');
V = open5min('03170311.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
xlabel('microvolts');
ylabel('cts/bin');
title('03170311 Spike histogram');
D = discriminate(H, -550, -1);
i = find(D~=0);
D(i) = -550;
plot(F)
title('03170311 filtered trace; threshold = -550uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03170311 waveform mean +/- std');
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03170311 ISIH');
V = open5min('03170312.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
xlabel('microvolts');
ylabel('cts/bin');
title('03170312 Spike histogram');
D = discriminate(H, -800, -1);
i = find(D~=0);
D(i) = -800;
plot(F)
title('03170312 filtered trace; threshold = -800uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03170312 waveform mean +/- std');
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03170312 ISIH');
V = open5min('03170316.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
ylabel('cts/bin');
xlabel('microvolts');
title('03170316 Spike histogram');
D = discriminate(H, -425, -1);
i = find(D~=0);
D(i) = -425;
plot(F)
title('03170316 filtered trace; threshold = -425uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03170316 waveform mean +/- std');
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03170316 ISIH');
[ISIH, t] = hist(I, 1400);
bar(t, ISIH);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03170316 ISIH (0-500ms)');
%-- 11:42 AM 5/08/03 --%
dir
dir *.dir
dir *.nds
V = open5min('03170318.nds');
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
V = open5min('03170318.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
ylabel('cts/bin');
xlabel('microvolts');
title('03170318 Spike histogram');
D = discriminate(H, -700, -1);
i = find(D~=0);
D(i) = -700;
plot(F)
title('03170317 filtered trace; threshold = -700uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
Wavg = mean(W, 2);
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03170317 waveform mean +/- std');
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03170318 ISIH');
[ISIH, t] = hist(I, 1200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03170318 ISIH (0-500ms)');
V = open5min('03170323.nds');
V = V(1:1500000);
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
V = open5min('03170318.nds');
V = open5min('03170323.nds');
V = V(1500000:3000000);
F = highpass(V);
H = find_min(F);
figure
[S, vo] = spikehist(H);
bar(vo, S)
bar(vo, S)
ylabel('cts/bin');
xlabel('microvolts');
title('03170323 Spike histogram');
D = discriminate(H, -300, -1);
i = find(D~=0);
D(i) = -300;
plot(F)
title('03170323 filtered trace; threshold = -300uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
Wavg = mean(W, 2);
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03170317 waveform mean +/- std');
title('03170323 waveform mean +/- std');
figure
hold on
for j=1:6736 plot(W(:,j)); end
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03170323 ISIH');
plot(F)
title('03170323 filtered trace; threshold = -300uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
figure
bar(vo, S)
ylabel('cts/bin');
xlabel('microvolts');
title('03170323 Spike histogram');
%--  3:30 PM 5/08/03 --%
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
nds2bin('.');
V = open5min('03180302.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
ylabel('cts/bin');
xlabel('microvolts');
title('03180302 Spike histogram');
D = discriminate(H, -500, -1);
i = find(D~=0);
D(i) = -500;
plot(F)
title('03180302 filtered trace; threshold = -500uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03170317 waveform mean +/- std');
title('03180302 waveform mean +/- std');
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03180302 ISIH');
[ISIH, t] = hist(I, 1000);
bar(t, ISIH);
[ISIH, t] = hist(I, 2000);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03180302 ISIH (0-200ms)');
V = open5min('03180309.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
ylabel('cts/bin');
xlabel('microvolts');
title('03180309 Spike histogram');
V = open5min('03180310.nds');
F = highpass(V);
H = find_max(F);
[S, vo] = spikehist(H);
bar(vo, S)
bar(vo, S)
burst(V);
burst(V);
burst(V(1:100000));
guide
burst(V(1:100000));
bar(vo, S)
Hneg = find_min(F);
Hpos = H
[vpos, vneg] = spikehist(Hneg, Hpos, 30);
[vpos, vneg] = spikehist2D(Hneg, Hpos, 30);
[vpos, vneg] = spikehist2D(Hneg, Hpos, 30);
[vpos, vneg] = spikehist2D(Hneg, Hpos, 30);
[vpos, vneg] = spikehist2D(Hneg, Hpos, 30);
[vpos, vneg] = spikehist2D(Hneg, Hpos, 30);
[vpos, vneg] = spikehist2D(Hneg, Hpos, 30);
[vpos, vneg] = spikehist2D(Hneg, Hpos, 30);
vneg(1)
[vpos, vneg] = spikehist2D(Hneg, Hpos, 30);
scatter(vpos, vneg)
%--  2:15 PM 5/09/03 --%
V = open5min('03180310.nds');
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
V = open5min('03180310.nds');
F = highpass(V);
Hpos = find_max(F);
Hneg = find_min(F);
[vpos, vneg] = spikehist2D(Hneg, Hpos, 30);
max(vpos)
[vpos, vneg] = spikehist2D(Hneg, Hpos, 30);
[vpos, vneg, S] = spikehist2D(Hneg, Hpos, 30);
surf(vpos,vneg,S);
S
[vpos, vneg, S] = spikehist2D(Hneg, Hpos, 30);
[negspike, vpos, vneg, S] = spikehist2D(Hneg, Hpos, 30);
[negspike, vpos, vneg, S] = spikehist2D(Hneg, Hpos, 30);
max(negspike)
min(negspike)
max(negspike)-min(negspike)/nbins
max(negspike)-min(negspike)/100
[negspike, vpos, vneg, S] = spikehist2D(Hneg, Hpos, 30);
surf(vpos,vneg,S);
surf(vneg,vpos,S);
image(S)
image(vneg,vpos,S)
[negspike, vpos, vneg, S] = spikehist2D(Hneg, Hpos, 30);
[vpos, vneg, S] = spikehist2D(Hneg, Hpos, 30);
image(vneg,vpos,S)
image(vpos, vneg, S)
[vpos, vneg, S] = spikehist2D(Hneg, Hpos, 30);
image(vneg,vpos,S)
surf(vpos,vneg,S);
image(vpos, vneg, S)
image(vneg,vpos,S)
image(vpos, vneg, S)
V = open5min('03180302.nds');
V = V(1:500000);
F = highpass(V);
Hpos = find_max(F);
Hneg = find_min(F);
[vpos, vneg, S] = spikehist2D(Hneg, Hpos, 30);
image(vpos, vneg, S)
%--  8:48 PM 5/11/03 --%
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
nds2bin('.');
dir
%--  5:24 PM 5/12/03 --%
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
nds2bin('.');
%-- 10:09 AM 5/13/03 --%
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
fid = fopen('05120301.nds');
M = fread(fid, 'int32');
V = 0.2*M(260:3000259)/4.3150e+006;
fclose(fid);
fid = fopen('05120301.bin', 'w');
fwrite(fid, V, 'float32');
fclose(fid);
Vstable = V(2000000:3000000);
[Vhist, vo] = hist(V, 200);
bar(vo, Vhist);
[Vhist, vo] = hist(Vstable, 200);
bar(vo, Vhist);
Vstable = V(2500000:3000000);
[Vhist, vo] = hist(Vstable, 200);
bar(vo, Vhist);
nds2bin('.');
%--  6:18 PM 5/20/03 --%
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
nds2bin('.');
%--  4:49 PM 5/28/03 --%
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
dir
fid = fopen('11130201.nds');
M = fread(fid, 'int32');
fclose(fid);
length(M)
fid = fopen('11130202.nds');
M = fread(fid, 'int32');
fclose(fid);
length(M)
plot(M)
nds2bin_2('.');
cd abf
dir
dir -l
%--  1:44 PM 5/29/03 --%
fid = fopen('10150209.nds');
fclose(fid);
V = open5min('10150209.nds');
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
V = open5min('10150209.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
D = discriminate(H, -550, -1);
i = find(D~=0);
D(i) = -550;
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('10150209 waveform mean +/- std');
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
dlmwrite([name, '_ISI.txt'], I, '\t');
dlmwrite('01100311_ISI.txt', I, '\t');
I = isi(D);
dlmwrite('01140308_ISI.txt', I, '\t');
I = isi(D);
dlmwrite('01140309_ISI.txt', I, '\t');
I = isi(D);
dlmwrite('01140310_ISI.txt', I, '\t');
I = isi(D);
dlmwrite('01140310_ISI.txt', I, '\t');
I = isi(D);
dlmwrite('01140310_ISI.txt', I, '\t');
I = isi(D);
dlmwrite('01140313_ISI.txt', I, '\t');
I = isi(D);
dlmwrite('01140310_ISI.txt', I, '\t');
I = isi(D);
dlmwrite('01150305_ISI.txt', I, '\t');
I = isi(D);
dlmwrite('01150306_ISI.txt', I, '\t');
I = isi(D);
dlmwrite('01150307_ISI.txt', I, '\t');
dlmwrite('01140313_ISI.txt', I, '\t');
I = isi(D);
dlmwrite('01140313_ISI.txt', I, '\t');
I = isi(D);
dlmwrite('01150309_ISI.txt', I, '\t');
%--  2:30 PM 6/02/03 --%
%--  5:12 PM 6/03/03 --%
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
nds2bin('.');
nds2bin('.');
nds2bin('.');
V = open5min('03280307.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
ylabel('cts/bin');
xlabel('microvolts');
title('03280307 Spike histogram');
D = discriminate(H, -600, -1);
i = find(D~=0);
D(i) = -600;
plot(F)
title('03280307 filtered trace; threshold = -600uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03280307 waveform mean +/- std');
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03280307 ISIH');
[ISIH, t] = hist(I, 1200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03280307 ISIH (0-500ms)');
%--  2:57 PM 6/05/03 --%
%--  9:48 PM 6/18/03 --%
I = isi(D);
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
I = isi(D);
dlmwrite('01140311_ISI.txt', I, '\t');
bar(t, ISIH);
%-- 10:17 PM 6/18/03 --%
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
dlmwrite('03140310_ISI.txt', I, '\t');
dlmwrite('03170323_ISI.txt', I, '\t');
dlmwrite('03280316_ISI.txt', I, '\t');
%--  2:00 PM 6/20/03 --%
addpath('C:\Documents and Settings\Patricio O''Donnell\My Documents\witek matlab');
dir
V = open5min('03210314.nds');
F = highpass(V);
H = find_min(F);
[S, vo] = spikehist(H);
bar(vo, S)
ylabel('cts/bin');
xlabel('microvolts');
title('03210314 Spike histogram');
D = discriminate(H, -300, -1);
i = find(D~=0);
D(i) = -300;
plot(F)
title('03210314 filtered trace; threshold = -300uV');
xlim([0 100000]);
xlabel('samples @ 10 kHz');
ylabel('microvolts');
hold on;
plot(D, '*', 'color', 'red');
W = waveform(F, i, 10, 30);
Wavg = mean(W, 2);
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
ylabel('microvolts');
xlabel('samples @ 10 kHz');
title('03210314 waveform mean +/- std');
I = isi(D);
[ISIH, t] = hist(I, 200);
bar(t, ISIH);
xlabel('samples @ 10 kHz');
ylabel('cts/bin');
title('03210314 ISIH');
dlmwrite('03210314_ISI.txt', I, '\t');
%--  4:55 PM 6/23/03 --%
plot(F)
xlim([0 50000]);
plot(F, 'color', 'black')
xlim([0 50000]);
bar(vo, S)
plot(Wavg);
hold on
Wstd = std(W, 0, 2);
plot(Wavg-Wstd, '--')
plot(Wavg+Wstd, '--')
bar(vo, S)
%--  3:21 PM 6/26/03 --%