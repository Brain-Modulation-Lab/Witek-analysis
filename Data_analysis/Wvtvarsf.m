function [amp, ph] = Wvtvarsf(data,fs,fq,buff)

buff=buff/2;
fct=[1,30; 30,1300];
sigma_f=[2;6]; %standard deviation in Hz for wavelet

Yztotal=[]; amp=[]; ph=[];
for i=1:numel(sigma_f)
    fq1=fq(fq>=fct(i,1)); fq1=fq1(fq1<fct(i,2));
    
    if ~isempty(fq1)
        sigma_f1=sigma_f(i);
        
        Y=wavtransform_wjl(fq1,data,fs,sigma_f1,1);
        Y1=abs(Y(:,buff*fs+1:size(Y,2)-buff*fs,:));
        Y2=angle(Y(:,buff*fs+1:size(Y,2)-buff*fs,:));
        
        amp=[amp;Y1];
        ph=[ph;Y2];
    end
end

function Y=wavtransform_wjl(fq,TS,sr,sigma_f,dim)
% Usage:
%              Y=wavtransform(fq,TS,sr,width,dim)
%It returns the morlet wavelet transform of 'TS' computed at frequencies 'fq'.
%TS is a timeseries or a matrix of timeseries sampled at rate 'sr'.
%'width'defines the mother wavelet, if set to 0 cwt is run [0].

if ~nargin
    help wavtransform
else
    if ~exist('dim','var')||isempty(dim)
        [ntp nts]=size(TS);
        if nts>ntp
            TS=TS';
            [ntp nts]=size(TS);
        end
    else
        if dim~=1
            TS=TS';
        end
        [ntp nts]=size(TS);
    end
    if ~exist('width','var')||isempty(width)
        width=0;
    end
    
    %load all Mother Wavelets
    if any(sigma_f~=0)
        dt = 1/sr;
        MW=cell(numel(sigma_f),numel(fq));
        for nw=1:numel(sigma_f)
            for nf=1:numel(fq)
                sigma_f1=sigma_f(nw);
                w=fq(nf)/sigma_f1;
                st = 1/(2*pi*sigma_f1);
                t=-(w/2)*st:dt:(w/2)*st;
                MW(nw,nf) = {morwav(fq(nf),t,w,sigma_f1,st)};
            end
        end
    end

    scales=sr./fq;
    
    Y=zeros(numel(fq),ntp,nts,numel(width));

    for nw=1:numel(width)
        if width(nw)==0
            for N=1:nts
                Y(:,:,N,nw) = cwt(TS(:,N),scales,'cmor1-1');
            end
            
        else
            for N=1:nts
                for nf=1:numel(fq)
                    Y(nf,:,N,nw) = conv(TS(:,N),MW{nw,nf}','same');
                end
            end
        end
    end
end



function y = morwav(f,t,width,sf,st)
% sf = f/width;
% st = 1/(2*pi*sf);
A = 1/sqrt((st*sqrt(pi)));
y = A*exp(-t.^2/(2*st^2)).*exp(1i*2*pi*f.*t);


