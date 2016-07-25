function [DataOut notched]=iterative_notch(data,sr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%iterative_notch: finds amplitude outliers in local frequency structure and
%   applieas an ideal notch filter specifically at these narrow-band,
%   contaminated frequenceis - frequencies from 40Hz to 0.85*(sr/2)Hz
%
%   data: accepts 2D matrix of electrodes and time in any orientation
%   sr:   sampling rate of data
%
%   DataOut: electrode by time matrix that has been notche filtered
%   notched: structure that contains the frequency borders of each notch
%               filter that was appliead on a per electrode basis
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data=squeeze(data); %ensure data is oriented as electrodes*time
[r c]=size(data);
if r>c
    data=data';
end

nyq=0.85*(sr/2); %set maximum frequency to inspect
res=sr/size(data,2); %determine frequency resolution of FFT
time=1/sr:1/sr:size(data,2)*(1/sr); %establish time vector


%loop through electrodes one by one
for e=1:size(data,1)
    
amp=abs(fft(data(e,:))); %FFT
amp=amp(1:floor(end/2));

%find bad frequencies
halfw=floor(2.5/res);
bcnt=1;
for nf=4:2:(nyq-2.5)   %scan through frequencies of the total FFT
    fpnt=floor(nf/res)+1;
    z=zscore(log(amp(fpnt-halfw:fpnt+halfw)));
    if any(smooth(z,round(0.05/res))>2.5)
    for npnt=1:length(z)
        if z(npnt)==max(z) && npnt~=1 && npnt~=length(z)
            badf(bcnt)=(fpnt-halfw+npnt)*res;
            bcnt=bcnt+1;
        end
    end
    end
end
badf=unique(badf);

fprintf('badf = ');
for i=1:length(badf)
fprintf('%3.2f\t',badf(i));
end
fprintf('\n');

%notch filter
for nbad=1:length(badf)
    namp=abs(fft(data(e,:)));
if namp(round(badf(nbad)/res)+1)>1
    fpnt=floor(badf(nbad)/res)+1;
    z=smooth(zscore(log(namp(fpnt-halfw:fpnt+halfw))),round(0.1/res));
    for npnt=halfw:length(z)%find upper frequency border
        if z(npnt)<1
            up=(fpnt-halfw+npnt)*res;
            break
        end
    end
    for npnt=halfw:-1:1%find lower frequency border
        if z(npnt)<1
            down=(fpnt-halfw+npnt)*res;
            break
        end
    end
    
    eval(['notched.e' num2str(e) '(nbad,1:2)=[down,up];']);
    %apply notch filter
    ts=timeseries(data(e,:),time);
    ts=idealfilter(ts,[down up],'notch');
    fts=squeeze(ts.data);
    fts=fts';
    data(e,:)=fts;

end
end

fprintf('Completed electrode #%d of %d\n',e,size(data,1))

end

DataOut=data;