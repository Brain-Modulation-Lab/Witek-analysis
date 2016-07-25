function [VV, i, epoch_num, epoch_length] = stim_continuous(V, sf, filename, epoch_length, i)

% i = find_stim(V(:,2), 1000);
[VV, i, epoch_num, epoch_length] = align_stim(V(:,1), sf, i, epoch_length);
