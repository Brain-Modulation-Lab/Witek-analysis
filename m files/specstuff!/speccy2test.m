function speccy2=speccy2(Data, x1, x2, y1, y2)

figure
subplot(1.5,1,1)
specgram(Data,1024,1000,hanning(256),32),axis([x1,x2,y1,y2]);
%colorbar('NorthOutside');

hold on % holds on to the last figure window (hopefully)
subplot(3,1,3)
plot(Data),axis([x1,x2,y1,y2]);
%title('Time (ms)');
