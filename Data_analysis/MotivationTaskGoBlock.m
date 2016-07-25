function [GoBlockTime, GoBlock, TrialNum] = MotivationTaskGoBlock(Data, EventTimes, TaskDataLog, pre, post, sf, params)

FirstEvent = 8;

TrialNum = (length(EventTimes)-4)/5;

GoBlockTime = -pre:(1/sf):post;

for i = 1:TrialNum
    %GoBlock.All(:,i) = Data((floor(sf*EventTimes(FirstEvent+5*(i-1)))-pre*sf):(floor(sf*EventTimes(FirstEvent+5*(i-1)))+post*sf));
    GoBlock.All(:,i) = rmlinesc(Data((floor(sf*EventTimes(FirstEvent+5*(i-1)))-pre*sf):(floor(sf*EventTimes(FirstEvent+5*(i-1)))+post*sf)),params,[],'n',60);
end

iwin100=0;
iwin10=0;
ilose10=0;
ilose100=0;
isqueeze=0;
irest=0;
for i = 1:TrialNum
    switch TaskDataLog{i,4}
        case 'WIN $100'
            iwin100=iwin100+1; GoBlock.Win100(:,iwin100) = GoBlock.All(:,i);
        case 'WIN $10'
            iwin10=iwin10+1; GoBlock.Win10(:,iwin10) = GoBlock.All(:,i);
        case 'LOSE $10'
            ilose10=ilose10+1; GoBlock.Lose10(:,ilose10) = GoBlock.All(:,i);
        case 'LOSE $100'
            ilose100=ilose100+1; GoBlock.Lose100(:,ilose100) = GoBlock.All(:,i);
        case 'SQUEEZE'
            isqueeze=isqueeze+1; GoBlock.Squeeze(:,isqueeze) = GoBlock.All(:,i);
        case 'REST'
            irest=irest+1; GoBlock.Rest(:,irest) = GoBlock.All(:,i);
    end
end