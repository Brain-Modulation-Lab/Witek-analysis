function [ h ] = plot_miSPL_noz( LFP_SPL, fq, name, FontSize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

h=figure;
k=1; hh=[];
Ncontacts = length(LFP_SPL);
for i=1:Ncontacts
h1(i)=subplot(1,Ncontacts,i);
imagesc((1:1001)/1000-0.5, fq, LFP_SPL(i).mi'); set(gca,'FontSize',FontSize); set(gca,'YDir','normal'); hold on; plot([0 0], ylim, ':', 'Color', 'w'); title(['MI ', name, ' LFP', num2str(Ncontacts), ' Contact ', num2str(i)]);
% h2(i)=subplot(3,Ncontacts,i+Ncontacts);
% imagesc((1:1001)/1000-0.5, fq, LFP_SPL(i).zmi'); set(gca,'FontSize',FontSize); set(gca,'YDir','normal'); hold on; plot([0 0], ylim, ':', 'Color', 'w'); title(['ZMI ', name, ' LFP', num2str(Ncontacts), ' Contact ', num2str(i)]);
% h3(i)=subplot(3,Ncontacts,i+2*Ncontacts);
% imagesc((1:1001)/1000-0.5, fq, LFP_SPL(i).pmi'); set(gca,'FontSize',FontSize); set(gca,'YDir','normal'); hold on; plot([0 0], ylim, ':', 'Color', 'w'); title(['PMI ', name, ' LFP', num2str(Ncontacts), ' Contact ', num2str(i)]);
end
CommonCaxis1 = caxis((h1(1)));
% CommonCaxis2 = caxis((h2(1)));
% CommonCaxis3 = caxis((h3(1)));
for i=1:Ncontacts
thisCaxis1 = caxis((h1(i)));
% thisCaxis2 = caxis((h2(i)));
% thisCaxis3 = caxis((h3(i)));
CommonCaxis1(1) = min(CommonCaxis1(1), thisCaxis1(1));
CommonCaxis1(2) = max(CommonCaxis1(2), thisCaxis1(2));
% CommonCaxis2(1) = min(CommonCaxis2(1), thisCaxis2(1));
% CommonCaxis2(2) = max(CommonCaxis2(2), thisCaxis2(2));
% CommonCaxis3(1) = min(CommonCaxis3(1), thisCaxis3(1));
% CommonCaxis3(2) = max(CommonCaxis3(2), thisCaxis3(2));
end
for i=1:Ncontacts
caxis(h1(i), CommonCaxis1);
% caxis(h2(i), CommonCaxis2);
% caxis(h3(i), CommonCaxis3);
end
end

