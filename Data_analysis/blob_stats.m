function [ stats ] = blob_stats( data, field, dim1, dim2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



datasum = zeros(size(data(1).(field)));
for i=1:length(data)
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
            stats(i).blob(j).TotalValue = sum(sum(data(i).(field).*stats(i).blob(j).L));
            stats(i).blob(j).MeanValue = sum(sum(data(i).(field).*stats(i).blob(j).L))/nnz(stats(i).blob(j).L);
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
