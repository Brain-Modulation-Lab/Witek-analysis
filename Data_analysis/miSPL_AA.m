function [ mi, zmi, pmi, phase_hist, FDR, Q ] = miSPL_AA( LFP, fs, tstamps, fq, nbin, niter, prespike, postspike)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% tic
prespike = round(prespike*fs);
postspike = round(postspike*fs);
bins=linspace(-pi,pi,nbin+1);
bins=[bins(1:end-1) inf];
maxE=log2(nbin);

bins2=1:nbin;

% WAVELET OPTION
ph = angle(fast_wavtransform(fq, LFP, fs, 7));
ph=single(ph);

% HILBERT OPTION
% fqres = fq(2)-fq(1);
% fq_filt = ([fq(1)-fqres, fq] + [fq, fq(end)+fqres])./2;
% ph=angle(Hilbert_Time_Freq(LFP, fs, fq_filt, 0));
% ph=single(ph);


pr=size(ph,1);
for i=1:length(fq)
    [~,ph_org(:,i)]=histc(ph(:,i),bins);
end
ph_org=int8(ph_org);
% get phase STA
% adapted from WJL's waveform script
sample_stamps = round(fs*tstamps);

k=1; % STAs for spikes near the edges of LFP will be discarded
for j = 1:length(sample_stamps)
    if((sample_stamps(j)-prespike)>0 & (sample_stamps(j)+postspike)<=pr)
        new_tstamps(k)=sample_stamps(j);
        k=k+1;
    end
end

phSTA = zeros( prespike+postspike+1, size(ph,2),length(new_tstamps),'int8');
for j = 1:length(new_tstamps)
    phSTA(:,:,j)=ph_org(new_tstamps(j)-prespike:new_tstamps(j)+postspike,:);
end
phSTA=permute(phSTA,[3,1,2]);
phase_hist = zeros(nbin, size(phSTA,2), size(phSTA,1));
mi = zeros(size(phSTA,2), size(phSTA,1));

%  adapted from TAW's MI cfc script:

%bin phase angles at spike time
P = histc(phSTA,bins2,1);
%normalize P into pdf
P=P./sum(P(:,1,1));
phase_hist=P;
   PdotlogP = P.*log2(P);
 PdotlogP(isnan(PdotlogP)) = 0;
%compute modulation index
mi=squeeze((maxE+sum(PdotlogP))/maxE);


clearvars ph_org phSTA LFP 
%------------------------------------
% calculate zmi
% (adapted from TAW's MI cfc script)
%------------------------------------

sph=zeros(pr,niter,'single');
% Psurr=zeros(nbin,prespike+postspike+1,niter,'single');
% phSTAsurr=zeros(length(new_tstamps),prespike+postspike+1,niter,'int8');
parfor f=1:length(fq)

    shift=randperm(pr,niter)';
    sph=repmat(ph(:,f),1,niter);
    [sph]=make_surr(sph,shift,bins,niter);
    sph=int8(sph);
    Psurr=single(genSTAsurr(sph,new_tstamps,prespike,postspike,niter,nbin));
    
    Psurr = Psurr./sum(Psurr(:,1));
     PdotlogP = Psurr.*log2(Psurr);
     PdotlogP(isnan(PdotlogP)) = 0;
    mi_surr(f,:,:)=(maxE+sum(PdotlogP))/maxE;

end

zmi=(mi-mean(mi_surr,3)')./std(mi_surr,0,3)';
pmi = ones(size(zmi))-cdf('normal',zmi,0,1);
[FDR, Q, Pi] = mafdr(reshape(pmi,[],1));
FDR=reshape(FDR,prespike+postspike+1,length(fq));
Q=reshape(Q,prespike+postspike+1,length(fq));
% toc
% figure; imagesc((1:(prespike+postspike+1))/fs-0.5, fq, mi'); set(gca,'YDir','normal'); title('mi')
% figure; imagesc((1:(prespike+postspike+1))/fs-0.5, fq, zmi'); set(gca,'YDir','normal'); title('zmi')
end
function [sph]=make_surr(sph,shift,bins,niter)
for n=1:niter
    sph(:,n)=circshift(sph(:,n),shift(n),1);
    [~,sph(:,n)]=histc(sph(:,n),bins);
end

end
function Psurr=genSTAsurr(sph,new_tstamps,prespike,postspike,niter,nbin)
phSTAsurr=zeros((prespike+postspike+1),niter,length(new_tstamps),'int8');
for j = 1:length(new_tstamps)
 phSTAsurr(:,:,j)=sph(new_tstamps(j)-prespike:new_tstamps(j)+postspike,:);      
end
  phSTAsurr=permute(phSTAsurr,[3,1,2]);
  Psurr = histc(phSTAsurr,1:nbin,1);
end