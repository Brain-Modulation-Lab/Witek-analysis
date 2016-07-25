%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   GET ANALOG INPUT DATA ===> CH 10241
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ns_RESULT, hFile] = ns_OpenFile('datafile0004.ns5');
find(hFile.Entity{:}.ElectrodeID==10241)
find(struct2cell(hFile.Entity{:}.ElectrodeID)==10241)
hFile.Entity{:}.ElectrodeID
hFile.Entity.ElectrodeID
find(struct2cell(hFile.Entity.ElectrodeID)==10241)
find([hFile.Entity.ElectrodeID]==10241)
hFile.Entity{190}.ElectrodeID
hFile.Entity{190}
hFile.Entity(190)
plot_analog(hFile, 190)
[ns_RESULT, countList, data] = ns_GetAnalogData(hFile, 190, 1, hFile.Entity(190).Count);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   GET GO BLOCKS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:31
ForceGoBlock(:,i) = Force(floor(1000*(time_stamps(7+5*(i-1))-1)):floor(1000*(time_stamps(7+5*(i-1))+2.5)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SEPARATE OUT GO BLOCKS BY TRIAL TYPE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iwin100=0;
iwin10=0;
ilose10=0;
ilose100=0;
isqueeze=0;
irest=0;
for i = 1:31
    switch UnilateralMotivationTaskSW1{i,4}
        case 'WIN $100'
            iwin100=iwin100+1; ForceGoBlockWin100(:,iwin100) = ForceGoBlock(:,i);
        case 'WIN $10'
            iwin10=iwin10+1; ForceGoBlockWin10(:,iwin10) = ForceGoBlock(:,i);
        case 'LOSE $10'
            ilose10=ilose10+1; ForceGoBlockLose10(:,ilose10) = ForceGoBlock(:,i);
        case 'LOSE $100'
            ilose100=ilose100+1; ForceGoBlockLose100(:,ilose100) = ForceGoBlock(:,i);
        case 'SQUEEZE'
            isqueeze=isqueeze+1; ForceGoBlockSqueeze(:,isqueeze) = ForceGoBlock(:,i);
        case 'REST'
            irest=irest+1; ForceGoBlockRest(:,irest) = ForceGoBlock(:,i);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   PLOT MEAN RESPONSES 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure; plot((1:length(ForceGoBlock))/1000 - 1, mean(ForceGoBlockWin100,2), 'Color', 'green');
hold on; plot((1:length(ForceGoBlock))/1000 - 1, mean(ForceGoBlockWin10,2), 'Color', 'yellow');
hold on; plot((1:length(ForceGoBlock))/1000 - 1, mean(ForceGoBlockLose10,2), 'Color', 'magenta');
hold on; plot((1:length(ForceGoBlock))/1000 - 1, mean(ForceGoBlockLose100,2), 'Color', 'red');
hold on; plot((1:length(ForceGoBlock))/1000 - 1, mean(ForceGoBlockSqueeze,2), 'Color', 'blue');
hold on; plot((1:length(ForceGoBlock))/1000 - 1, mean(ForceGoBlockRest,2), 'Color', 'black');
hold on; plot([0 0], ylim, 'LineStyle', ':');