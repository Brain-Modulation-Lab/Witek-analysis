function [GoBlockTime, GoBlock, TrialNum] = BilateralMotivationTaskGoBlock(Data, EventTimes, TaskDataLog, side, pre, post, sf)

FirstEvent = 47;

TrialNum = (length(EventTimes)-FirstEvent)/5;

GoBlockTime = -pre:(1/sf):post;

for i = 1:TrialNum
    GoBlock.All(:,i) = Data((floor(sf*EventTimes(FirstEvent+5*(i-1)))-pre*sf):(floor(sf*EventTimes(FirstEvent+5*(i-1)))+post*sf));
end

iwin100ipsi=0;
iwin100contra=0;
iwin10ipsi=0;
iwin10contra=0;
ilose10ipsi=0;
ilose10contra=0;
ilose100ipsi=0;
ilose100contra=0;
isqueezeipsi=0;
isqueezecontra=0;
irestipsi=0;
irestcontra=0;
for i = 1:TrialNum
    switch TaskDataLog{i,5}
        case 'WIN $100'
            if TaskDataLog{i,4} == side
                iwin100ipsi=iwin100ipsi+1; GoBlock.Win100ipsi(:,iwin100ipsi) = GoBlock.All(:,i);
            else
                iwin100contra=iwin100contra+1; GoBlock.Win100contra(:,iwin100contra) = GoBlock.All(:,i);
            end
        case 'WIN $10'
            if TaskDataLog{i,4} == side
                iwin10ipsi=iwin10ipsi+1; GoBlock.Win10ipsi(:,iwin10ipsi) = GoBlock.All(:,i);
            else
                iwin10contra=iwin10contra+1; GoBlock.Win10contra(:,iwin10contra) = GoBlock.All(:,i);
            end
        case 'LOSE $10'
            if TaskDataLog{i,4} == side
                ilose10ipsi=ilose10ipsi+1; GoBlock.Lose10ipsi(:,ilose10ipsi) = GoBlock.All(:,i);
            else
                ilose10contra=ilose10contra+1; GoBlock.Lose10contra(:,ilose10contra) = GoBlock.All(:,i);
            end
        case 'LOSE $100'
            if TaskDataLog{i,4} == side
                ilose100ipsi=ilose100ipsi+1; GoBlock.Lose100ipsi(:,ilose100ipsi) = GoBlock.All(:,i);
            else
                ilose100contra=ilose100contra+1; GoBlock.Lose100contra(:,ilose100contra) = GoBlock.All(:,i);
            end
        case 'SQUEEZE'
            if TaskDataLog{i,4} == side
                isqueezeipsi=isqueezeipsi+1; GoBlock.Squeezeipsi(:,isqueezeipsi) = GoBlock.All(:,i);
            else
                isqueezecontra=isqueezecontra+1; GoBlock.Squeezecontra(:,isqueezecontra) = GoBlock.All(:,i);
            end
        case 'REST'
            if TaskDataLog{i,4} == side
                irestipsi=irestipsi+1; GoBlock.Rest(:,irestipsi) = GoBlock.All(:,i);
            else
                irestcontra=irestcontra+1; GoBlock.Rest(:,irestcontra) = GoBlock.All(:,i);
            end
    end
end