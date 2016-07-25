function [H] = Hilbert_Time_Freq (data,fs,fq,buff)

[r,c]=size(data);
if c>r
    data=data';
    r1=r; r=c; c=r1;
end

H=zeros(r,length(fq)-1,c);

for ch_i=1:c
    %datach=gpuArray(data(:,ch_i)');
    datach=data(:,ch_i)';
    parfor fq_i=1:length(fq)-1
        smoothdata = eegfilt(datach,fs,fq(fq_i),fq(fq_i+1));
        H(:,fq_i,ch_i)=hilbert(smoothdata);
    end
end

if buff~=0
    buffi=round(buff*fs):r-ceil(buff*fs)-1;
    H=H(buffi+1,:,:);
end