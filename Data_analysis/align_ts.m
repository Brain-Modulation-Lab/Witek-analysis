idx = 1; % NO recording index

EventTimes = sort([Rec(idx).DigUp Rec(idx).DigDown]);  % NO time stamps
[EventTimesTrellis] = GetEventData('datafileRB102815intraop0001.nev'); % trellis time stamps

% visually identify T0 / T1 in Trellis as the start / end of segment of interest
T0 = 2000;
T1 = 3000;
Event0 = TrellisEventTimes(find(TrellisEventTimes>T0,1,'first'));
tstart= Event0 - EventTimes(1);
tend = TrellisEventTimes(find(TrellisEventTimes<T0,1,'last')) + 5; % 5 secs after last time stamp