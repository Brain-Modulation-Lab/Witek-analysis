function final=param_cluster_sig(varargin)
% Input
% data : data to be evaluated for significance
% sd : matrix of surrogate distribution var x var x surrogates
% alpha : alpha level for significance default 0.99 range [0 1]
% surr_thresh : threshold to evaluate the surrogate distributions
% range from [0 1] default is 0.95
% sig_method : method used to find biggest significant cluster,
% 1 = pixel size   2 = sum of pixel ranks, default = 2
% Output
% final


alpha=2.5;
surr_thresh=0.95;
sig_method=2;
switch nargin
    case 2
        data=varargin{1,1};
        sd=varargin{1,2};
    case 3
        data=varargin{1,1};
        sd=varargin{1,2};
        alpha=varargin{1,3};
    case 4
        data=varargin{1,1};
        sd=varargin{1,2};
        alpha=varargin{1,3};
        surr_thresh=varargin{1,4};
    case 5
        data=varargin{1,1};
        sd=varargin{1,2};
        alpha=varargin{1,3};
        surr_thresh=varargin{1,4};
        sig_method=varargin{1,5}
end


thresh=zscore(sd,0,3);

% threshholding the surrogate distributions
thresh(thresh<alpha)=zeros(length(thresh(thresh<alpha)),1);

% find the significant cluster sizes in each surrogate plot
sigclu=[];
sizclu=[];
for s=1:size(thresh,3)
    L=thresh(:,:,s);
    if sum(L(:))~=0
    L=segment_clusters(L);
    CC = bwconncomp(L);
    if CC.NumObjects ~= 0   
    for c=1:CC.NumObjects  
        t1(c)=sum(L(CC.PixelIdxList{1,c}));
        t2(c)=length(L(CC.PixelIdxList{1,c}));
    end
sigclu=[sigclu t1];
sizclu=[sizclu t2];
    end
    end
    t1=[];
    t2=[];
end

%select method for picking significant clusters
switch sig_method
    case 1
        method=sizclu;
    case 2
        method=sigclu;
end
%threshold data to alpha
data(data<alpha)=zeros(length(data(data<alpha)),1);
data=segment_clusters(data);
out= bwconncomp(data);
%Correct clusters for significance
final=zeros(size(data));
for cl=1:length(out.NumObjects)
    if sum(data(out.PixelIdxList{1,cl}))>quantile(method,0.95);
        final(out.PixelIdxList{1,cl})=data(out.PixelIdxList{1,cl});
    
    end
end


end