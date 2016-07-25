function [ stats ] = blob_stats_surr( data, mu, sd, critclusterz, dim1, dim2, range1, range2, stat)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

critz=norminv(1-stat.voxel_pval);

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

for i=1:size(data,3)
    datasurr = (data(idx_dim2,idx_dim1,i) - mu(idx_dim2,idx_dim1))./sd(idx_dim2,idx_dim1);
    BW=mat2gray(bsxfun(@times,datasurr,(datasurr>=critz)));
    CC = bwconncomp(BW);
    wc = regionprops(CC, BW, 'WeightedCentroid');
    wc = cat(1, wc.WeightedCentroid);
    if CC.NumObjects > 0
        clust_info =cellfun(@(x) sum(datasurr(x)), CC.PixelIdxList);
        %sigc=find(clust_info>=critclusterz);
        sigc=1:CC.NumObjects;
        for j=1:length(sigc)
            stats(i).blob(j).wcent_unit_idx = round(wc(sigc(j),:));
            stats(i).blob(j).wcent_unit(1) = dim1(stats(i).blob(j).wcent_unit_idx(1));
            stats(i).blob(j).wcent_unit(2) = dim2(stats(i).blob(j).wcent_unit_idx(2));
            L = zeros(numel(BW),1);
            L(CC.PixelIdxList{sigc(j)})=1;
            stats(i).blob(j).L = reshape(L, size(BW,1), size(BW,2));
            
            blobzplf = datasurr.*stats(i).blob(j).L;
            
            stats(i).blob(j).TotalValue = sum(blobzplf(:));
            
            stats(i).blob(j).TotalValueNorm = sum(blobzplf(:))/critclusterz;
            
            stats(i).blob(j).MeanValue = stats(i).blob(j).TotalValue/nnz(stats(i).blob(j).L);
            
            [stats(i).blob(j).MaxValue, idxMax] = max(blobzplf(:));
            [stats(i).blob(j).max_unit_idx(2), stats(i).blob(j).max_unit_idx(1)] = ind2sub(size(blobzplf),idxMax);
            stats(i).blob(j).max_unit(1) = dim1(stats(i).blob(j).max_unit_idx(1));
            stats(i).blob(j).max_unit(2) = dim2(stats(i).blob(j).max_unit_idx(2));
            
%             idx_nzblobplf = find(blobzplf(:)>0);
%             QMax = quantile(blobzplf(idx_nzblobplf),0.975);
%             idxqmax = find(blobzplf(idx_nzblobplf)>QMax);
%             [stats(i).blob(j).idxQMax(1,:), stats(i).blob(j).idxQMax(2,:)] = ind2sub(size(blobzplf),idx_nzblobplf(idxqmax));
%             stats(i).blob(j).QMaxValue = mean(blobzplf(idx_nzblobplf(idxqmax)));
            
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
