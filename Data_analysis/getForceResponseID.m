
if(isvarname('RecID'))
    
    eval(['30000*length(ts)/length(V)']);
    for i = 1:length(LeftResponseTimes)
        eval(['DDL(:,i) = D',RecID,'(30*(LeftResponseTimes(i)-2.5*1000):30*(LeftResponseTimes(i)+2.5*1000));']);
    end
    eval(['[t, Nbin, h_LR] = raster_spikecount(DD',RecID,'L, 30000, size(DD',RecID,'L,2), 2.5, 5, 2.5, 60, ''Left Grip Responses -- ',RecID,''');']);
    for i = 1:length(RightResponseTimes)
        eval(['DD',RecID,'R(:,i) = D',RecID,'(30*(RightResponseTimes(i)-2.5*1000):30*(RightResponseTimes(i)+2.5*1000));']);
    end
    eval(['[t, Nbin, h_RR] = raster_spikecount(DD',RecID,'R, 30000, size(DD',RecID,'R,2), 2.5, 5, 2.5, 60, ''Right Grip Responses -- ',RecID,''');']);
    
    
else
    fprintf('Following variables needed: \n\tRecID\n');
end
