SPL_path = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/SPL_ITI_PAC_clusters/';

dat_files = dir([SPL_path,'*.mat']);

for i=1:length(dat_files)
    filename=dat_files(i).name;
    
    RecID = strsplit(filename, '_SPL');
    RecID = RecID{1};
    
    fprintf('%s...\n', filename);
    load([SPL_path,filename]);
    
    clear timecourse
    for contact=1:size(R_ITI,2)
        for t=1:size(R_ITI,1)
             ITI(contact).SPL_ITI(t).corrz = R_ITI{t,contact}.corrz;
%             timecourse(contact).SPL_LR(t).corrz = R_LR{contact,t}.corrz;
%             timecourse(contact).SPL_RR(t).corrz = R_RR{contact,t}.corrz;
        end
    end
%    save([SPL_path,filename], 'timecourse', 'RecID', 'R_LR', 'R_RR');
    save([SPL_path,filename], 'ITI', 'RecID', 'R_ITI');
end