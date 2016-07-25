function draw_tautau(W)

options = optimset;
options = optimset(options,'MaxFunEvals', 100000);
options = optimset(options,'MaxIter', 100000);

%xdata = (0:0.1:4.1)';
%Wneg = W(30:71,:);
x0 = [-250,200,0.5,0];
for j = 1:cols(W)
    amp(j) = max(W(:,j)) - min(W(:,j));
    
    imin = find(W(:,j)==min(W(:,j)));
    xdata = (0.1:0.1:2.2)';
    Wfit = W((imin+2):(imin+23),j);
    [x,resnorm,residual,exitflag(j)] =  lsqcurvefit(@exponential,x0,xdata,Wfit,[],[],options);

    x1(j) = x(1);
    x2(j) = x(2);
    x4(j) = x(4);
    tau(j) = x(3);
    
end

amp(exitflag<=0) = [];
tau(exitflag<=0) = [];
x1(exitflag<=0) = [];
x2(exitflag<=0) = [];

hold on; plot((imin)/10-2+xdata, exponential([mean(x1), mean(x2), median(tau), mean(x4)], xdata) - mean(W(1:15)), 'color', 'red');

disp(['Tau: ', num2str(median(tau))]);

%figure; plot(xdata, Wfit, '.');
%hold on; plot(xdata, exponential([mean(x1), mean(x2), median(tau), median(x4)], xdata));