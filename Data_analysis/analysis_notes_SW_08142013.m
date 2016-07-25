

[time1kHz, Force, AnalogElectrodeIDs] = GetAnalogData('datafile0003.ns2', [10241]);

[EventTimes] = GetEventData('datafile0003.nev');

[time, AnalogData, AnalogElectrodeIDs] = GetAnalogData('datafile0003.ns5', channels);

for i=1:32
AnalogData1kHz(:,i) = downsample(AnalogData(:,i), 30);
end

[GoBlockTime, ForceGoBlock, TrialNum] = MotivationTaskGoBlock(Force, EventTimes, UnilateralMotivationTaskSW7, 2.5, 2.5, 1000);

figure; plot(GoBlockTime, mean(ForceGoBlock.Win100,2), 'Color', 'green');
hold on; plot(GoBlockTime, mean(ForceGoBlock.Win10,2), 'Color', 'yellow');
hold on; plot(GoBlockTime, mean(ForceGoBlock.Lose10,2), 'Color', 'magenta');
hold on; plot(GoBlockTime, mean(ForceGoBlock.Lose100,2), 'Color', 'red');
hold on; plot(GoBlockTime, mean(ForceGoBlock.Squeeze,2), 'Color', 'blue');
hold on; plot(GoBlockTime, mean(ForceGoBlock.Rest,2), 'Color', 'black');
hold on; plot([0 0], ylim, 'LineStyle', ':');

h=figure;
for i =1:4
for j=1:8
subplot('Position',[(8-j)/8 (i-1)/4 1/8 1/4]);
thischannel = j+(i-1)*8;
disp(thischannel);
[~,thisGoBlock, ~] = MotivationTaskGoBlock(AnalogData1kHz(:,thischannel), EventTimes, UnilateralMotivationTaskSW7, 2.5, 2.5, 1000, params);
[S_30_120.S_GoRest_Grid{thischannel},S_30_120.t,S_30_120.f,~]=mtspecgramc(thisGoBlock.Rest,movingwin,params);
plot_matrix_WJL([S_30_120.S_GoRest_Grid{thischannel}],S_30_120.t-2.5,S_30_120.f,'invf');
hold on; plot([0 0], ylim, 'LineStyle', ':', 'Color', 'white')
thislabel = num2str(channels(thischannel));
text(mean(xlim),mean(ylim),thislabel,'FontSize',10,'HorizontalAlignment','center','Color','white')
end
end

%% Equal Power Color Scheme:

MaxPower = 0;
for i=1:32
thisS = [S_30_120.S_GoAll_Grid{i}];
for j = 1:size(thisS,1)
        temp(j,:) = S_30_120.f.*thisS(j,:);
    end
MaxPower = max([MaxPower, max(max(temp))])
end
for i =1:4
for j=1:8
subplot('Position',[(8-j)/8 (i-1)/4 1/8 1/4]);
thischannel = j+(i-1)*8;
disp(thischannel);
[~,thisGoBlock, ~] = MotivationTaskGoBlock(AnalogData1kHz(:,thischannel), EventTimes, UnilateralMotivationTaskSW7, 2.5, 2.5, 1000, params);

plot_matrix_WJL([S_30_120.S_GoAll_Grid{thischannel}],S_30_120.t-2.5,S_30_120.f,'invf',[],[0 MaxPower]);
hold on; plot(GoBlockTime, 0.25*mean(thisGoBlock.All,2)+40, 'Color', 'white')
hold on; plot([0 0], ylim, 'LineStyle', ':', 'Color', 'white')
thislabel = num2str(channels(thischannel));
text(mean(xlim),mean(ylim),thislabel,'FontSize',10,'HorizontalAlignment','center','Color','white')
end
end