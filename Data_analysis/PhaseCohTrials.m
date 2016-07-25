function [ Ph, Ca, fs ] = PhaseCohTrials( trialdata, baselinedata, labels, Trials, fs, pre, post, buff)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% trialdata = (samples x trials x channels)

%% Set Parameters
buffbs=1;
fqint=2.5;
dsf=1;

ncnd=1;

% fq=4:fqint:35;
% fq1=[fq,fq(end)+fqint];

fq=4:1:55;
fq1=[fq,fq(end)+fqint];


pID='';
trial=0;

s=size(trialdata,1);
if floor(s/2)~=s/2
    trialdata=trialdata(1:end-1,:,:);
end
t=linspace(-pre,post,size(trialdata,1));

nch=length(labels);

buffi=round(buff*fs)+1:size(trialdata,1)-ceil(buff*fs);
tbuffi=t(buffi);
tbuffi=tbuffi(dsf:dsf:end);

Ph=zeros(length(fq),size(trialdata,1),size(trialdata,2),nch,'single');
szPh=size(Ph);

ch1=1:nch;
ch1=nchoosek(ch1,2);
nch1=size(ch1,1);

for ch_i=1:nch
    for st_i=1:size(trialdata,2)%Parallel here if using WvtforCFC...
        
        stimdata=trialdata(:,st_i,ch_i);
        
        
        %[~,~,Ph_tmp]=WvtforCFC(stimdata,fs,fq,0);%Consider replacing with filter/Hilbert method for better phase data
        Ph_tmp=[angle(Hilbert_Time_Freq(stimdata',fs,fq1,0))]';
        
        while size(Ph_tmp,2)>szPh(2), Ph_tmp(:,end)=[]; end
        Ph(:,:,st_i,ch_i)=Ph_tmp;
    end
    clc,
    %fprintf(sprintf('Subject: %s (%d/%d) \n Time elapsed: %.1d min',pinfo(sbj_i).pID,sbj_i,max(s1),round(toc/60)));
    %fprintf(sprintf('\n Channel: %d / %d\n',ch_i,size(labels,1)))
end

%Downsample Phase
[Ph, fs] = coh_decimate (Ph, fs, dsf);
buffi=round(buff*fs)+1:size(Ph,2)-ceil(buff*fs);
%twin=.5*fs;%SET TWIN FOR CALCULATING COHERENCE
twin=round((fq.^-1)*10*fs);
szPh=size(Ph);


Ca = zeros(szPh(1),length(buffi),nch1,ncnd,'single');
%Cp = zeros(szPh(1),length(buffi),nch1,ncnd,'single');
%Cts = zeros(szPh(1),length(buffi),nch1,ncnd,'single');

%n.([pID, '_Cz'])=zeros(szPh(1),length(buffi),nch1,ncnd,'single');


for ch1_i = 1:size(ch1,1)
    
%     C_bs_tmp=[];
%     bs1=baselinedata(dsf:dsf:end,ch1(ch1_i,1));
%     bs2=baselinedata(dsf:dsf:end,ch1(ch1_i,2));
%     sz=size(bs1);
%     if floor(sz(1)/2) ~= sz(1)/2
%         bs1=bs1(1:sz(1)-1,:);
%         bs2=bs2(1:sz(1)-1,:);
%     end
%     ph_bs{1}=[angle(Hilbert_Time_Freq(bs1,fs,fq1,1))]';
%     ph_bs{2}=[angle(Hilbert_Time_Freq(bs2,fs,fq1,1))]';
%     
%     
%     [C_bs_tmp] = phasecoher(ph_bs{1}',ph_bs{2}',twin);
%     C_bs_std=[std(C_bs_tmp,[],1)]';
%     C_bs_mn=[mean(C_bs_tmp,1)]';
    
    Cch1=zeros(szPh(1),length(buffi),szPh(3),'single');
%   Czch1=zeros(szPh(1),length(buffi),szPh(3),'single');
    
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
    
    sz=size(Ca);
    %Catmp=zeros(sz(1),sz(2),1,sz(4),'single');
    Catmp=zeros(sz(1),sz(2),1,1,'single');
    Cptmp=Catmp; Ctstmp=Catmp;
    %Cztmp=zeros(sz(1),sz(2),1,sz(4),'single');
    for cnd_i=1:ncnd
        
        %ind1 = Trials{cnd_i};
        ind1 = 1:size(trialdata,2);
        
        Catmp(:,:,1,cnd_i)=mean( Cch1(:,:,ind1) ,3);
        %Cztmp(:,:,1,cnd_i)=mean( Czch1(:,:,ind1) ,3);
        %[Cptmp(:,:,1,cnd_i), Ctstmp(:,:,1,cnd_i)] = ttest_local(Cch1(:,:,ind1),C_bs_tmp');
    end
    Ca(:,:,ch1_i,:)=Catmp; clear Catmp
    %n.([pID, '_Cz'])(:,:,ch1_i,:)=Cztmp; clear Cztmp
    %Cp(:,:,ch1_i,:)=Cptmp; clear Ctmp
    %Cts(:,:,ch1_i,:)=Ctstmp; clear Ctstmp
    clear Cch1 Czch1
    clc
    %fprintf(sprintf('Subject: %s (%d/%d) \n Channel: %d/%d\nTime elapsed: %.2f min\n',pinfo(sbj_i).pID,sbj_i,max(s1),ch1_i,size(ch1,1),toc/60));
    
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
