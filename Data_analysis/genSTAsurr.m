function phSTAsurr=genSTAsurr(sph,new_tstamps,prespike,postspike,niter)

for j = 1:length(new_tstamps)
 phSTAsurr(j,:)=sph(new_tstamps(j)-prespike:new_tstamps(j)+postspike);      
   end