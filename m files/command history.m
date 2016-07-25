F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
i2 = i;
D2 = D;
for j = 1:length(i)
if min(F((i(j)-20):(i(j)+20)))<-500
disp('deleted.');
i2(j) = 0;
D2(j) = 0;
end
i2(i2==0)=[];
i = i2;
D = D2;
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
i2 = i;
D2 = D;
for j = 1:length(i)
if min(F((i(j)-20):(i(j)+20)))<-500
disp('deleted.');
i2(j) = 0;
D2(j) = 0;
end
i2(i2==0)=[];
i = i2;
D = D2;
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
F = highpassfilter(V, sf, 200);
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 500, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
4/180
H(H>500)=0;
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
length(i)/180
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
peakhist(H, filename);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
peakhist(H, filename);
H = find_max(F);
peakhist(H, filename);
[V, sf, filename]=readns;
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 90, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 120, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 90, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
figure; plot(W)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  waveform correction
i2 = i;
D2 = D;
for j = 1:length(i)
if min(F((i(j)-20):(i(j)+20)))<-500
disp('deleted.');
i2(j) = 0;
D2(j) = 0;
end
i2(i2==0)=[];
i = i2;
D = D2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  waveform correction
i2 = i;
D2 = D;
for j = 1:length(i)
if F(i(j))>0
disp('deleted.');
i2(j) = 0;
D2(j) = 0;
end
i2(i2==0)=[];
i = i2;
D = D2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[D, i, thresh] = threshold(F, H, sf, 90, 1, filename);
%%%%%%%%%%%%%%%%%  waveform correction
i2 = i;
D2 = D;
for j = 1:length(i)
if F(i(j)+3)>0
disp('deleted.');
i2(j) = 0;
D2(j) = 0;
end
i2(i2==0)=[];
i = i2;
D = D2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
peakhist(H, filename);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
peakhist(H, filename);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
%%%%%%%%%%%%%%%%%  waveform correction
i2 = i;
D2 = D;
l=0;
for j = 1:length(i)
if F(i(j)+14)<0
disp('deleted.');
k(l) = i(j); l=l+1;
i2(j) = 0;
D2(j) = 0;
end
i2(i2==0)=[];
i = i2;
D = D2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  waveform correction
i2 = i;
D2 = D;
k=1;
for j = 1:length(i)
if F(i(j)+14)<0
disp('deleted.');
l(k) = i(j); k=k+1;
i2(j) = 0;
D2(j) = 0;
end
i2(i2==0)=[];
i = i2;
D = D2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
figure; plot(W)
figure; plot(F)
hold on; plot(D, '.', 'color', 'red')
hold on; plot(l, ones(1, length(1)), '.', 'color', 'green')
hold on; plot(l, 500*ones(1, length(1)), '.', 'color', 'green')
length(i)/180
length(l)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
F = highpassfilter(V, sf, 200);
peakhist(H, filename);
H = find_max(F);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
peakhist(H, filename);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
peakhist(H, filename);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
peakhist(H, filename);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
peakhist(H, filename);
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
3/180
H(H>300)=0;
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 90, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
39/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
a = 0;
[A, fo] = hist(a, 20);
figure; bar(fo, A)
[A, fo] = hist(a, 50);
figure; bar(fo, A)
a = 0;
[A, fo] = hist(a, 50);
figure; bar(fo, A)
a = 0;
[A, fo] = hist(a, 20);
figure; bar(fo, A)
[A, fo] = hist(a, 50);
figure; bar(fo, A)
a = 0;
A = histc(a, fo);
hold on; bar(fo, A)
a = 0;
A = histc(a, fo);
hold on; bar(fo, A)
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
length(i)/180
F = highpassfilter(V, sf, 200);
peakhist(H, filename);
[V, sf, filename]=readns;
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
F = highpassfilter(V, sf, 200);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
length(i)/180
[V, sf, filename]=readns;
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
F = highpassfilter(V, sf, 200);
peakhist(H, filename);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
(length(i)-1)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
length(i)/180
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
(length(i)-2)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 250, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
(length(i)-1)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 250, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 150, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
(length(i)-3)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
figure; plot3([1], [1], [1])
figure; plot3([1], [1], [1], '*')
R100807 = 0;
plot3(R100807(:,1), R100807(:,2), R100807(:,3))
plot3(R100807(:,1), R100807(:,2), R100807(:,3), '*')
R100907 = 0;
plot3(R100907(:,1), R100907(:,2), R100907(:,3), '*')
R101007 = 0;
plot3(R101007(:,1), R101007(:,2), R101007(:,3), '*')
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 250, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
(length(i)-2)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 200, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 300, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 250, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
length(i)/180
[V, sf, filename]=readns;
H = find_max(F);
F = highpassfilter(V, sf, 200);
H = find_max(F);
peakhist(H, filename);
[D, i, thresh] = threshold(F, H, sf, 12, 1, filename);
[D, i, thresh] = threshold(F, H, sf, 120, 1, filename);
[W, Wm, Ws] = waveform(F, i, sf, 2.5, 2.5, filename);
(length(i)-1)/180