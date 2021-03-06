function [Wrm, Wrmup, Wrmlo, Prup, Prlo, f] = stabstrap(V, sf, pre, post, n, iter, alpha)

T = length(V);

gui_active(1);
h = progressbar( [],0,'Bootstrapping STA...', 'stabstrap()' );
for j = 1:iter 
    h = progressbar( h,1/iter );
    if ~gui_active
        break;
    end
    irand = pre + floor(rand(n, 1)*(T - pre - post));
    [~, Wrm(:,j), ~] = waveform(V, irand, sf, pre, post, '');
    %[Pr(:,j),f] = periodogram(Wrm(:,j),[],50000,sf);
    temp=abs(fft(Wrm(:,j)));
    Pr(:,j)=temp(1:floor(end/2));
    f = (1:size(Pr(:,j),1)).*sf/(sf+1);
end
if gui_active
    h = progressbar( h,0,'Calculating percentiles...' );
    Wrmup = prctile(Wrm',100*(1-alpha/2))';
    Wrmlo = prctile(Wrm',100*alpha/2)';
    Prup = prctile(Pr',100*(1-alpha/2))';
    Prlo = prctile(Pr',100*alpha/2)';
end

progressbar( h,-1 );
