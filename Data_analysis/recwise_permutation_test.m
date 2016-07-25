niter = 100000;
nsubjects = 27;
ncond = 4*2;
A = repmat((0:(ncond-1)),nsubjects,1);
A = nsubjects*A(:);

Fperm = [];
multcmp_diff_perm = [];

for iter=1:niter
reorder = A+repmat(randperm(nsubjects)',ncond,1);

% [~,this_tbl,~] = anovan(DATAstats(reorder,1), ...
%     {DATAstats(:,3), DATAstats(:,4), DATAstats(:,5), DATAstats(:,6)}, 'model', 'interaction', 'display', 'off');

[~,this_tbl,stats] = anovan(DATAstats(reorder,1), ...
    {DATAstats(:,3), DATAstats(:,4)}, 'model', 'interaction', 'display', 'off');

c = multcompare(stats,'Dimension',[1 2], 'display', 'off');

Fperm = cat(2,Fperm,cell2mat(this_tbl(2:4,6)));
multcmp_diff_perm = cat(2,multcmp_diff_perm,c(:,4));

end