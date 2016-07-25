c=whos;

for v=1:length(c)
    if strcmp(c(v).class,'double')
        eval([c(v).name,'=single(',c(v).name,');']);
        fprintf('%s double -> single\n', c(v).name);
    end
end