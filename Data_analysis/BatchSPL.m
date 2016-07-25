function STATStimecourse = BatchTimecourseSTATS(time_range, fq_range)

dat_files = dir('*.mat');
fq=1:1:40;
nbin=30;

prespike = 0.5;
postspike = 0.5;

for i=1:length(dat_files)

    filename=dat_files(i).name;
    
    S = load(Rec(i).Filename, LFPtimecourse);
    
     for contact = 1:length(S.LFPtimecourse)
        
         for time = 1:10
             STATStimecourse(i,contact, time).L.selected = reshape(S.LFPtimecourse(contact).SPL_LR(time).zmi(round(fs*(prespike/fs+time_range(1))):round(fs*(prespike/fs+time_range(2))), find(fq==fq_range(1)):find(fq==fq_range(2))), 1, []);
             STATStimecourse(i,contact, time).L.mean = mean(STATStimecourse(i,contact, time).L.selected);
             STATStimecourse(i,contact, time).L.std = std(STATStimecourse(i,contact, time).L.selected);
             
             STATStimecourse(i,contact, time).R.selected = reshape(S.LFPtimecourse(contact).SPL_RR(time).zmi(round(fs*(prespike/fs+time_range(1))):round(fs*(prespike/fs+time_range(2))), find(fq==fq_range(1)):find(fq==fq_range(2))), 1, []);
             STATStimecourse(i,contact, time).R.mean = mean(STATStimecourse(i,contact, time).R.selected);
             STATStimecourse(i,contact, time).R.std = std(STATStimecourse(i,contact, time).R.selected);
         end
     end
     
     figure; hold on;
     for contact = 1:length(S.LFPtimecourse)
         errorbar((1:10)/2-2.5, squeeze([STATStimecourse(i,contact, :).L.mean]), squeeze([STATStimecourse(i,contact, :).L.std]));
     end
     title([])
     
     figure; hold on;
     for contact = 1:length(S.LFPtimecourse)
         errorbar((1:10)/2-2.5, squeeze([STATStimecourse(i,contact, :).R.mean]), squeeze([STATStimecourse(i,contact, :).R.std]));
     end
     
     fprintf('%s read successfully...\n', S.RecID);
    
    save([S.RecID, '_SPL'], 'SPL');
    clear('SPL');
    
    vars=fieldnames(S);
    for i = 1:length(vars)
        clear(vars{i})
    end
    
end

end