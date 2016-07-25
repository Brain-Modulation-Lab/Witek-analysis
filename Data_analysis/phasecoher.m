function [coher]=phasecoher(ph1,ph2,window)
%coher=phasecoher(ph1,ph2,window)
%
%ph1 and ph2 are equal size vectors or 2-D matrices of phase values between
%(-pi,pi) oriented in timeXfrequency
%
%window is a time window (in sample points) used to compute coherence over,
%window can be scalar (same window length used for all frequencies) or a
%vector of length equal to the number of columns in ph# variables
%(different time window used for each frequency/column)
%
%
%TAW_080514
%modified SDK_103014 - now coherI output is imaginary coherence

%generate 'window' if not input
if ~exist('window','var')
    window=50;
end
window=ceil(window);
%size of input matrix
[~,c]=size(ph1);
%ensure 'window' is a vector
if numel(window)==1
    window=repmat(window,c,1);
end

%phase difference
ph1=ph2-ph1;
dph=ph1;

%make difference positive (0,2*pi)
i=(ph1<0);
ph1(i)=ph1(i)+(2*pi);

%create complex matrix of phase differences
comp=complex(cos(ph1),sin(ph1));
comp1=complex(cos(dph),sin(dph));

%compute coherence over time window
coher=ph1;
pli=ph1;
plv=ph1;
%coherI=ph1;
for n=1:c
    coher(:,n)=abs(smooth(comp(:,n),window(n)));
    
    %coherI(:,n)=angle(smooth(comp(:,n),window(n)));
    
    %pli(:,n)=abs( smooth( sign ( dph(:,n) ), window(n) ) );
    %a=ones(window(n),1);
    %plv(:,n)=abs(conv(comp(:,n),a,'same'));
end