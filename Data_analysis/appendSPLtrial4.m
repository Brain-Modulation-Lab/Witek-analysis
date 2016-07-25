dat_files = dir('*.mat');

MinGripTime = 0.5;
MaxGripTime = 3.0;
BaseFactor = 0.2;

PreT = 1.0;
PostT = 1.0;

for i=1:length(dat_files)
    tic
    filename=dat_files(i).name;
    S = load(filename);
    SPLtrial = [];
    SPLtrial4 = [];
    
    fprintf('%s...', filename)
    
    Psychometrics(i).RecID = S.RecID;
    
    %left side
    for trial=1:length(S.QLeftResponseTimesC)
        idx = find(S.EventTimes < S.QLeftResponseTimesC(trial)/S.fs,1,'last');
        if idx>3
            SPLtrial.Left(trial).epoch(1) = S.EventTimes(idx-3);
        else
            SPLtrial.Left(trial).epoch(1) = [];
        end
        if idx>2
            SPLtrial.Left(trial).epoch(2) = S.EventTimes(idx - 2);
        else
            SPLtrial.Left(trial).epoch(2) = [];
        end
        if idx>1
            SPLtrial.Left(trial).epoch(3) = S.EventTimes(idx - 1);
        else
            SPLtrial.Left(trial).epoch(3) = [];
        end
        SPLtrial.Left(trial).epoch(4) = S.EventTimes(idx);
        SPLtrial.Left(trial).epoch(5) = S.QLeftResponseTimesC(trial)/S.fs;
        [Fmax, ~] = max(S.Force(round(S.QLeftResponseTimesC(trial)):round(S.QLeftResponseTimesC(trial)+MaxGripTime*S.fs),1));
        SPLtrial.Left(trial).epoch(6) = S.QLeftResponseTimesC(trial)/S.fs + ...
            find(S.Force(round(S.QLeftResponseTimesC(trial)+MinGripTime*S.fs):round(S.QLeftResponseTimesC(trial)+MaxGripTime*S.fs),1)-BaseFactor*Fmax ...
                <=S.Force(round(S.QLeftResponseTimesC(trial)),1),1,'first')/S.fs + MinGripTime;
        idx = find(S.EventTimes > S.QLeftResponseTimesC(trial)/S.fs,1,'first');
        if idx<=length(S.EventTimes)
            SPLtrial.Left(trial).epoch(7) = S.EventTimes(idx);
        else
            SPLtrial.Left(trial).epoch(7) = [];
        end
        if idx<length(S.EventTimes)
            SPLtrial.Left(trial).epoch(8) = S.EventTimes(idx+1);
        else
            SPLtrial.Left(trial).epoch(8) = [];
        end
        %left psychometrics
        Psychometrics(i).Left(trial).RT = SPLtrial.Left(trial).epoch(5)-SPLtrial.Left(trial).epoch(4);
        [Fmax, Fmax_idx] = max(S.Force(round(S.QLeftResponseTimesC(trial)):round(SPLtrial.Left(trial).epoch(6)*S.fs),1));
        Psychometrics(i).Left(trial).Fmax = Fmax - S.Force(round(S.QLeftResponseTimesC(trial)),1);
        Psychometrics(i).Left(trial).TTP = Fmax_idx/S.fs;
        Psychometrics(i).Left(trial).GripTime = SPLtrial.Left(trial).epoch(6)-SPLtrial.Left(trial).epoch(5);
    end
    for trial=1:length(S.QLeftResponseTimes)
        SPLtrial4.Left(trial).epoch(1) = S.QLeftResponseTimes(trial)/S.fs - 2*PreT;
        SPLtrial4.Left(trial).epoch(2) = S.QLeftResponseTimes(trial)/S.fs - PreT;
        SPLtrial4.Left(trial).epoch(3) = S.QLeftResponseTimes(trial)/S.fs;
        [Fmax, ~] = max(S.Force(round(S.QLeftResponseTimes(trial)):round(S.QLeftResponseTimes(trial)+MaxGripTime*S.fs),1));
        SPLtrial4.Left(trial).epoch(4) = S.QLeftResponseTimes(trial)/S.fs + ...
            find(S.Force(round(S.QLeftResponseTimes(trial)+MinGripTime*S.fs):round(S.QLeftResponseTimes(trial)+MaxGripTime*S.fs),1)-BaseFactor*Fmax ...
                <=S.Force(round(S.QLeftResponseTimes(trial)),1),1,'first')/S.fs + MinGripTime;
        SPLtrial4.Left(trial).epoch(5) = SPLtrial4.Left(trial).epoch(4) + PostT;
        SPLtrial4.Left(trial).epoch(6) = SPLtrial4.Left(trial).epoch(4) + PostT;
    end
    
    %right side
    for trial=1:length(S.QRightResponseTimesC)
        idx = find(S.EventTimes < S.QRightResponseTimesC(trial)/S.fs,1,'last');
        if idx>3
            SPLtrial.Right(trial).epoch(1) = S.EventTimes(idx-3);
        else
            SPLtrial.Right(trial).epoch(1) = [];
        end
        if idx>2
            SPLtrial.Right(trial).epoch(2) = S.EventTimes(idx - 2);
        else
            SPLtrial.Right(trial).epoch(2) = [];
        end
        if idx>1
            SPLtrial.Right(trial).epoch(3) = S.EventTimes(idx - 1);
        else
            SPLtrial.Right(trial).epoch(3) = [];
        end
        SPLtrial.Right(trial).epoch(4) = S.EventTimes(idx);
        SPLtrial.Right(trial).epoch(5) = S.QRightResponseTimesC(trial)/S.fs;
        [Fmax, ~] = max(S.Force(round(S.QRightResponseTimesC(trial)):round(S.QRightResponseTimesC(trial)+MaxGripTime*S.fs),2));
        SPLtrial.Right(trial).epoch(6) = S.QRightResponseTimesC(trial)/S.fs + ...
            find(S.Force(round(S.QRightResponseTimesC(trial)+MinGripTime*S.fs):round(S.QRightResponseTimesC(trial)+MaxGripTime*S.fs),2)-BaseFactor*Fmax ...
                <=S.Force(round(S.QRightResponseTimesC(trial)),2),1,'first')/S.fs + MinGripTime;
        idx = find(S.EventTimes > S.QRightResponseTimesC(trial)/S.fs,1,'first');
        if idx<=length(S.EventTimes)
            SPLtrial.Right(trial).epoch(7) = S.EventTimes(idx);
        else
            SPLtrial.Right(trial).epoch(7) = [];
        end
        if idx<length(S.EventTimes)
            SPLtrial.Right(trial).epoch(8) = S.EventTimes(idx+1);
        else
            SPLtrial.Right(trial).epoch(8) = [];
        end
        %right psychometrics
        Psychometrics(i).Right(trial).RT = SPLtrial.Right(trial).epoch(5)-SPLtrial.Right(trial).epoch(4);
        [Fmax, Fmax_idx] = max(S.Force(round(S.QRightResponseTimesC(trial)):round(SPLtrial.Right(trial).epoch(6)*S.fs),2));
        Psychometrics(i).Right(trial).Fmax = Fmax - S.Force(round(S.QRightResponseTimesC(trial)),2);
        Psychometrics(i).Right(trial).TTP = Fmax_idx/S.fs;
        Psychometrics(i).Right(trial).GripTime = SPLtrial.Right(trial).epoch(6)-SPLtrial.Right(trial).epoch(5);
    end
    for trial=1:length(S.QRightResponseTimes)
        SPLtrial4.Right(trial).epoch(1) = S.QRightResponseTimes(trial)/S.fs - 2*PreT;
        SPLtrial4.Right(trial).epoch(2) = S.QRightResponseTimes(trial)/S.fs - PreT;
        SPLtrial4.Right(trial).epoch(3) = S.QRightResponseTimes(trial)/S.fs;
        [Fmax, ~] = max(S.Force(round(S.QRightResponseTimes(trial)):round(S.QRightResponseTimes(trial)+MaxGripTime*S.fs),2));
        SPLtrial4.Right(trial).epoch(4) = S.QRightResponseTimes(trial)/S.fs + ...
            find(S.Force(round(S.QRightResponseTimes(trial)+MinGripTime*S.fs):round(S.QRightResponseTimes(trial)+MaxGripTime*S.fs),2)-BaseFactor*Fmax ...
                <=S.Force(round(S.QRightResponseTimes(trial)),2),1,'first')/S.fs + MinGripTime;
        SPLtrial4.Right(trial).epoch(5) = SPLtrial4.Right(trial).epoch(4) + PostT;
        SPLtrial4.Right(trial).epoch(6) = SPLtrial4.Right(trial).epoch(4) + 2*PostT;
    end
    
    save(S.RecID, 'SPLtrial', 'SPLtrial4', '-append');
    
    fprintf('done...\n')
