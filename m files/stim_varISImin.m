function [HHH, artifact] = stim_varISImin(VVV, epoch_num, nISI, varISI, sf, pre, post, filename, tmin, tmax)

for j=1:nISI
[HHH(:,:,j), artifact(j)] = stim_min(VVV(:,:,j), sf, pre+varISI(j), post-varISI(j), epoch_num/nISI, tmin, tmax);
end

peakhist(reshape(HHH, [], 1), filename);