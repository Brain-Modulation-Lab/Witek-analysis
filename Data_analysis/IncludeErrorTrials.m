function [index_QLeftResponseTimes, index_QRightResponseTimes, index_QLeftResponseTimesC, index_QRightResponseTimesC, ...
            QCommandStimulusTimes, QCommandStimulusTimesC, QCommandStimulusTimesX, ...
            QLeftResponseTimes, QRightResponseTimes, QLeftResponseTimesC, QRightResponseTimesC, ...
            index_DoubleSqueezeL, index_DoubleSqueezeR] ...
             = IncludeErrorTrials(index_QLeftResponseTimes, index_QRightResponseTimes, ...
                                    QualityTrials, CommandStimulusTimes, QCommandStimulusTimes, Trial, TrialNum, ...
                                    LeftResponseTimes, RightResponseTimes, QLeftResponseTimes, QRightResponseTimes)

% check_trials(V, ts, CueStimulusTimes, CueStimulusDuration+CommandStimulusDuration+FeedbackStimulusDuration+ITIStimulusDuration, 30000, 0.1, 'Whole Trial')
% QualityTrials = 1:TrialNum;
% QCommandStimulusTimes = CommandStimulusTimes(intersect(QualityTrials, Trial.Correct(Trial.Correct<=TrialNum)));
% [ index_QLeftResponseTimes, ~ ] = FindMismatch( LeftResponseTimes/1000, QCommandStimulusTimes, 0.05, Tresponse );
% QLeftResponseTimes = LeftResponseTimes(index_QLeftResponseTimes);
% [ index_QRightResponseTimes, ~ ] = FindMismatch( RightResponseTimes/1000, QCommandStimulusTimes, 0.05, Tresponse );
% QRightResponseTimes = RightResponseTimes(index_QRightResponseTimes);
% qts = ts;
% qts(find(qts<(CueStimulusTimes(QualityTrials(1))-0.5))) = [];
% qts(find(qts>(ITIStimulusTimes(QualityTrials(end))+0.5))) = [];
% getQualityForceResponse


Tresponse = 2.5;

%QCommandStimulusTimes = CommandStimulusTimes(intersect(QualityTrials, Trial.Correct(Trial.Correct<=TrialNum)));
QCommandStimulusTimesC = QCommandStimulusTimes;
QCommandStimulusTimes = CommandStimulusTimes(QualityTrials);
QCommandStimulusTimesX = CommandStimulusTimes(intersect(QualityTrials, Trial.Error(Trial.Error<=TrialNum)));

index_QLeftResponseTimesC = index_QLeftResponseTimes;
index_QRightResponseTimesC = index_QRightResponseTimes;
QLeftResponseTimesC = QLeftResponseTimes;
QRightResponseTimesC = QRightResponseTimes;

[ index_QLeftResponseTimes, ~ ] = FindMismatch( LeftResponseTimes/1000, QCommandStimulusTimes, Tresponse, Tresponse );
[ index_QRightResponseTimes, ~ ] = FindMismatch( RightResponseTimes/1000, QCommandStimulusTimes, Tresponse, Tresponse );

LR = LeftResponseTimes(index_QLeftResponseTimes);
RR = RightResponseTimes(index_QRightResponseTimes);

[ index_DoubleSqueezeL, index_QLeftResponseTimes ] = FindMismatch( LR/1000, RR/1000, Tresponse, Tresponse );
[ index_DoubleSqueezeR, index_QRightResponseTimes ] = FindMismatch( RR/1000, LR/1000, Tresponse, Tresponse );

QLeftResponseTimes = LR(index_QLeftResponseTimes);
QRightResponseTimes = RR(index_QRightResponseTimes);

end




