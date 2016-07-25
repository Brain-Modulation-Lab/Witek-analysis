function [B]=segment_clusters(varargin)
z=varargin{1};
thresh=0.05;
% maxthresh=mean2(z)+2*std2(z);
switch nargin
    case 2
    thresh=varargin{2};
end
B=zeros(size(z));
hLocalMax = vision.LocalMaximaFinder;
release(hLocalMax);
hLocalMax.Threshold=mean2(z)+2*std2(z);
hLocalMax.NeighborhoodSize=[5 7];
hLocalMax.MaximumNumLocalMaxima=1;
loc=step(hLocalMax,z);

while ~isempty(loc)
    W = graydiffweight(mat2gray(z),loc(1),loc(2));
    BW = imsegfmm(W, loc(1), loc(2), thresh);
    B=B+BW.*z;
    BW=~BW; z=z.*BW;
    loc=step(hLocalMax,z);
    
end







end
