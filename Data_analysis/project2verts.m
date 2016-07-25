function [ e2 ] = project2verts( CortElecLoc, verts )
% projects locations in CortElecLoc to nearest vertices contained in verts
% CortElecLoc is a cell array of vertices
% verts is cell array of veriecs

% WJL adapted from EDK

e = CortElecLoc'; 

fndvert = {@(A,B) min(pdist2(A,B));...
@(A,B) B(A,:);...
@(A,B,C) find(uint16(round(pdist2(A,B)))'<C);};

[~,a]  = cellfun(fndvert{1}, e, repmat({verts}, size(e,1),1), 'uniformoutput', false );%Find Locations of vertices
e2     = cellfun(fndvert{2}, a, repmat({verts}, size(a,1),1), 'uniformoutput', false );%Project to nearest surface node

e2 = e2';
end

