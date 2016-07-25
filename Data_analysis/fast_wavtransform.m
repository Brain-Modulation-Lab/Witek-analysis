function Y=fast_wavtransform(fq,TS,sr,width)
% Y=fast_wavtransform(fq,TS,sr,width)
%
%uses multiplication in the fourier domain (rather than convolution) to
%   speed compution on LARGE datasets; 
%error will occur if length of a given wavelet is longer than the input
%   signal;
%warning: since all computation is executed simultaneously for speed, this
%   function may be RAM intesive
%
%inputs:
%   fq=vector of frequency (Hz) values on which to center wavelets
%   TS=vector or 2D matrix of timeseries (assumes longer dimension is time)
%   sr=sampling rate (Hz)
%   width=vector of wavelet c-parameter for corresponding frequencies in fq
%       (if length(width)~=length(fq) then width(1) is used for all fq); 
%       note: std in frequency of a given wavelet=fq/width
%
%outputs:
%   Y=matrix of transformed data (dimension containing fq layers is in the 
%       order as in fq)
%
%TAW_051315

if ~nargin
    help fast_wavtransform
end
nfq=length(fq);
dt=1/sr;
if length(width)~=length(fq)
    width=repmat(width(1),nfq);
end
[ntp,nts]=size(TS);
if nts>ntp
    TS=TS';
    tmp=ntp; ntp=nts; nts=tmp;
end
m=complex(zeros(ntp,nfq),zeros(ntp,nfq));

for nf=1:nfq
    w=width(nf);
    sf=fq(nf)/w;
    st=1/(2*pi*sf);
    t=-3.5*st:dt:3.5*st;
    %t=-(w/2)*st:dt:(w/2)*st;
    nt=length(t);
    m(1:nt,nf)=morwav(fq(nf),t,st)';
    m(:,nf)=circshift(m(:,nf),floor((ntp-nt)*0.5));
end

Y=reshape(ifft(reshape(repmat(reshape(fft(TS),ntp,1,nts),1,nfq,1),...
    ntp,nts*nfq) .* repmat(fft(m),1,nts)),ntp,nfq,[]);
Y=[Y(ntp*0.5+1:end,:,:);Y(1:ntp*0.5,:,:)];
end

function y = morwav(f,t,st)
A = 1/sqrt(st*sqrt(pi));
y = A*exp(-t.^2/(2*st^2)).*exp(1i*2*pi*f.*t);
%y=y./sum(abs(y));
end