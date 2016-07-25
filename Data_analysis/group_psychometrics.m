dat_files = dir('*.mat');

MinGripTime = 0.5;
MaxGripTime = 3.0;
BaseFactor = 0.2;

PreT = 1.0;
PostT = 1.0;

GroupPsychometrics.ipsi.RT = [];
GroupPsychometrics.ipsi.TTP = [];
GroupPsychometrics.ipsi.GripTime = [];
GroupPsychometrics.ipsi.CueT = [];
GroupPsychometrics.contra.RT = [];
GroupPsychometrics.contra.TTP = [];
GroupPsychometrics.contra.GripTime = [];
GroupPsychometrics.contra.CueT = [];

for i=1:length(dat_files)
    tic
    filename=dat_files(i).name;
    S = load(filename);
    
    fprintf('%s...\n', filename)   
    
    idx = find(strcmp(S.RecID, {Psychometrics(:).RecID}));
    
    if S.RecSide == 1
        %left side
        GroupPsychometrics.ipsi.RT = cat(1, GroupPsychometrics.ipsi.RT, Psychometrics(idx).Left(:).RT);
        GroupPsychometrics.ipsi.TTP = cat(1, GroupPsychometrics.ipsi.TTP, Psychometrics(idx).Left(:).TTP);
        GroupPsychometrics.ipsi.GripTime = cat(1, GroupPsychometrics.ipsi.GripTime, Psychometrics(idx).Left(:).GripTime);
        thisCueT = [];
        for trial=1:length(S.SPLtrial.Left)
            thisCueT = cat(1, thisCueT, S.SPLtrial.Left(trial).epoch(5) - ...
                S.SPLtrial.Left(trial).epoch(3));
        end
        GroupPsychometrics.ipsi.CueT = cat(1, GroupPsychometrics.ipsi.CueT, thisCueT);
        %right side
        GroupPsychometrics.contra.RT = cat(1, GroupPsychometrics.contra.RT, Psychometrics(idx).Right(:).RT);
        GroupPsychometrics.contra.TTP = cat(1, GroupPsychometrics.contra.TTP, Psychometrics(idx).Right(:).TTP);
        GroupPsychometrics.contra.GripTime = cat(1, GroupPsychometrics.contra.GripTime, Psychometrics(idx).Right(:).GripTime);
        thisCueT = [];
        for trial=1:length(S.SPLtrial.Right)
            thisCueT = cat(1, thisCueT, S.SPLtrial.Right(trial).epoch(5) - ...
                S.SPLtrial.Right(trial).epoch(3));
        end
        GroupPsychometrics.contra.CueT = cat(1, GroupPsychometrics.contra.CueT, thisCueT);
    else
        %left side
        GroupPsychometrics.contra.RT = cat(1, GroupPsychometrics.contra.RT, Psychometrics(idx).Left(:).RT);
        GroupPsychometrics.contra.TTP = cat(1, GroupPsychometrics.contra.TTP, Psychometrics(idx).Left(:).TTP);
        GroupPsychometrics.contra.GripTime = cat(1, GroupPsychometrics.contra.GripTime, Psychometrics(idx).Left(:).GripTime);
        thisCueT = [];
        for trial=1:length(S.SPLtrial.Left)
            thisCueT = cat(1, thisCueT, S.SPLtrial.Left(trial).epoch(5) - ...
                S.SPLtrial.Left(trial).epoch(3));
        end
        GroupPsychometrics.contra.CueT = cat(1, GroupPsychometrics.contra.CueT, thisCueT);
        %right side
        GroupPsychometrics.ipsi.RT = cat(1, GroupPsychometrics.ipsi.RT, Psychometrics(idx).Right(:).RT);
        GroupPsychometrics.ipsi.TTP = cat(1, GroupPsychometrics.ipsi.TTP, Psychometrics(idx).Right(:).TTP);
        GroupPsychometrics.ipsi.GripTime = cat(1, GroupPsychometrics.ipsi.GripTime, Psychometrics(idx).Right(:).GripTime);
        thisCueT = [];
        for trial=1:length(S.SPLtrial.Right)
            thisCueT = cat(1, thisCueT, S.SPLtrial.Right(trial).epoch(5) - ...
                S.SPLtrial.Right(trial).epoch(3));
        end
        GroupPsychometrics.ipsi.CueT = cat(1, GroupPsychometrics.ipsi.CueT, thisCueT);
    end
    
end


s = fieldnames(GroupPsychometrics.ipsi);
for fld=1:length(s)
h = figure; boxplot(GroupPsychometrics.ipsi.(s{fld})); ylim([0 5]);
title(['ipsi ', s{fld}]);
saveas(h, ['psychometrics/psychometrics_ipsi_',s{fld},'.pdf'], 'pdf');
end

s = fieldnames(GroupPsychometrics.contra);
for fld=1:length(s)
h = figure; boxplot(GroupPsychometrics.contra.(s{fld})); ylim([0 5]);
title(['contra ', s{fld}]);
saveas(h, ['psychometrics/psychometrics_contra_',s{fld},'.pdf'], 'pdf');
end

