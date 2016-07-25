binsize = 0.1; %secs
nbin = size(NNbinZ,1);
pre = 2; %secs
groups = {Group1, Group2};

clear Nbin Nbinsterr;
for G=1:length(groups)
    Nbin(:,G) = mean(NNbinZ(:,groups{G}),2);
    Nbinsterr(:,G) = std(NNbinZ(:,groups{G}),0,2)/sqrt(size(NNbinZ(:,groups{G}),2));
end


h=figure; %ax=subplot('Position', [.05,.6,1-.1,.4]);
hold on
colors = {'-b.','-r.'};
t = binsize*((1:nbin)-0.5)-pre;
for G=1:length(groups)
%     errorbar(t, Nbin(:,G), Nbinsterr(:,G));
    shadedErrorBar(t,Nbin(:,G),Nbinsterr(:,G),...
       {colors{G}, 'MarkerSize', 12},1);
    XLim = xlim;
    YLim = ylim;
%       plot(0); xlim(XLim); ylim(YLim)
ylim([-1.5 3.1])
xlim([-2.5 2.5])
end
% axis off
% ax.XTick = [];
% ax.YTick = [];


%NNbinsub = NNbin(6:20,:);
% factor=11;
% articulator = repmat([Lglm{:,factor}],25,1);
% time = repmat((1:25)'-12.5,1,120);
% [p,tbl,stats] = anovan(NNbinZ(:), {articulator(:), time(:)}, 'model', 'interaction');
% mc = multcompare(stats, 'dimension', [1 2],'ctype', 'lsd');
% clear mc_p
% for i=1:nbin
%     idx1=2*i-1;
%     idx2=2*i;
%     mc_p(i,1) = mc(find(mc(:,1)==idx1 & mc(:,2)==idx2),6);
%     mc_p(i,2) = mc_p(i,1)<0.05;
% end

% factors = {'trial', 'word/nonword', 'early/late', ...
% 'C1 lips/tongue', 'C1 voiced', ...
% 'V1 (i:)', 'V2 (a e o u i)', 'V3 (u:)', ...
% 'C2 lips/tongue', 'C2 voiced'};

% for i=3:11
%     TrialGroup1 = find([Lglm{:,i}]==1);
%     TrialGroup2 = find([Lglm{:,i}]==0);
%     compare_groups
%     title(['Factor',factors{i-1}])
%     set(gca, 'FontSize', 20)
%     saveas(gcf, ['figures/shadedrasterF',num2str(i),'.pdf'], 'pdf')
% end