end

for s=1:length(Psychometrics)
    RTL(s) = mean([Psychometrics(s).Left(:).RT]);
    RTR(s) = mean([Psychometrics(s).Right(:).RT]);
    [RT_diff(s,1), RT_diff(s,2)] = ttest2([Psychometrics(s).Left(:).RT],[Psychometrics(s).Right(:).RT]);
    
    FmaxL(s) = mean([Psychometrics(s).Left(:).Fmax]);
    FmaxR(s) = mean([Psychometrics(s).Right(:).Fmax]);
    [Fmax_diff(s,1), Fmax_diff(s,2)] = ttest2([Psychometrics(s).Left(:).Fmax],[Psychometrics(s).Right(:).Fmax]);
    
    TTPL(s) = mean([Psychometrics(s).Left(:).TTP]);
    TTPR(s) = mean([Psychometrics(s).Right(:).TTP]);
    [TTP_diff(s,1), TTP_diff(s,2)] = ttest2([Psychometrics(s).Left(:).TTP],[Psychometrics(s).Right(:).TTP]);
    
    GripTimeL(s) = mean([Psychometrics(s).Left(:).GripTime]);
    GripTimeR(s) = mean([Psychometrics(s).Right(:).GripTime]);
    [GripTime_diff(s,1), GripTime_diff(s,2)] = ttest2([Psychometrics(s).Left(:).GripTime],[Psychometrics(s).Right(:).GripTime]);
end

PsychData{1,1} = 'RTL';
PsychData{1,2} = RTL;
PsychData{2,1} = 'RTR';
PsychData{2,2} = RTR;
PsychData{3,1} = 'FmaxL';
PsychData{3,2} = FmaxL;
PsychData{4,1} = 'FmaxR';
PsychData{4,2} = FmaxR;
PsychData{5,1} = 'TTPL';
PsychData{5,2} = TTPL;
PsychData{6,1} = 'TTPR';
PsychData{6,2} = TTPR;
PsychData{7,1} = 'GripTimeL';
PsychData{7,2} = GripTimeL;
PsychData{8,1} = 'GripTimeR';
PsychData{8,2} = GripTimeR;