function [mi, phase_hist] =evokedPLV(LFP, DD, fs, pre, dur, fq, buff, nbin)

%get STAs
STApost = [];
for i=1:size(LFP,2)
    ind = round(find(DD(:,i)~=0)./30);
    ind(ind<round(fs*pre))=[];
    ind(ind>round(fs*(pre+dur)))=[];
    [STA, ~, ~] = waveform(LFP(:,i)-mean(LFP(:,i)), ind, fs, 500, 500, '');
    STApost(:,(end+1):(end+size(STA,2))) = STA;
end

for i=1:size(STApost,2)
    [~, ph(:,:,i)] = Wvtvarsf(STApost(:,i),fs,fq,buff);
end

phase_hist = zeros(nbin,size(ph,2), size(ph,1));
mi = zeros(size(ph,2), size(ph,1));

%  adapted from TAW's MI cfc script:
for f = 1:length(fq)
    for t=1:size(ph,2)
        bins=linspace(-pi,pi,nbin+1);
        bins=[bins(1:end-1) inf];
        maxE=log2(nbin);
        %bin phase angles at spike time
        P = histc(squeeze(ph(f,t,:)),bins);
        %bins=bins(1:end-1);
        P=P(1:end-1);
        %normalize P into pdf
        P=P./sum(P);
        phase_hist(:,t,f) = P;
        %compute modulation index
        mi(t,f)=(maxE+sum(P.*log2(P)))/maxE;
    end
end



% % bootstrap stats
% for iter=1:100
%     STApost_bstrap = [];
%     for i=1:size(LFP,2)
%         ind = round(find(DD(:,i)~=0)./30);
%         ind(ind<round(fs*pre))=[];
%         ind(ind>round(fs*(pre+dur)))=[];
%         n = length(ind);
%         
%         irand = fs*pre + floor(rand(n, 1)*fs*dur);
%         [STA, ~, ~] = waveform(LFP(:,i)-mean(LFP(:,i)), irand, fs, 500, 500, '');
%         STApost_bstrap(:,(end+1):(end+size(STA,2))) = STA;
%     end
%     temp=abs(fft(mean(STApost_bstrap,2)));
%     Pr(:,iter)=temp(1:floor(length(temp)/2));
%     f = (1:size(Pr(:,iter),1)).*fs/(fs+1);
% end
% Prup = prctile(Pr',100*(1-0.05/2))';
% Prlo = prctile(Pr',100*0.05/2)';
% 
% 
% figure; plot(f, Prup), hold on; plot(f, Prlo)
% xlim([0 100])
% temp=abs(fft(mean(STApost,2)));
% P=temp(1:floor(length(temp)/2));
% hold on, plot(f, P, 'r')

end