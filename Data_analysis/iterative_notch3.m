function [DataOut notched]=iterative_notch3(data,sr,thresh,minfq,maxfq)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%iterative_notch: 
%   (1) local frequency structure (5Hz-wide windows) of FFT is scanned to 
%       detect outliers in power
%   (2) when an outlier is detected, the function scans up and down the FFT
%       until the power falls below a pre-determined threshold and thus 
%       defines the window size to be removed
%   (3) identified frequency windows are filtered out with an ideal notch
%       filter
%
%   %%% required inputs %%%
%   data:   accepts 2D matrix of electrodes and time in any orientation
%   sr:     sampling rate of data
%
%   %%% optional inputs %%%
%   thresh: vector input (in units of std dev) defining criteria for peak
%           detection - default=[2,1]
%               i.e. [threshold defining peaks, lower limit defining window
%                       size]
%   minfq:  frequency (in Hz) at which to start scanning the FFT for
%           outliers - default=40
%   maxfq:  frequency (in Hz) at which to stop scanning the FFT for
%           outliers - default=(sr/2)
%
%   %%% outputs %%%
%   DataOut: electrode by time matrix that has been notche filtered
%   notched: structure that contains the frequency borders of each notch
%               filter that was appliead on a per electrode basis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialize parameters if not otherwise specified
if exist('thresh')==0
    thresh=[2,1];
end
if exist('minfq')==0
    minfq=40;
end
if exist('maxfq')==0
    maxfq=sr/2;
end

%ensure data is oriented as electrodes*time
data=squeeze(data); 
[r c]=size(data);
if r>c
    data=data';
end

res=sr/size(data,2);
time=1/sr:1/sr:size(data,2)*(1/sr);

%loop through electrodes one by one
for e=1:size(data,1)
    
amp=abs(fft(data(e,:))); %FFT
amp=amp(1:floor(end/2));

%find bad frequencies
halfw=floor(2.5/res);
bcnt=1;
for nf=minfq:2:(maxfq-2.5)   %scan through frequencies of the total FFT
    fpnt=floor(nf/res)+1;
    z=zscore(log(amp(fpnt-halfw:fpnt+halfw)));
    if any(smooth(z,round(0.05/res))>thresh(1)) && max(z)~=z(1) ...
            && max(z)~=z(end)
    for npnt=1:length(z)
        if z(npnt)==max(z)
            badf(bcnt)=(fpnt-halfw+npnt)*res;
            bcnt=bcnt+1;
            break
        end
    end
    end
end
badf=unique(badf)

%notch filter
nrm=1;
for nbad=1:length(badf)
if amp(floor(badf(nbad)/res)+1)>1
    fpnt=floor(badf(nbad)/res)+1;
    z=smooth(zscore(log(amp(fpnt-halfw:fpnt+halfw))),round(0.1/res));
    for npnt=halfw:length(z)%find upper frequency border
        if z(npnt)<thresh(2)
            up=(fpnt-halfw+npnt)*res;
            break
        end
    end
    for npnt=halfw:-1:1%find lower frequency border
        if z(npnt)<thresh(2)
            down=(fpnt-halfw+npnt)*res;
            break
        end
    end
    
    if down~=up
        eval(['notched.e' num2str(e) '(nrm,1:2)=[down,up];']);
        nrm=nrm+1;
        %apply notch filter
        ts=timeseries(data(e,:),time);
        ts=idealfilter(ts,[down up],'notch');
        fts=squeeze(ts.data);
        fts=fts';
        data(e,:)=fts;
    end

end
end

fprintf('Completed electrode #%d of %d\n',e,size(data,1))

end

DataOut=data;