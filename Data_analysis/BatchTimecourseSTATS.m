function STATS = BatchTimecourseSTATS(time_range, fq_range)

dat_files = dir('*.mat');
fq=1:1:40;
nbin=30;

fs=1000;
prespike = 500;
postspike = 500;

for i=1:length(dat_files)
    
    filename=dat_files(i).name;
    
    S = load(filename, 'RecID', 'LFPtimecourse');
    
    for contact = 1:length(S.LFPtimecourse)
        
        for time = 1:10
            STATS(i,contact).L(time).selected = reshape(S.LFPtimecourse(contact).SPL_LR(time).zmi(round(fs*(prespike/fs+time_range(1))):round(fs*(prespike/fs+time_range(2))), find(fq==fq_range(1)):find(fq==fq_range(2))), 1, []);
            STATS(i,contact).L(time).mean = mean(STATS(i,contact).L(time).selected);
            STATS(i,contact).L(time).std = std(STATS(i,contact).L(time).selected);
            
            STATS(i,contact).R(time).selected = reshape(S.LFPtimecourse(contact).SPL_RR(time).zmi(round(fs*(prespike/fs+time_range(1))):round(fs*(prespike/fs+time_range(2))), find(fq==fq_range(1)):find(fq==fq_range(2))), 1, []);
            STATS(i,contact).R(time).mean = mean(STATS(i,contact).R(time).selected);
            STATS(i,contact).R(time).std = std(STATS(i,contact).R(time).selected);
        end
    end
    
    figure;
    for contact = 1:length(S.LFPtimecourse)
        temp = STATS(i,contact).L;
        hold on; errorbar((1:10)/2-2.5, [temp(:).mean], [temp(:).std]);
    end
    title([S.RecID, ' LEFT']);
    
    figure;
    for contact = 1:length(S.LFPtimecourse)
        temp = STATS(i,contact).R;
        hold on; errorbar((1:10)/2-2.5, [temp(:).mean], [temp(:).std]);
    end
    title([S.RecID, ' RIGHT']);
    
    fprintf('%s read successfully...\n', S.RecID);
    
    vars=fieldnames(S);
    for i = 1:length(vars)
        clear(vars{i})
    end
    
end

end