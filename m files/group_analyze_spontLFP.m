function LTP_LFPanalysis = group_analyz_spontLFP(LFPdata)


% general params
sf = 10000;
stimf = 0.1;
encoding = 'int16';
scale_factor = 10000/(2^16-1);
channel_num = 1;
skip = 517; 
pre = 20;
post = 500;
tbase = 19.5;
tstart = 5;
tstop = 20;

for j = 1:length(LFPdata)
    
    
    % ------- DEBUG -------
    disp(['loading ', LFPdata{j,1}, '...']);
    
    year = ['20', LFPdata{j,2}(5:6)];
    
    [base_j, test_j] = analyzeLTP_LFP([year, '/', LFPdata{j,2}, ' MAT', '/', LFPdata{j,2}, LFPdata{j,3}], {[year, '/', LFPdata{j,2}, ' MAT', '/', LFPdata{j,2}, LFPdata{j,4}]}, tbase, tstart, tstop, 0, 1, sf, stimf, pre, '');
    
%     if (length(base_j.min)>=180 & length(test_j.min)>=540)
%         figure; plot((1:180)/6-30, base_j.min(1:180)/mean(base_j.min(1:180)), '.')
%         hold on; plot((1:540)/6, test_j.min(1:540)/mean(base_j.min(1:180)), '.')
%         title([LFPdata{j,1}, ' - ', LFPdata{j,2}])
%         
%         figure; 
%         plot((1:length(mean(base_j.VV,2)))/10-20, mean(base_j.VV,2));
%         hold on;
%         plot((1:length(mean(test_j(1).VV,2)))/10-20, mean(test_j(1).VV,2), 'color', 'red');
%         xlim([-5 80])
%         title([LFPdata{j,1}, ' - ', LFPdata{j,2}])
%     end
    
    LTP_LFPanalysis(j).label = LFPdata{j,1};

    
    % ------- DEBUG -------
    %disp('>>>>>>>>>>>>>>here');
end




