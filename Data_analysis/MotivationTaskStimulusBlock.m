function [StimulusTimes, StimulusDuration, Trial, TrialNum] = MotivationTaskStimulusBlock(EventTimes, SkipEvents, EventsPerTrial, Event, TaskDataLog)

TrialNum = floor((length(EventTimes)-SkipEvents)/EventsPerTrial);

%StimulusBlockTime = -pre:(1/sf):post;

for i = 1:TrialNum
    thisEvent = SkipEvents+Event+EventsPerTrial*(i-1);
    StimulusTimes(i) = EventTimes(thisEvent);
    if thisEvent<length(EventTimes)
        StimulusDuration(i) = EventTimes(thisEvent+1)-EventTimes(thisEvent);
    end
end

% find left and right trials
Trial.Left = find([TaskDataLog{:,4}]==1);
Trial.Right = find([TaskDataLog{:,4}]==2);

% find trials with different cue types
Trial.Win = find(strcmp(TaskDataLog(:,5),'WIN $10'));
Trial.Lose = find(strcmp(TaskDataLog(:,5),'LOSE $10'));
Trial.Squeeze = find(strcmp(TaskDataLog(:,5),'*'));

% find go and nogo trials
Trial.Go = find([TaskDataLog{:,11}]==1);
Trial.NoGo = find([TaskDataLog{:,11}]==2);

% find correct and error trials
Trial.Correct = find([TaskDataLog{:,12}]==1);
Trial.Error = find([TaskDataLog{:,12}]==0);
