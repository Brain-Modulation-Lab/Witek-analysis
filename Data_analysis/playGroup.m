function [ player ] = playGroup( AudioTrials, AudioStart, G )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

fs = 30000;
iti = 0.2;
dur = 0.8;
A = [];

for trial=1:length(G)
A = [A; AudioTrials{G(trial)}(AudioStart{G(trial)}:min([AudioStart{G(trial)}+dur*fs end])); zeros(iti*fs,1)];
end

player = audioplayer(A, 30000); play(player);
