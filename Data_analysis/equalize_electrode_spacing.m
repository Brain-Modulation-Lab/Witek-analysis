% check contact spacing
for i=1:(length(CortElecLoc)-1)
    fprintf('Dist %d-%d: %4.2f\n', i, i+1, pdist2(CortElecLoc{i}, CortElecLoc{i+1}));
end

figure; plot3(mask_indices(:,1), mask_indices(:,2), mask_indices(:,3), 'g.')
axis equal
camlight('headlight','infinite');
% use brush tool to select a segment of the hull --> l
l0 = l;
figure; plot3(l(:,1), l(:,2), l(:,3), 'g.')
axis equal
camlight('headlight','infinite');

elec = reshape(cell2mat(CortElecLoc0),3,length(CortElecLoc0))';
hold on; plot3(elec(:,1), elec(:,2), elec(:,3), 'r.', 'MarkerSize', 25)

pos1=get(gca,'CurrentPoint');
hold on; plot3(pos1(:,1), pos1(:,2), pos1(:,3), 'm');

norm = cross(pos1(2,:)-elec(1,:), pos1(2,:)-elec(end,:));

clear v
for i= 1:length(l)
    v(i) = dot(l(i,:)-pos1(2,:),norm);
end

hull_res = 2.5e2;
%hull_res = 3e2;
l(find( abs(v)>hull_res),:)=[];
s=cscvn(l');
hold on; fnplt(s, 'm', 2)

brk=1;
while ~(isequal(fnval(s, s.breaks(brk)), elec(1,:)') || ...
        isequal(fnval(s, s.breaks(brk)), elec(end,:)'))
brk = brk+1;
end
brk1 = brk; 
brk = brk+1;
while ~(isequal(fnval(s, s.breaks(brk)), elec(1,:)') || ...
        isequal(fnval(s, s.breaks(brk)), elec(end,:)'))
brk = brk+1;
end
brk2 = brk;

elec_line=fnval(s, linspace(s.breaks(brk1),s.breaks(brk2),400))';

elec_num = size(elec,1);
ElecEq = SubCurve( elec_line, elec_num );
hold on; plot3(ElecEq(:,1), ElecEq(:,2), ElecEq(:,3), 'b.', 'MarkerSize', 25)

CortElecLoc = mat2cell(ElecEq, ones(elec_num,1), 3)';
% check if electrode contact order got switched; if so, reverse order 
if isequal(CortElecLoc0{1}, CortElecLoc{end})
    CortElecLoc = CortElecLoc{elec_num:-1:1};
end
