function specgram_induced(VV, sf, epoch_num)

WIN = 1000;

B = abs(specgram(VV(:,1),WIN,sf,WIN));
B = zeros(size(B));

for i = 1:epoch_num
    
    [P(:,i),f] = periodogram(VV(2000:6000,i),[],50000,sf);
    
    B = B + abs(specgram(VV(:,i),WIN,sf,WIN));
end

Bnorm = B/epoch_num;
[spec,f,t] = specgram(mean(VV,2),WIN,sf,WIN);

Pavg = mean(P,2);

[PVavg,f] = periodogram(mean(VV(2000:6000,:),2),[],50000,sf);


figure; plot(f, PVavg);
hold on; plot(f, Pavg, 'color', 'green');

figure; plot(f, Pavg-PVavg)

figure;
subplot(2,1,1);
imagesc(t,f,20*log10(Bnorm)), axis xy, colormap(jet)
ylim([0 80])
subplot(2,1,2);
imagesc(t,f,20*log10(abs(spec))), axis xy, colormap(jet)
ylim([0 80])

figure;
imagesc(t,f,20*log10(Bnorm - abs(spec))), axis xy, colormap(jet)
ylim([0 80])