function [LL, mean_latency, success_rate, numspike] = stim_analysis(filename, DD, sf, pre, post, epoch_num, artifact)

epoch = sf*(pre+post)/1000; %convert ms to samples

%find the number of spikes in each epoch
for(j=1:epoch_num) 
    numspike(j) = length(find(DD(:,j)~=0)); 
end



%find the response latency of first spike in each epoch
% 10/28/03 -- add (-1) term to latency calculation
for(j=1:epoch_num)
    if(numspike(j)~=0)
        LL(j) = sf*artifact/1000 + min(find(DD(:,j)~=0)) - 1;
    else
        LL(j) = 0;
    end
end

if nnz(LL)>0
    mean_latency = 1000*mean(LL(find(LL~=0)))/sf;
else
    mean_latency = 0;
end
success_rate = length(find(LL~=0))/epoch_num;

% [LLhist, to] = hist(LL(find(LL~=0)), ceil(max(LL(find(LL~=0)))-min(LL(find(LL~=0)))) );
% figure
% plot(1000*to/sf,LLhist)
% xlabel('latency (ms)');
% ylabel('cts/bin');
% title(filename);

disp(['Mean latency: ', num2str(mean_latency), ' ms']);
disp(['Success rate: ', num2str(100*success_rate), ' %']);