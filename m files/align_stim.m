function [VV, epoch_num, epoch_length] = align_stim(V, sf, i, epoch_length)

epoch_num = length(i);
%i = i(1:epoch_num);
for(j=1:epoch_num) 
    VV(:,j) = V(i(j):(i(j)+epoch_length*sf)); 
end