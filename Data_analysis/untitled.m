for i=1:length(timecourse)
h = plot_timecourse2( timecourse(i).SPL_LR, timecourse(i).SPL_RR, 500, phfq, 'blobplf', 0.5,0.5);
end
for i=1:length(timecourse)
h = plot_timecourse2( timecoursea(i).SPL_LR, timecoursea(i).SPL_RR, 1000, fq, timecourse(i).SPL_RR, 0.5,0.5);
end
