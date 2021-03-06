function [ stats ] = blob_stats_sub( data, field, dim1, dim2, range1, range2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if ~isempty(range1)
    idx_dim1 = find(dim1>=range1(1) & dim1<=range1(2));
    dim1 = dim1(idx_dim1);
else
    idx_dim1 = 1:length(dim1);
end
if ~isempty(range2)
    idx_dim2 = find(dim2>=range2(1) & dim2<=range2(2));
    dim2 = dim2(idx_dim2);
else
    idx_dim2 = 1:length(dim2);
end

datasize = size(data(1).(field)(idx_dim2,idx_dim1));
datasum = zeros(datasize);

for i=1:length(data)
    data(i).(field) = data(i).(field)(idx_dim2,idx_dim1);
    datasum = datasum + data(i).(field);
    BW=mat2gray(data(i).(field));
    CC = bwconncomp(BW);
    wc = regionprops(CC, BW, 'WeightedCentroid');
    wc = cat(1, wc.WeightedCentroid);
    if CC.NumObjects > 0
        for j=1:CC.NumObjects
            stats(i).blob(j).wcent_unit_idx = round(wc(j,:));
            stats(i).blob(j).wcent_unit(1) = dim1(stats(i).blob(j).wcent_unit_idx(1));
            stats(i).blob(j).wcent_unit(2) = dim2(stats(i).blob(j).wcent_unit_idx(2));
            L = zeros(numel(BW),1);
            L(CC.PixelIdxList{j})=1;
            stats(i).blob(j).L = reshape(L, size(BW,1), size(BW,2));
            
            blobzplf = data(i).(field).*stats(i).blob(j).L;
            
            stats(i).blob(j).TotalValue = sum(blobzplf(:));
            stats(i).blob(j).MeanValue = stats(i).blob(j).TotalValue/nnz(stats(i).blob(j).L);
            
            [stats(i).blob(j).MaxValue, idxMax] = max(blobzplf(:));
            [stats(i).blob(j).max_unit_idx(2), stats(i).blob(j).max_unit_idx(1)] = ind2sub(size(blobzplf),idxMax);
            stats(i).blob(j).max_unit(1) = dim1(stats(i).blob(j).max_unit_idx(1));
            stats(i).blob(j).max_unit(2) = dim2(stats(i).blob(j).max_unit_idx(2));
            
            idx_nzblobplf = find(blobzplf(:)>0);
            QMax = quantile(blobzplf(idx_nzblobplf),0.975);
            idxqmax = find(blobzplf(idx_nzblobplf)>QMax);
            [stats(i).blob(j).idxQMax(1,:), stats(i).blob(j).idxQMax(2,:)] = ind2sub(size(blobzplf),idx_nzblobplf(idxqmax));
            stats(i).blob(j).QMaxValue = mean(blobzplf(idx_nzblobplf(idxqmax)));
            
        end
    else
        stats(i).blob(1).wcent_unit_idx = [];
        stats(i).blob(1).wcent_unit = [];
        stats(i).blob(1).L = zeros(size(BW));
        stats(i).blob(1).TotalValue = 0;
        stats(i).blob(1).MeanValue = 0;
    end
end

end
