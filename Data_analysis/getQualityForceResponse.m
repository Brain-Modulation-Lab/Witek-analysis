
QD = zeros(size(V));
QD(round(30000*qts))=1;

for i = 1:length(QLeftResponseTimes)
    QDDLR(:,i) = QD(30*(QLeftResponseTimes(i)-2.5*1000):30*(QLeftResponseTimes(i)+2.5*1000));
end
[t, Nbin_LR, Nbin_LR_thresh, ~, h_QLR] = raster_spikecountz(QDDLR, 30000, size(QDDLR,2), 2.5, 0.1, 5, 2.5, 50, ['QLeft Grip Responses -- ',RecID]);
for i = 1:length(QRightResponseTimes)
    QDDRR(:,i) = QD(30*(QRightResponseTimes(i)-2.5*1000):30*(QRightResponseTimes(i)+2.5*1000));
end
[t, Nbin_RR, Nbin_RR_thresh, ~, h_QRR] = raster_spikecountz(QDDRR, 30000, size(QDDRR,2), 2.5, 0.1, 5, 2.5, 50, ['QRight Grip Responses -- ',RecID]);


