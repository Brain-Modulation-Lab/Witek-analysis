function [ mi, zmi, pmi, phase_hist ] = miSPL( LFP, tstamps, fq, nbin, niter )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

t1=clock;

fs=1000;
prespike = 500;
postspike = 500;
bins=linspace(-pi,pi,nbin+1);
bins=[bins(1:end-1) inf];
maxE=log2(nbin);

[~, ph] = Wvtvarsf(LFP, fs, fq, 0);

% get phase STA
% adapted from WJL's waveform script
sample_stamps = round(fs*tstamps);
phSTA = zeros(size(ph,1), prespike+postspike+1, length(sample_stamps));
discard = []; k=0; % STAs for spikes near the edges of LFP will be discarded
for j = 1:length(sample_stamps)
    if((sample_stamps(j)-prespike)>0 & (sample_stamps(j)+postspike)<=size(ph,2))
        phSTA(:,:,j)=ph(:, sample_stamps(j)-prespike:sample_stamps(j)+postspike); 
    else
        k=k+1;
        discard(k) = j;
    end
end
phSTA(:, :, discard) = [];

phase_hist = zeros(nbin, size(phSTA,2), size(phSTA,1));
mi = zeros(size(phSTA,2), size(phSTA,1));

%  adapted from TAW's MI cfc script:
for f = 1:length(fq)
    for t=1:size(phSTA,2)
        %bin phase angles at spike time
        P = histc(squeeze(phSTA(f,t,:)),bins);
        %bins=bins(1:end-1);
        P=P(1:end-1);
        %normalize P into pdf
        P=P./sum(P);
        phase_hist(:,t,f) = P;
        %compute modulation index
        mi(t,f)=(maxE+sum(P.*log2(P)))/maxE;
    end
end

%------------------------------------
% calculate zmi
% (adapted from TAW's MI cfc script)
%------------------------------------

zmi = zeros(size(phSTA,2), size(phSTA,1));
shift=ceil(rand(niter,1)*size(ph,2));

for i=1:niter

    ph_surr = [ph(:,shift(i):end), ph(:,1:shift(i)-1)];
    
    phSTAsurr = zeros(size(ph_surr,1), prespike+postspike+1, length(sample_stamps));
    discard = []; k=0; % STAs for spikes near the edges of LFP will be discarded
    for j = 1:length(sample_stamps)
        if((sample_stamps(j)-prespike)>0 & (sample_stamps(j)+postspike)<=size(ph_surr,2))
            phSTAsurr(:,:,j)=ph_surr(:, sample_stamps(j)-prespike:sample_stamps(j)+postspike);
        else
            k=k+1;
            discard(k) = j;
        end
    end
    phSTAsurr(:, :, discard) = [];
    
    for f = 1:length(fq)
        for t=1:size(phSTAsurr,2)
            %bin phase angles at spike time
            Psurr = histc(squeeze(phSTAsurr(f,t,:)),bins);
            %bins=bins(1:end-1);
            Psurr = Psurr(1:end-1);
            %normalize P into pdf
            Psurr = Psurr./sum(Psurr);
            %compute modulation index
            mi_surr(t,f,i) = (maxE+sum(Psurr.*log2(Psurr)))/maxE;
        end
    end
end

for f = 1:length(fq)
    for t=1:size(phSTAsurr,2)
        zmi(t,f)=(mi(t,f)-mean(mi_surr(t,f,:)))/std((mi_surr(t,f,:)));
    end
end

pmi = ones(size(zmi))-cdf('normal',zmi,0,1);

t2=clock;

fprintf('Time = %d seconds\n', etime(t2,t1));

%figure; imagesc((1:(prespike+postspike+1))/fs-0.5, fq, mi'); set(gca,'YDir','normal'); 

%figure; imagesc((1:(prespike+postspike+1))/fs-0.5, fq, zmi'); set(gca,'YDir','normal'); 


end

