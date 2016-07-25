function trialxCohCombined(m,n)
pinfo=m.pinfo;


%% Select Recordings
for i=1:size(pinfo,1)
    recs{i,1}=pinfo(i).pID;
end
[s1,ok] = listdlg('ListString',recs,'PromptString','Select recordings to analyze');

%% Initialize COH
if nargin<2
    COHinfo=struct;
    save('tempCOH','COHinfo','-v7.3')
    n=matfile('tempCOH','writable',true);
    k=1;
else
    k=2;
    COHinfo=n.COHinfo;
end


%% Set Conditions
% %Motivation Experiment
AndConds{1}={'Correct','Win','Go','Right'};
OrConds{1}={};
AndConds{2}={'Correct','Lose','Go','Right'};
OrConds{2}={};
AndConds{3}={'Correct','Squeeze','Go','Right'};
OrConds{3}={};
cntr='Cue'; cntrT=cntr

%% Set Parameters
buff=1;
buffbs=1;
fqint=1;
dsf=20;

% fq=4:fqint:35;
% fq1=[fq,fq(end)+fqint];

fq=2:fqint:4;
fq1=[fq,fq(end)+fqint];


%% RTS
clc

tic
for sbj_i=s1
    
    labels=pinfo(sbj_i).labels;
    pID=pinfo(sbj_i).pID;
    pre=pinfo(sbj_i).pre;
    post=pinfo(sbj_i).post;
    fs=pinfo(sbj_i).fs;
    trial=pinfo(sbj_i).trial;
    
