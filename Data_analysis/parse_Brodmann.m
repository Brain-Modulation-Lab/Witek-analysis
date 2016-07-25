
for timeblock=1:10
    thisBlock = find([BlobData{:,5}]==timeblock);
    regions = unique([Brodmann{thisBlock}]);
    TimeBlock(timeblock).regions = regions;
    for r = 1:length(regions)
        TimeBlock(timeblock).count = length(find([Brodmann{thisBlock}]==regions(r)));
    end
end

regions = unique([Brodmann{:}]);

for r=1:length(regions)
    temp(r,:) = strsplit(BrodmannLabels{regions(r)});
end
bilateral_regions = unique(temp(:,1));


for r=1:length(bilateral_regions)
    bilateral_regions_index{r} = find(cellfun(@(s) ~isempty(strfind(s, bilateral_regions{r})), temp(:,1)));
end


for timeblock=1:10
    TimeBlockBi(timeblock).regions = bilateral_regions;
    for r = 1:length(bilateral_regions)
        [~,idx,~] = intersect(TimeBlock(timeblock).regions, regions(bilateral_regions_index{r}));
        TimeBlockBi(timeblock).count(r) = sum(TimeBlock(timeblock).count(idx));
    end
end