function [BlockTime, Block, TrialNum] = MotivationEventBlock(Data, EventTimes, FirstEvent, EventsPerTrial, TaskDataLog, pre, post, sf, params)

%FirstEvent = 8;

TrialNum = (length(EventTimes)-4)/5;

BlockTime = -pre:(1/sf):post;

for i = 1:TrialNum
    %Block.All(:,i) = Data((floor(sf*EventTimes(FirstEvent+EventsPerTrial*(i-1)))-pre*sf):(floor(sf*EventTimes(FirstEvent+EventsPerTrial*(i-1)))+post*sf));
    Block.All(:,i) = rmlinesc(Data((floor(sf*EventTimes(FirstEvent+EventsPerTrial*(i-1)))-pre*sf):(floor(sf*EventTimes(FirstEvent+EventsPerTrial*(i-1)))+post*sf)),params,[],'n',60);
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
            iwin100=iwin100+1; Block.Win100(:,iwin100) = Block.All(:,i);
        case 'WIN $10'
            iwin10=iwin10+1; Block.Win10(:,iwin10) = Block.All(:,i);
        case 'LOSE $10'
            ilose10=ilose10+1; Block.Lose10(:,ilose10) = Block.All(:,i);
        case 'LOSE $100'
            ilose100=ilose100+1; Block.Lose100(:,ilose100) = Block.All(:,i);
        case '*'
            isqueeze=isqueeze+1; Block.Squeeze(:,isqueeze) = Block.All(:,i);
        case 'REST'
            irest=irest+1; Block.Rest(:,irest) = Block.All(:,i);
    end
end