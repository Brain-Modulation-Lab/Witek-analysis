function [tau, amp] = tautau(W)



xdata = (0:0.1:4.1)';
Wneg = W(30:71,:);
x0 = [-250,200,0.5];
for j = 1:cols(W)
amp(j) = max(W(:,j)) - min(W(:,j));
[x,resnorm,residual,exitflag(j)] =  lsqcurvefit(@exponential,x0,xdata,Wneg(:,j));
tau(j) = x(3);
end

amp(exitflag<=0) = [];
tau(exitflag<=0) = [];
