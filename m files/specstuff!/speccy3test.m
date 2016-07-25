function speccy3=speccy3(Data,x1,x2,y1,y2)
hold on % holds on to the last figure window (hopefully)
subplot(3,1,3)
plot(Data),axis([x1,x2,y1,y2]);
xlabel('Time (ms)');