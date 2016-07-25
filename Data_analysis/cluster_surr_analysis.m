
fs = 500;
prespike = 250;
postspike = 250;
t = (1:(prespike+postspike+1))/fs-(prespike+postspike+2)/(2*fs);
contact=1;

stat.voxel_pval=0.05; stat.cluster_pval=0.05; stat.surrn=100; stat.bscorr=1;
clear blobzplf
for contact=1:length(timecourse_full)
    for tblock=1:length(timecourse_full(contact).SPL_LR)
        blobzplf(tblock,contact) = cluster_sig(timecourse_full(contact).SPL_LR(tblock).zplf,...
            timecourse_full(contact).SPL_LR(tblock).stats.surr, stat);
    end
end

blobstats = [];

for tblock=1:length(timecourse_full(contact).SPL_LR)
    blobstats = cat(2, blobstats, ...
        blob_stats_surr( timecourse_full(contact).SPL_LR(tblock).stats.surr, ...
        	timecourse_full(contact).SPL_LR(tblock).stats.PLFmu, ...
        	timecourse_full(contact).SPL_LR(tblock).stats.PLFsd, ...
            blobzplf(tblock,contact).critclusterz, fq, t, [], [], stat));
end

blobs = [];
for i=1:length(blobstats)
    for j=1:length(blobstats(i).blob)
        blobs = cat(1, blobs, blobstats(i).blob(j));
    end
end

wctime = @(x) arrayfun(@(y) y.wcent_unit(2), x);
wcfreq = @(x) arrayfun(@(y) y.wcent_unit(1), x);
maxtime = @(x) arrayfun(@(y) y.max_unit(2), x);
maxfreq = @(x) arrayfun(@(y) y.max_unit(1), x);
wctvn = @(x) arrayfun(@(y) y.TotalValueNorm, x);

figure; plot(wcfreq(blobs), wctvn(blobs), 'k.')

freq = maxfreq(blobs);
tvn = wctvn(blobs);
clear fqhist
for f=fq
    fqhist{:,f} = tvn(find(freq==f));
end

fqhist = NaN(max(cellfun(@(x) length(x), fqhist)), length(fq));

for f=fq
    nfq(f) = length(find(freq==f));
    fqhist(1:nfq(f),f) = tvn(find(freq==f));
    ncritz(f) = length(find(fqhist(1:nfq(f),f)>1));
end

figure; boxplot(fqhist)