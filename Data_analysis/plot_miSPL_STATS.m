function [ h, STATSLFP_SPL ] = plot_miSPL_STATS( LFP_SPL, fs, fq, field, name, FontSize, time_range, fq_range, prespike, postspike)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

h=figure;

prespike = round(prespike*fs);
postspike = round(postspike*fs);

STATSLFP_SPL = [];

Ncontacts = length(LFP_SPL);
for i=1:Ncontacts
    
    h1(i)=subplot(2,Ncontacts,i);
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq, LFP_SPL(i).(field)'); set(gca,'FontSize',FontSize); set(gca,'YDir','normal'); hold on; plot([0 0], ylim, ':', 'Color', 'w'); title([field, ' ', name, ' LFP', num2str(Ncontacts), ' Contact ', num2str(i)]);
    hold on; plot(time_range(1)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
    hold on; plot(time_range(2)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
    hold on; plot(time_range, fq_range(1)*[1 1], 'Color', 'w', 'LineWidth', 2);
    hold on; plot(time_range, fq_range(2)*[1 1], 'Color', 'w', 'LineWidth', 2);

    STATSLFP_SPL(i).selected = reshape(LFP_SPL(i).(field)(round(fs*((prespike+postspike)/(2*fs)+time_range(1))):round(fs*((prespike+postspike)/(2*fs)+time_range(2))), find(fq==fq_range(1)):find(fq==fq_range(2))), 1, []);
    STATSLFP_SPL(i).selected(isnan(STATSLFP_SPL(i).selected)) = [];
    STATSLFP_SPL(i).mean = mean(STATSLFP_SPL(i).selected);
    STATSLFP_SPL(i).std = std(STATSLFP_SPL(i).selected);
    
end
CommonCaxis1 = caxis((h1(1)));

for i=1:Ncontacts
    thisCaxis1 = caxis((h1(i)));
    
    CommonCaxis1(1) = min(CommonCaxis1(1), thisCaxis1(1));
    CommonCaxis1(2) = max(CommonCaxis1(2), thisCaxis1(2));
end
for i=1:Ncontacts
    caxis(h1(i), CommonCaxis1);
end

subplot(2,Ncontacts,Ncontacts+(1:Ncontacts));
errorbar([STATSLFP_SPL(:).mean], [STATSLFP_SPL(:).std], 'k', 'LineWidth', 2);
ylabel('mean z-score');

bon=0.05/(numel(STATSLFP_SPL(1).selected));
thresh=icdf('normal',1-bon,0,1);

hold on; plot(xlim, thresh*[1 1], '-', 'LineWidth', 2)
ylim1 = ylim;
if ylim1(2)<(thresh+1)
    ylim([ylim1(1) thresh+1]);
end

end

