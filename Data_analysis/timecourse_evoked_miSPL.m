function [timecourse] = timecourse_evoked_miSPL(LFP, SpikeTimes, SelectedTimes, fq, nbin, niter)
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

shift=ceil(rand(niter,1)*size(ph,2));

% %+++++++
% minans = zeros(10);
% zminans = zeros(10,100);
% %+++++++

for timeblocks=1:10
    
    t1=clock;
    
    tstart = (timeblocks-1)/2-2.5;
    tend = (timeblocks+1)/2-2.5;
    
    fprintf('time segment %d - %d...  ', tstart, tend);
      
    % get phase STA
    % adapted from WJL's waveform script
    phSTA = [];
    for i=1:length(SelectedTimes)
        sample_stamps = round(fs*SpikeTimes(SpikeTimes>=(SelectedTimes(i)+tstart) & SpikeTimes<(SelectedTimes(i)+tend)));
        thisphSTA = zeros(size(ph,1), prespike+postspike+1, length(sample_stamps));
        discard = []; k=0; % STAs for spikes near the edges of LFP will be discarded
        for j = 1:length(sample_stamps)
            if((sample_stamps(j)-prespike)>0 & (sample_stamps(j)+postspike)<=size(ph,2))
                thisphSTA(:,:,j)=ph(:, sample_stamps(j)-prespike:sample_stamps(j)+postspike);
            else
                k=k+1;
                discard(k) = j;
            end
        end
        thisphSTA(:, :, discard) = [];
        phSTA(:, :, (end+1):(end+size(thisphSTA,3))) = thisphSTA;
    end
    
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
% %+++++++
% temp = (maxE+sum(P.*log2(P)))/maxE;
% if isnan(temp)
% minans(timeblocks) = minans(timeblocks)+1;
% end
% %+++++++
            PdotlogP = P.*log2(P);
            PdotlogP(isnan(PdotlogP)) = 0;
            mi(t,f)=(maxE+sum(PdotlogP))/maxE;
        end
    end
    
    %------------------------------------
    % calculate zmi
    % (adapted from TAW's MI cfc script)
    %------------------------------------
    
    mi_surr = zeros(size(phSTA,2), size(phSTA,1), niter);
    zmi = zeros(size(phSTA,2), size(phSTA,1));
    
    for iter=1:niter
        
        ph_surr = [ph(:,shift(iter):end), ph(:,1:shift(iter)-1)];
        
        % get phase STA
        % adapted from WJL's waveform script
        phSTAsurr = [];
        for i=1:length(SelectedTimes)
            sample_stamps = round(fs*SpikeTimes(SpikeTimes>=(SelectedTimes(i)+tstart) & SpikeTimes<(SelectedTimes(i)+tend)));
            thisphSTAsurr = zeros(size(ph_surr,1), prespike+postspike+1, length(sample_stamps));
            discard = []; k=0; % STAs for spikes near the edges of LFP will be discarded
            for j = 1:length(sample_stamps)
                if((sample_stamps(j)-prespike)>0 & (sample_stamps(j)+postspike)<=size(ph_surr,2))
                    thisphSTAsurr(:,:,j)=ph_surr(:, sample_stamps(j)-prespike:sample_stamps(j)+postspike);
                else
                    k=k+1;
                    discard(k) = j;
                end
            end
            thisphSTAsurr(:, :, discard) = [];
            phSTAsurr(:, :, (end+1):(end+size(thisphSTAsurr,3))) = thisphSTAsurr;
        end
        
        for f = 1:length(fq)
            for t=1:size(phSTAsurr,2)
                %bin phase angles at spike time
                Psurr = histc(squeeze(phSTAsurr(f,t,:)),bins);
                %bins=bins(1:end-1);
                Psurr = Psurr(1:end-1);
                %normalize P into pdf
                Psurr = Psurr./sum(Psurr);
                %compute modulation index
% %+++++++
% temp = (maxE+sum(Psurr.*log2(Psurr)))/maxE;
% if isnan(temp)
% zminans(timeblocks, iter) = zminans(timeblocks, iter)+1;
% end
% %+++++++
                PdotlogP = Psurr.*log2(Psurr);
                PdotlogP(isnan(PdotlogP)) = 0;
                mi_surr(t,f,iter)=(maxE+sum(PdotlogP))/maxE;
            end
        end
    end
    
    for f = 1:length(fq)
        for t=1:size(zmi,1)
            zmi(t,f)=(mi(t,f)-mean(mi_surr(t,f,:)))/std((mi_surr(t,f,:)));
        end
    end
    
    timecourse(timeblocks).mi = mi;
    timecourse(timeblocks).phase_hist = phase_hist;
    timecourse(timeblocks).zmi = zmi;
    timecourse(timeblocks).pmi = ones(size(zmi))-cdf('normal',zmi,0,1);
    
    t2=clock;
    
    fprintf('completed in %d minutes.\n', etime(t2,t1)/60);
    
end

end