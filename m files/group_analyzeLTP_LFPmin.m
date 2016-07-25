function LTP_LFPanalysis = group_analyzeLTP_LFPmin(LFPdata)


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
tstop = 15;

for j = 1:length(LFPdata)
    
    % to correct 2 ms trig offset in FC-30 to FC-41 in 1 hour BLA data only:
%     if j<=8
%         pre = 22;
%         post = 498;
%     else
%         pre = 20;
%         post = 500;
%     end
    
    
    % ------- DEBUG -------
    disp(['loading ', LFPdata{j,1}, '...']);
    
    year = ['20', LFPdata{j,2}(5:6)];
    
    %[base_j, test_j] = analyzeLTP_LFP([year, '/', LFPdata{j,2}, ' MAT', '/', LFPdata{j,2}, LFPdata{j,3}], {[year, '/', LFPdata{j,2}, ' MAT', '/', LFPdata{j,2}, LFPdata{j,4}]}, tbase, tstart, tstop, 0, 1, sf, stimf, pre, '');
    
    [base_j, test_j] = analyzeLTP_LFPmin([year, '/', LFPdata{j,2}, ' MAT', '/', LFPdata{j,2}, LFPdata{j,3}], {[year, '/', LFPdata{j,2}, ' MAT', '/', LFPdata{j,2}, LFPdata{j,4}]}, tbase, tstart, tstop, 0, 1, sf, stimf, pre);

    
    
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
    LTP_LFPanalysis(j).basefile = [LFPdata{j,2}, LFPdata{j,3}];
    LTP_LFPanalysis(j).testfile = [LFPdata{j,2}, LFPdata{j,4}];
    %LTP_LFPanalysis(j).base.min = base_j.min;
    LTP_LFPanalysis(j).base.min = base_j.min;
    %LTP_LFPanalysis(j).base.tmin = base_j.tmin;
    LTP_LFPanalysis(j).base.tmin = base_j.tmin;
    LTP_LFPanalysis(j).base.slope = base_j.slope;
    %LTP_LFPanalysis(j).base.A = base_j.A;
    %LTP_LFPanalysis(j).base.VVmean = mean(base_j.VV, 2);
    %LTP_LFPanalysis(j).test.min = test_j.min;
    LTP_LFPanalysis(j).test.min = test_j.min;
    %LTP_LFPanalysis(j).test.tmin = test_j.tmin;
    LTP_LFPanalysis(j).test.tmin = test_j.tmin;
    LTP_LFPanalysis(j).test.slope = test_j.slope;
    %LTP_LFPanalysis(j).test.A = test_j.A;
    %LTP_LFPanalysis(j).test.diff = test_j.diff;
    %LTP_LFPanalysis(j).test.VVmean = mean(test_j.VV, 2);
    LTP_LFPanalysis(j).group = LFPdata{j,5};
    
    % ------- DEBUG -------
    %disp('>>>>>>>>>>>>>>here');
end




