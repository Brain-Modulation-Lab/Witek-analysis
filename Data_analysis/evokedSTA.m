function [] =evokedSTA(LFP, DD, fs, pre, dur, highpass_cutoff)

%get STAs
STApost = [];
for i=1:size(LFP,2)
    ind = round(find(DD(:,i)~=0)./30);
    ind(ind<round(fs*pre))=[];
    ind(ind>round(fs*(pre+dur)))=[];
    [STA, ~, ~] = waveform(highpassfilter(LFP(:,i)-mean(LFP(:,i)), fs, highpass_cutoff), ind,fs, 500, 500, '');
    STApost(:,(end+1):(end+size(STA,2))) = STA;
end

% bootstrap stats
for iter=1:100
    STApost_bstrap = [];
    for i=1:size(LFP,2)
        ind = round(find(DD(:,i)~=0)./30);
        ind(ind<round(fs*pre))=[];
        ind(ind>round(fs*(pre+dur)))=[];
        n = length(ind);
        
        irand = fs*pre + floor(rand(n, 1)*fs*dur);
        [STA, ~, ~] = waveform(highpassfilter(LFP(:,i)-mean(LFP(:,i)), fs, highpass_cutoff), irand, fs, 500, 500, '');
        STApost_bstrap(:,(end+1):(end+size(STA,2))) = STA;
    end
    temp=abs(fft(mean(STApost_bstrap,2)));
    Pr(:,iter)=temp(1:floor(length(temp)/2));
    f = (1:size(Pr(:,iter),1)).*fs/(fs+1);
end
Prup = prctile(Pr',100*(1-0.05/2))';
Prlo = prctile(Pr',100*0.05/2)';
figure; plot(f, Prup), hold on; plot(f, Prlo)
xlim([0 100])
temp=abs(fft(mean(STApost,2)));
P=temp(1:floor(length(temp)/2));
hold on, plot(f, P, 'r')

end