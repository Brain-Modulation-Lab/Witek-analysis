function [mi, phase_hist, STA] =evokedPLV2(LFP, SpikeTimes, SelectedTimes, fs, tstart, tend, fq, buff, nbin)

%get STAs
STA = [];
for i=1:length(SelectedTimes)
    ind = round(1000*SpikeTimes(SpikeTimes>=(SelectedTimes(i)+tstart)&SpikeTimes<(SelectedTimes(i)+tend)));
    [thisSTA, ~, ~] = waveform(LFP-mean(LFP), ind, fs, 500, 500, '');
    STA(:,(end+1):(end+size(thisSTA,2))) = thisSTA;
    EpochNspikes(i) = length(ind);
end

for i=1:size(STA,2) 
    [~, ph(:,:,i)] = Wvtvarsf(STA(:,i),fs,fq,buff);
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



% bootstrap stats
for iter=1:100
    STAbstrap = [];
    for i=1:length(SelectedTimes)
        irand = round(fs*(SelectedTimes(i) + rand(EpochNSpikes(i), 1)*(tend-tstart)-tstart));
        [thisSTA, ~, ~] = waveform(LFP-mean(LFP), irand, fs, 500, 500, '');
        STAbstrap(:,(end+1):(end+size(thisSTA,2))) = thisSTA;
    end

for i=1:size(STAbstrap,2) 
    [~, ph_bstrap(:,:,i)] = Wvtvarsf(STAbstrap(:,i),fs,fq,buff);
end

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
        %compute modulation index
        mi(t,f)=(maxE+sum(P.*log2(P)))/maxE;
    end
end
end


end