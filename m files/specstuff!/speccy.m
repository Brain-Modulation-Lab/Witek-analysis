function speccy = speccy(Data)

figure
subplot(1.5,1,1)
specgram(Data,1024,1000,hanning(256),32);
colorbar('vert')'

hold on % holds on to the last figure window (hopefully)
subplot(3,1,3)
plot(Data);
xlabel('Time (ms)');
