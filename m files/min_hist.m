function HH = min_hist(VV, sf, epoch_num, filename)

HH = find_min2D(VV, sf, epoch_num);
peakhist(reshape(HH, [], 1), filename);