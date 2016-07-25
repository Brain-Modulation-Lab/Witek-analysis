function [DD, rejected, accepted] = stim_discrim_waveform(VV, DD, pre, artifact, epoch_num)
% work in progress 03/22/04

l=1; 
m=1;

accepted=[];
rejected=[];

to = 10*(pre+artifact); %t-naught in samples @ 10 kHz sampling rate

for(j=1:epoch_num)
    temp=find(DD(:,j)~=0);
    for(k=1:length(temp))
        if(VV(to+temp(k)+7,j)>-300)
            disp([num2str(j), ': rejected.']);
            DD(temp(k),j)=0;
            %rejected(:,l)=VV(to+temp(k)-20:(to+temp(k)+20),j); l=l+1;
        else
            %disp([num2str(j), ': accepted.']);
            %accepted(:,m)=VV(to+temp(k)-20:(to+temp(k)+20),j); m=m+1;
        end
    end
end