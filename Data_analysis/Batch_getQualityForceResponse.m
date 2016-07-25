dat_files = dir('*.mat');

for i=1:length(dat_files)
    filename=dat_files(i).name;
    fprintf('%s...', filename);
    S = load(filename);
    V = S.V;
    qts = S.qts;
    QLeftResponseTimes = S.QLeftResponseTimes;
    QRightResponseTimes = S.QRightResponseTimes;
    RecID = [num2str(S.RecSide),' ',S.RecID];
    getQualityForceResponse;
    saveas(h_QLR, ['figures/',S.RecID,'_QLR'], 'pdf');
    saveas(h_QRR, ['figures/',S.RecID,'_QRR'], 'pdf');
    clear( 'V', 'QLeftResponseTimes', 'QRightResponseTimes', 'QDDLR', 'QDDRR');
    fprintf(' done.\n');
end