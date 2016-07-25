function [VVV, nISI] = stim_varISI(VV, sf, filename, pre, post, epoch_num, varISI)

nISI = length(varISI);
VVV=zeros(sf*(pre+post)/1000,epoch_num/nISI,nISI);

for i=1:nISI
VVV(:,:,i) = VV(:,nISI*(1:(epoch_num/nISI))-(nISI-i));
end

figure; hold on;
for j=1:7
plot(1000*((1:length(VV)))/sf - pre - varISI(j), VVV(:,:,j));
end
xlabel('seconds');
title(filename);