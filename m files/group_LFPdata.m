function meanLFP = group_LFPdata(LFPdata)

meanLFPVV = [];
labels = {};

PRE = 200;
ARTIFACT =100;

for j = 1:length(LFPdata)
    
    % ------- DEBUG -------
    disp(['loading ', LFPdata{j,2}, '...']);
    
    % acquire LFP responses for stimulation for each experiment
    % workspace = load([LFPdata{j,2}, '.mat']);
    % VVj = workspace.VV; % stim matrix
    
    % open .nds file directly
    sf = 10000;
    encoding = 'int16';
    scale_factor = 10000/(2^16-1);
    channel_num = 2;
    skip = 517; 
    fid = fopen([LFPdata{j,2}, '.nds']);
    frewind(fid);
    V_raw = fread(fid, encoding);
    fclose(fid);
    Vlength = floor((length(V_raw)-skip)/channel_num);
    V = zeros(Vlength, channel_num);
    for i = 1:channel_num
        V(:,i) = scale_factor*V_raw((skip + channel_num*(1:Vlength) - channel_num + i)');
    end
    [VVj, pre, post, epoch_num] = stim(LFPdata{j,2}, V(:,1), sf, 20, 1000);
    % end of code for opening .nds file directly
    
    for(k=1:length(VVj(1,:))) 
        VVnorm(:,k) = VVj(:,k) - mean(VVj(1:195,k)); 
    end
    
    meanLFP(j).VV = mean(VVnorm, 2);
    meanLFP(j).label = LFPdata{j,1};
    
%     % find the boundary of the negative peak, [ T1, T2 ]
%     t = PRE + ARTIFACT;
%     while (meanLFP(j).VV(t) > 0) && (t < PRE + 200)
%         t = t+1;    
%         % ------- DEBUG -------
%         %disp([num2str(t), '  ', num2str(meanLFP(j).VV(t))]);
%     end
%     meanLFP(j).T1 = t;
%     while (meanLFP(j).VV(t) < 0) && (t < PRE + 300)
%         t = t+1;    
%         % ------- DEBUG -------
%         %disp([num2str(t), '  ', num2str(meanLFP(j).VV(t))]);
%     end
%     meanLFP(j).T2 = t;
    
    %meanLFP(j).area = sum(meanLFP(j).VV(meanLFP(j).T1:meanLFP(j).T2))/10000;
    
    
%     [meanLFP(j).min, indexofmin] = min(meanLFP(j).VV(meanLFP(j).T1:meanLFP(j).T2));
%     meanLFP(j).tmin = (meanLFP(j).T1 - PRE + indexofmin(1) - 1)/10;
    
    MIN_TIMEOUT = 150;
    [meanLFP(j).min, indexofmin] = min(meanLFP(j).VV((PRE+ARTIFACT):(PRE+ARTIFACT+MIN_TIMEOUT)));
    meanLFP(j).tmin = (indexofmin + ARTIFACT -1)/10;
    
    POS_ARTIFACT = 20;
    [meanLFP(j).max, indexofmax] = max(meanLFP(j).VV((PRE+POS_ARTIFACT):(PRE+indexofmin + ARTIFACT -1)));
    meanLFP(j).tmax = (indexofmax + POS_ARTIFACT -1)/10;
    
end


