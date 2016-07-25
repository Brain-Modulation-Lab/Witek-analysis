function [VV, i, epoch_num, epoch_length] = footshock(V, sf, filename, epoch_length)

i = find_stim(V(:,2), 1000);
i(1)
[VV, i, epoch_num, epoch_length] = align_stim(V(:,1), sf, i, epoch_length);
