function [start, finish] = find_coherence(C, t, f, thresh)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


min_duration = 6;

CC = C(:,findfreq(4,40,f));
CC(CC>=thresh)=1;
CC(CC<thresh)=0;

zCtot = zscore(sum(CC,2));

outliers = find(zCtot>1);
non_outliers = find(zCtot<=1);

zCtot_corrected = (sum(CC,2) - mean(sum(CC(non_outliers,:),2),1))./std(sum(CC(non_outliers,:),2),1);

zthresh = 2;

start = 0;
finish = 0;
Clength = 0;
for i=1:length(zCtot_corrected)
    if zCtot_corrected(i) > zthresh
        if start == 0
            start = i-1;
        end
        Clength = Clength + 1;
    else
        if Clength >= min_duration
            finish = i;
            break;
        else
            start = 0;
            Clength = 0;
        end
    end
end

figure; plot(t, zCtot_corrected);
hold on; plot(xlim, zthresh*[1 1])
hold on; plot(t(outliers), zCtot_corrected(outliers), '*')

if finish > 0
    hold on; plot([[t(start); t(finish)]*[1 1]]', ylim, 'r')
    
    figure; plot(f(findfreq(4,40,f)), zscore(sum(CC(start:finish,:),1)));
    
    start = t(start);
    finish = t(finish);
else
    disp('Coherence epoch not found.')
end
end

