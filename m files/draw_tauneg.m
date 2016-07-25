function draw_tauneg(W)

for j = 1:cols(W)
    
amp(j) = max(W(:,j)) - min(W(:,j));    
baseline = mean(W(1:15,j));
baseline1 = baseline - 0.1*(baseline-min(W(:,j)));
t1 = find([W(21:71,j);baseline] <= baseline);
imin = find(W(:,j)==min(W(:,j)));
t2 = find([W(imin:71,j);baseline1] >= baseline1);
tneg(j) = ((imin(1)+t2(1)-1) - (20+t1(1)))/10;

end

amp(tneg<0) = [];
tneg(tneg<0) = [];


hold on; plot([(median(t1(1))-1)/10 (median(t1(1))-1)/10+median(tneg)], [0 0], 'color', 'red')

disp(['Tneg: ', num2str(median(tneg))]);