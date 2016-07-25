function [LFPlpds, Force, LRStimulusChannel, RRStimulusChannel, HDR] = ns2edf( inputfilename, outputfilename, channels, labels, tstart, tend, LRStimulusTimes, RRStimulusTimes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[~, LFPlpds, ~] = GetAnalogData_FIR_ds([inputfilename,'.ns5'], 30000, channels, tstart, tend, 500, 30);

[~, Force, ~] = GetAnalogData([inputfilename,'.ns2'], 1000, 10241:10242, tstart, tend);

RRStimulusChannel = zeros(length(Force),1);
LRStimulusChannel = zeros(length(Force),1);
RRStimulusChannel(RRStimulusTimes)=1;
LRStimulusChannel(LRStimulusTimes)=1;

EEGdata = [LFPlpds, Force, LRStimulusChannel, RRStimulusChannel];

DateTime = [2015 1 1 00 00 00];
HDR = writeeeg([outputfilename,'.edf'], EEGdata' , 1000, 'TYPE', 'EDF', 'T0', DateTime, 'Label', labels, 'Patient.id', outputfilename);

end

