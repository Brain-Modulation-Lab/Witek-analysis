function [R, z]=cluster_sig(input,surr,stat)
critz=norminv(1-stat.voxel_pval);
msurr=mean(surr,3);
stdsurr=std(surr,0,3);
surrclusz=zeros(stat.surrn,1);
parfor s=1:size(surr,3)
    surrz=bsxfun(@rdivide, bsxfun(@minus,surr(:,:,s),msurr),stdsurr);
    Psurrclus=bwconncomp(bsxfun(@times,surrz,(surrz>=critz)));
    if Psurrclus.NumObjects~=0
        Parea=cellfun(@(x) sum(surrz(x)),Psurrclus.PixelIdxList);
        Pmax=max(Parea);
    else Pmax=0;
    end
    Nsurrclus=bwconncomp(bsxfun(@times,surrz,(surrz<=-critz)));
    if Nsurrclus.NumObjects~=0
        Narea=abs(cellfun(@(x) sum(surrz(x)),Nsurrclus.PixelIdxList));
        Nmax=max(Narea);
    else Nmax=0;
    end
    surrclusz(s)=max([Nmax Pmax]);
    
end
surrclusz=sort(surrclusz,'ascend');

critclusterz=surrclusz(round((1-stat.cluster_pval)*length(surrclusz)));

% z=bsxfun(@rdivide, bsxfun(@minus,squeeze(input),msurr),stdsurr);
z=input;
R.corrz=zeros(size(z));
CCP= bwconncomp(bsxfun(@times,z,(z>=critz)));
if CCP.NumObjects~=0
    clust_infoP =cellfun(@(x) sum(z(x)), CCP.PixelIdxList);
    Psigc=find(clust_infoP>=critclusterz);
    Psigp=arrayfun(@(x) sum(surrclusz>x)/stat.surrn,clust_infoP(Psigc));
    Pidx=vertcat(CCP.PixelIdxList{Psigc});
else
    Psigp=[];
    Pidx=[];
    Psigc=[];
end

CCN= bwconncomp(bsxfun(@times,z,(z<=-critz)));

if CCN.NumObjects~=0
    clust_infoN =cellfun(@(x) abs(sum(z(x))), CCN.PixelIdxList);
    Nsigc=find(clust_infoN>=critclusterz);
    Nsigp=arrayfun(@(x) sum(surrclusz>x)/stat.surrn,clust_infoN(Nsigc));
    Nidx=vertcat(CCN.PixelIdxList{Nsigc});
else
    Nsigp=[];
    Nidx=[];
    Nsigc=[];
    
end
R.sigz=[Psigc Nsigc];
R.sigp=[Psigp Nsigp];
idx=vertcat(Pidx,Nidx);
R.corrz(idx)=z(idx);
R.critclusterz = critclusterz;
