function [sfc,stats]=SpikeLockPhase(ph,spikes,sr,pre,post,edge,method,...
    nbin,niter,par)
% [sfc,stats]=SpikeLockPhase(ph,spikes,sr,pre,post,edge,method,nbin,...
%     niter,par)
% computes spike-triggered phase-locking of the LFP between one phase 
%     timeseries and one spike timeseries
% 
% ph: 2D matrix of phase values (complex if method==1, real [-pi,pi] if 
%     method==2)
% spikes: vector of spike times in sample points
% sr: sampling rate(Hz)
% pre & post: time(sec) before and after spikes to include in field locking
% edge: sample points within ph to repect as internal edge (for trial-wise
%     calculations in which ph is a pseudo continuous TS made via trial
%     stitching); if==1, then no internal edge are respected
% method: if==1, computes phase-locking factor (PLF)
%         if==2, computes modulation index (MI)
% nbin: number of bins to split phase into (32 should work); used only for
%     method==2 (arg should still be passed for method==1 so that argsin 
%     are still read correctly)
% niter: number of iterations for shuffling to generate null distribution
%     (if niter<2 then no shuffling or stats are run, thus fast)
% par: if==1, uses parfor loop to generate null
%      if~=1, uses for loop to generate null (use if parfor function calls)
% 
% 
% TAW_062415


%convert pre and post into sample points
pre=round(pre*sr);
post=round(post*sr);
%orient ph
ph=squeeze(ph);
[pr,pc]=size(ph);
if pr>pc
    ph=ph';
    tempr=pr;
    pr=pc;
    pc=tempr;
end
%check spikes to ensure that values are in terms of sample points
if length(unique(spikes))==2%binary index of spike times
    tmp=[1:pr]';
    spikes=tmp(spikes==1);
    clear('tmp')
elseif any(round(spikes)~=spikes)%spike times are in seconds
    spikes=round(spikes/sr);
end
spikes=reshape(spikes,1,[]);
%remove edge
spiked=spikes(spikes>pre & spikes<pc-post);
for ne=1:length(edge)
    spiked(spiked>edge(ne)-post & spiked<edge(ne)+pre)=[];
end
nsp=length(spiked);%number of spikes