%     pdata=m.pdata(sbj_i,1);
%     baselinedata=m.baselinedata(sbj_i,1);
    baselinedata= m.([pID, '_bd']);
    trialdata=m.([pID, '_Cue']);
    s=size(trialdata,1);
    if floor(s/2)~=s/2
        trialdata=trialdata(1:end-1,:,:);
    end
    t=linspace(-pre,post,size(trialdata,1));
    
    ind=SetStimInd(cntr,AndConds,OrConds,trial);%Only Need This When Calculating ZMI
    ind=FixNanTrials(ind,trialdata);
    
    ncnd=size(ind,2);
    nch=length(labels);
    
    COHinfo(sbj_i,1).pID=pinfo(sbj_i,1).pID;
    
    buffi=round(buff*fs)+1:size(trialdata,1)-ceil(buff*fs);
    tbuffi=t(buffi);
    tbuffi=tbuffi(dsf:dsf:end);
    
    Ph=zeros(length(fq),size(trialdata,1),size(trialdata,2),nch,'single');
    szPh=size(Ph);
    
    ch1=1:nch;
    ch1=nchoosek(ch1,2);
    nch1=size(ch1,1);
    
    for ch_i=1:size(labels,1)
        for st_i=1:size(trialdata,2)%Parallel here if using WvtforCFC...
            
            stimdata=trialdata(:,st_i,ch_i);

            
            %[~,~,Ph_tmp]=WvtforCFC(stimdata,fs,fq,0);%Consider replacing with filter/Hilbert method for better phase data
            Ph_tmp=[angle(Hilbert_Time_Freq(stimdata',fs,fq1,0))]';
            
            while size(Ph_tmp,2)>szPh(2), Ph_tmp(:,end)=[]; end
            Ph(:,:,st_i,ch_i)=Ph_tmp;
        end
        clc,
        fprintf(sprintf('Subject: %s (%d/%d) \n Time elapsed: %.1d min',pinfo(sbj_i).pID,sbj_i,max(s1),round(toc/60)));
        fprintf(sprintf('\n Channel: %d / %d\n',ch_i,size(labels,1)))
    end
    
    %Downsample Phase
    [Ph, fs] = coh_decimate (Ph, fs, dsf);
    buffi=round(buff*fs)+1:size(Ph,2)-ceil(buff*fs);
    %twin=.5*fs;%SET TWIN FOR CALCULATING COHERENCE
    twin=round((fq.^-1)*15*fs);
    szPh=size(Ph);

    
    n.([pID, '_Ca'])=zeros(szPh(1),length(buffi),nch1,ncnd,'single');
    n.([pID, '_Cp'])=zeros(szPh(1),length(buffi),nch1,ncnd,'single');
    n.([pID, '_Cts'])=zeros(szPh(1),length(buffi),nch1,ncnd,'single');

     %n.([pID, '_Cz'])=zeros(szPh(1),length(buffi),nch1,ncnd,'single');
    
    
    for ch1_i = 1:size(ch1,1)
        
        C_bs_tmp=[];
        bs1=baselinedata(dsf:dsf:end,ch1(ch1_i,1));
        bs2=baselinedata(dsf:dsf:end,ch1(ch1_i,2));
        sz=size(bs1);
        if floor(sz(1)/2) ~= sz(1)/2
            bs1=bs1(1:sz(1)-1,:);
            bs2=bs2(1:sz(1)-1,:);
        end
        ph_bs{1}=[angle(Hilbert_Time_Freq(bs1,fs,fq1,1))]';
        ph_bs{2}=[angle(Hilbert_Time_Freq(bs2,fs,fq1,1))]';
        
        
        [C_bs_tmp] = phasecoher(ph_bs{1}',ph_bs{2}',twin);
        C_bs_std=[std(C_bs_tmp,[],1)]';
        C_bs_mn=[mean(C_bs_tmp,1)]';
        
        Cch1=zeros(szPh(1),length(buffi),szPh(3),'single');
        Czch1=zeros(szPh(1),length(buffi),szPh(3),'single');
        
        ph1=Ph(:,:,:,ch1(ch1_i,1));
        ph2=Ph(:,:,:,ch1(ch1_i,2));
        parfor st_i=1:size(Ph,3)
            ph11=ph1(:,:,st_i);
            ph22=ph2(:,:,st_i);
            [Ctmp] = phasecoher(ph11',ph22',twin); Ctmp=Ctmp';
            Ctmp=Ctmp(:,buffi);
            Cch1(:,:,st_i)=Ctmp;%Take Absolute Coherence
            %Czch1(:,:,st_i)= bsxfun(@rdivide,  bsxfun(@minus,Ctmp,C_bs_mn), C_bs_std);%Take Z Score
        end
        
        sz=size(n,[pID, '_Ca']);
        Catmp=zeros(sz(1),sz(2),1,sz(4),'single');
        Cptmp=Catmp; Ctstmp=Catmp;
        %Cztmp=zeros(sz(1),sz(2),1,sz(4),'single');
        for cnd_i=1:ncnd
            Art1=pinfo(sbj_i).Arts{ch1(ch1_i,1)};
            Art2=pinfo(sbj_i).Arts{ch1(ch1_i,2)};
            Art=union(Art1,Art2);
            ind1=setxor(ind{cnd_i},Art);

            Catmp(:,:,1,cnd_i)=mean( Cch1(:,:,ind1) ,3);
            %Cztmp(:,:,1,cnd_i)=mean( Czch1(:,:,ind1) ,3);
            [Cptmp(:,:,1,cnd_i), Ctstmp(:,:,1,cnd_i)] = ttest_local(Cch1(:,:,ind1),C_bs_tmp');
        end
        n.([pID, '_Ca'])(:,:,ch1_i,:)=Catmp; clear Catmp
        %n.([pID, '_Cz'])(:,:,ch1_i,:)=Cztmp; clear Cztmp
        n.([pID, '_Cp'])(:,:,ch1_i,:)=Cptmp; clear Ctmp
        n.([pID, '_Cts'])(:,:,ch1_i,:)=Ctstmp; clear Ctstmp
        clear Cch1 Czch1
        clc
        fprintf(sprintf('Subject: %s (%d/%d) \n Channel: %d/%d\nTime elapsed: %.2f min\n',pinfo(sbj_i).pID,sbj_i,max(s1),ch1_i,size(ch1,1),toc/60));
        
    end
    
    COHinfo(sbj_i,1).ChCombos=ch1;
    COHinfo(sbj_i,1).labels=labels;
    COHinfo(sbj_i,1).fq=fq;
    COHinfo(sbj_i,1).t=tbuffi;
    COHinfo(sbj_i,1).AndConds=AndConds;
    COHinfo(sbj_i,1).OrConds=OrConds;
    n.COHinfo=COHinfo;
          
end

end

function ind=SetStimInd(cntr,AndConds,OrConds,trial)
for cnd_i=1:size(AndConds,2)
ind{cnd_i}=IndFromCond(AndConds{cnd_i},OrConds{cnd_i},trial);
end
end

function ind=FixNanTrials(ind,trialdata)
for ind_i=1:size(ind,2)
ind{ind_i}(isnan(trialdata(1,ind{ind_i},1)))=[];
end
end


function [dataout, fsout] = coh_decimate (datain, fsin, dsf)

fsout=fsin/dsf;
sz=size(datain);
if floor(sz(2)/2)~=sz(2)/2
    datain(:,1:sz(2)-1,:,:)=[];
    sz=size(datain);
end
dataout=datain(:,dsf:dsf:sz(2),:,:);

end


function [P, TS] = ttest_local (x,y)
%x - [fq, t, tr]
%y - [fq, t]
sz=size(x);
TS=zeros(sz(1),sz(2),'single');
P=zeros(sz(1),sz(2),'single');

for i=1:sz(1)
    x1=squeeze(x(i,:,:));
    y1=squeeze(y(i,:));
    dim=2;
    
    nx=size(x1,dim);
    ny=size(y1,dim);
    s2x = nanvar(x1,[],dim);
    s2y = nanvar(y1,[],dim);
    difference = nanmean(x1,dim) - nanmean(y1,dim);
    dfe = nx + ny - 2;
    sPooled = sqrt(((nx-1) .* s2x + (ny-1) .* s2y) ./ dfe);
    se = sPooled .* sqrt(1./nx + 1./ny);
    ts = difference ./ se;
    p = 2 * tcdf(-abs(ts),dfe);
    
    TS(i,:)=ts;
    P(i,:)=p;
end

end