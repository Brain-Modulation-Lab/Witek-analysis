function check_trials(V, ts, Events, Duration, sf, binsize, filename)

D = zeros(size(V));
 D(round(30000*ts))=1;

DurationSamples = sf*min(Duration);

for i = 1:length(Events)
    DD(:,i) = D(round(sf*Events(i)):(round(sf*(Events(i)))+DurationSamples));
end

NN = DD;
NN(NN~=0)=1;

for i=1:size(NN,2)
    NNbin(:,i) = bin(NN(:,i), [], round(sf*binsize));
    NNbin_cumav(i) = mean(mean(NNbin));
end

nblock=10;
for i=(nblock):size(NN,2)
    %NNbin_lin(:,i) = polyfit((i-nblock+1):i, mean(NNbin(:,(i-nblock+1):i),1), 1);
    NNbin_lin(:,i) = polyfit(1:i, mean(NNbin(:,1:i),1), 1);
    NNbin_runav(i) = mean(mean(NNbin(:,(i-nblock+1):i)));
end

h=figure;

plot(mean(NNbin,1)/mean(mean(NNbin)), 'o');
%hold on; plot(NNbin_runav/mean(mean(NNbin)), 'x');
hold on; plot(NNbin_cumav/mean(mean(NNbin)), 'x');
% hold on; plot(NNbin_lin(1,:), '.');
%thresh = nblock*ones(1,size(NN,2)).*NNbin_lin(1,:)./NNbin_runav;
thresh = (1:size(NN,2)).*NNbin_lin(1,:)./NNbin_cumav;
hold on; plot(nblock:size(NN,2), thresh(nblock:end));
badtrial = find(abs(thresh) > 0.5);
if ~isempty(find(badtrial>nblock))
    %hold on; plot(badtrial(find(badtrial>10))'*[1 1], ylim, 'k');
    hold on; plot(badtrial'*[1 1], ylim, 'k');
end
hold on; plot(xlim, (mean(mean(NNbin,1))-std(NNbin(:)))*[1 1]/mean(mean(NNbin)), 'r');
hold on; plot(xlim, (mean(mean(NNbin,1))+std(NNbin(:)))*[1 1]/mean(mean(NNbin)), 'r');
title(filename);
xlabel('trial');
ylabel('spikes / bin');









 