if method==1%compute analog of phase-locking factor
    if isreal(ph)
        error('ph variable needs to be complex for method==1')
    end
    
    %normalize ph vectors to unit length
    ph=ph./abs(ph);
    %create spike-triggered windows
    ind=reshape(bsxfun(@plus,(-pre:post)',spiked),[],1);
    tmp=reshape(ph(:,ind),pr,pre+post+1,nsp);
    %compute PLF
    tmp=mean(tmp,3);
    sfc.PLFamp=abs(tmp);
    sfc.PLFph=angle(tmp);
    
    
    %statistical shuffling
    stats=NaN;
    if niter>1 && par~=1
        %generate null distribution
        shift=randi(pc,niter,1);
        surr=ones(pre+post+1,pr,niter);
        for ni=1:niter
            %circularly shift spikes and remove edge
            spiked=spikes+shift(ni);
            ind=(spiked>old_pr);
            spiked(ind)=spiked(ind)-old_pr;
            spiked=spiked(spiked>pre & spiked<old_pr-post);
            for ne=1:length(edge)
                spiked(spiked>edge(ne)-post & spiked<edge(ne)+pre)=[];
            end
            nsd=length(spiked);
            %gather spike-triggered windows
            ind=reshape(bsxfun(@plus,(-pre:post)',spiked),[],1);
            tmp=reshape(ph(:,ind),pr,pre+post+1,nsp);
            
            onez=ones(pre+post+1,old_pc,nsd);
            tmp=complex(onez,onez);
            for n=1:nsd
                tmp(:,:,n)=ph(spiked(n)-pre:spiked(n)+post,:);
            end
            %compute PLF
            surr(:,:,ni)=abs(mean(tmp,3));
        end
        %save null stats
        mu=mean(surr,3);
        stats.PLFmu=mu;
        sd=std(surr,0,3);
        stats.PLFsd=sd;
        stats.surr=surr;
        %BLOB
        
    elseif niter>1 && par==1
        %generate null distribution
        shift=randi(old_pr,niter,1);
        surr=ones(pre+post+1,old_pc,niter);
        parfor ni=1:niter
            %circularly shift spikes and remove edge
            spiked=spikes+shift(ni);
            ind=(spiked>old_pr);
            spiked(ind)=spiked(ind)-old_pr;
            spiked=spiked(spiked>pre & spiked<old_pr-post);
            for ne=1:length(edge)
                spiked(spiked>edge(ne)-post & spiked<edge(ne)+pre)=[];
            end
            nsd=length(spiked);
            %gather spike-triggered windows
            onez=ones(pre+post+1,old_pc,nsd);
            tmp=complex(onez,onez);
            for n=1:nsd
                tmp(:,:,n)=ph(spiked(n)-pre:spiked(n)+post,:);
            end
            %compute PLF
            surr(:,:,ni)=abs(mean(tmp,3));
        end    
        %save null stats
        mu=mean(surr,3);
        stats.PLFmu=mu;
        sd=std(surr,0,3);
        stats.PLFsd=sd;
        stats.surr=surr;
        %BLOB
    end
    
    
elseif method==2%compute analog of Modulation Index (Tort,2010)
    if ~isreal(ph)
        error('ph variable needs to be real [-pi,pi] for method==2')
    end
    
    %initialize parameters
    bins=linspace(-pi,pi,nbin+1);
    bins=[-inf bins(2:end-1) inf];
    maxE=log2(nbin);
    imaxE=1/maxE;
    %create spike-triggered windows
    tmp=ones(pre+post+1,old_pc,nsp);
    for n=1:nsp
        tmp(:,:,n)=ph(spiked(n)-pre:spiked(n)+post,:);
    end
    %get phase distribution
    sfc.MIphdist=histc(tmp,bins,3);%get counts with in phase bins
    %compute MI
    nph=sfc.MIphdist./repmat(sum(sfc.MIphdist,3),1,1,nbin+1);%make a PDF
    nph=nph.*log2(nph);%bits of info
    nph(isnan(nph))=0;
    sfc.MI=(maxE+sum(nph,3))*imaxE;%normalize by max bits
    
    
    %statistical shuffling
    stats=NaN;
    if niter>1 && par~=1
        %generate null distribution
        shift=randi(old_pr,niter,1);
        surr=ones(pre+post+1,old_pc,niter);
        for ni=1:niter
            %circularly shift spikes and remove edge
            spiked=spikes+shift(ni);
            ind=(spiked>old_pr);
            spiked(ind)=spiked(ind)-old_pr;
            spiked=spiked(spiked>pre & spiked<old_pr-post);
            for ne=1:length(edge)
                spiked(spiked>edge(ne)-post & spiked<edge(ne)+pre)=[];
            end
            nsd=length(spiked);
            %gather spike-triggered windows
            tmp=ones(pre+post+1,old_pc,nsd);
            for n=1:nsd
                tmp(:,:,n)=ph(spiked(n)-pre:spiked(n)+post,:);
            end
            %compute MI
            nph=histc(tmp,bins,3);%get counts with in phase bins
            nph=nph./repmat(sum(nph,3),1,1,nbin+1);%make a PDF
            nph=nph.*log2(nph);%bits of info
            nph(isnan(nph))=0;
            surr(:,:,ni)=(maxE+sum(nph,3))*imaxE;%normalize by max bits
        end
        %save null stats
        mu=mean(surr,3);
        stats.MImu=mu;
        sd=std(surr,0,3);
        stats.MIsd=sd;
        stats.surr=surr;
        %BLOB
        
    elseif niter>1 && par==1
        %generate null distribution
        shift=randi(old_pr,niter,1);
        surr=ones(pre+post+1,old_pc,niter);
        parfor ni=1:niter
            %circularly shift spikes and remove edge
            spiked=spikes+shift(ni);
            ind=(spiked>old_pr);
            spiked(ind)=spiked(ind)-old_pr;
            spiked=spiked(spiked>pre & spiked<old_pr-post);
            for ne=1:length(edge)
                spiked(spiked>edge(ne)-post & spiked<edge(ne)+pre)=[];
            end
            nsd=length(spiked);
            %gather spike-triggered windows
            tmp=ones(pre+post+1,old_pc,nsd);
            for n=1:nsd
                tmp(:,:,n)=ph(spiked(n)-pre:spiked(n)+post,:);
            end
            %compute MI
            nph=histc(tmp,bins,3);%get counts with in phase bins
            nph=nph./repmat(sum(nph,3),1,1,nbin+1);%make a PDF
            nph=nph.*log2(nph);%bits of info
            nph(isnan(nph))=0;
            surr(:,:,ni)=(maxE+sum(nph,3))*imaxE;%normalize by max bits
        end
        %save null stats
        mu=mean(surr,3);
        stats.MImu=mu;
        sd=std(surr,0,3);
        stats.MIsd=sd;
        stats.surr=surr;
        %BLOB
        
    end
end
end