function [DDD, thresh] = stim_varISIthreshold(HHH, epoch_num, nISI, thresh, pol)

for j=1:7
[DDD(:,:,j), threshold] = stim_threshold(HHH(:,:,j), epoch_num/nISI, thresh, pol);
end