function [p, pos, neg, pos_fp, neg_fp] = test_independence(LL, epoch_num, exact)

pos=zeros(0); 
neg=zeros(0); 
k=1; l=1;
for j=1:epoch_num-1
    if LL(j)==0
        neg(k) = LL(j+1); 
        k=k+1;
    else
        pos(l) = LL(j+1); 
        l=l+1;
    end
end

pos_fp = nnz(pos)/length(pos)
neg_fp = nnz(neg)/length(neg)

if (nargin == 2)
    exact = '';
end
   
if strcmp(exact, 'exact')
    p = fishers(nnz(pos), length(pos), nnz(neg), length(neg))    
else
    p = chisqtestind(nnz(pos), length(pos), nnz(neg), length(neg))
end