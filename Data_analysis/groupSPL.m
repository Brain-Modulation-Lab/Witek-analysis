function SPLgroup = groupSPL(filenames)

dat_files = dir('*.mat');
fq=1:1:40;
k=0;

for i=1:length(filenames)
    if ~max(strcmp([filenames{i,1},'.mat'], {dat_files.name}))
        fprintf('%s.mat not found.\n', filenames{i,1})
    else
        k=k+1;
        
        S = load([filenames{i,1},'.mat']);
        contact = filenames{i,2};
        
        SPLgroup.zmi(:,:,k) = S.SPL(contact).zmi;
        
        fprintf('%s read successfully...\n', S.RecID);
        
        vars=fieldnames(S);
        for i = 1:length(vars)
            clear(vars{i})
        end
    end
end

end