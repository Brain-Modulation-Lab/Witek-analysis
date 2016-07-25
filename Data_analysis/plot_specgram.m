function h = plot_specgram(Rec,movingwin,params)
%  plot chronux specgram and markers for PC+S acute stimulation experiments

[S,t,f,~]=mtspecgramc(Rec.Data(:,3),movingwin,params);
h=figure; 
plot_matrix_WJL(S,t,f,'invf', [], [0 0.0025]);
hold on; 
for i=1:length(Rec.marker)
    plot(Rec.marker(i)*[1 1], ylim, 'Color', 'w');
end

end

