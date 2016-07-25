field = 'blobplf';

for i=1:length(dat_files)
    filename=dat_files(i).name;
    fprintf('%s... ', filename);
    S = load(filename);

    for t=1:4
        ipsi(t).(field) = zeros(501,37);
        contra(t).(field) = zeros(501,37);
    end

    for contact=1:length(S.timecourse)
        if S.RecSide == 1
            for t=1:4
                ipsi(t).(field) = ipsi(t).(field) + S.timecourse(contact).SPL_LR(t).(field);
                contra(t).(field) = contra(t).(field) + S.timecourse(contact).SPL_RR(t).(field);
            end
        else
            for t=1:4
                ipsi(t).(field) = ipsi(t).(field) + S.timecourse(contact).SPL_RR(t).(field);
                contra(t).(field) = contra(t).(field) + S.timecourse(contact).SPL_LR(t).(field);
            end
        end
    end
    
    id = strsplit(filename, '_t');
    id = strrep(id{1}, '_', '');
    h = plot_timecourse2( ipsi, contra, 500, fq, 'blobplf', .5, .5, id);
    saveas(h, ['figures/',id,'timecourse'],'pdf');
end