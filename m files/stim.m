function [VV, pre, post, epoch_num] = stim(filename, V, sf, pre, post)

epoch = sf*(pre+post)/1000; %convert ms to samples
epoch_num = floor(length(V)/epoch);

for(j=1:epoch_num) 
    VV(:,j) = V((j-1)*epoch+1:j*epoch); 
end

% figure;
% plot(1000*((1:length(VV)))/sf - pre, VV);
% xlabel('ms');
% ylabel('mV');
% title(filename);

