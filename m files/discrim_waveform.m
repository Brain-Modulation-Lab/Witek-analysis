function [D, rejected, accepted] = discrim_waveform(V, D, sf, tpost, thresh)
% work in progress 12/15/05/04

l=1; 
m=1;
rejected=[];
accepted=[];

temp=find(D~=0);
for(k=1:length(temp))
    if (min(V((temp(k)-20):(temp(k)+20)))<-700) %(V(temp(k)+tpost)<thresh) %(V(temp(k)+tpost)<thresh)  %   ((temp(k)+sf*tpost/1000)>length(V)) ||    %  (min(V((temp(k)-30):(temp(k))))<-200)  %        %    
        disp([num2str(temp(k)), ': rejected.']);
        D(temp(k))=0;
        %rejected(:,l)=V(temp(k)-20:(temp(k)+30)); l=l+1;
    else
        %disp([num2str(temp(k)), ': accepted.']);
        %accepted(:,m)=V(temp(k)-20:(temp(k)+30)); m=m+1;
    end
end
