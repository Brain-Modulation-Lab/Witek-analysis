function [DD, threshold] = stim_threshold(HH, epoch_num, threshold, polarity)

for(j=1:epoch_num) 
    DD(:,j) = discriminate(HH(:,j), threshold, polarity); 
end
