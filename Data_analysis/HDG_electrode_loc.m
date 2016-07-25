l3 = gs_HDG;
for i= 1:length(gs_HDG)
v8(i) = dot(gs_HDG(i,:)-HDG(1,:),norm2);
end
l3(find(v8>2.5e2),:)=[];
hold on; plot3(l3(:,1),l3(:,2),l3(:,3),'m.', 'MarkerSize', 25)
s3=cscvn(l3');
hold on; fnplt(s3, 'g', 2)
temp=fnval(s3, linspace(s3.breaks(1),s3.breaks(end),100))';
pts3 = SubCurve( temp, 8 )
hold on; plot3(pts2(:,1), pts2(:,2), pts2(:,3), 'b.', 'MarkerSize', 25)

l4 = gs_HDG;
for i= 1:length(gs_HDG)
v9(i) = dot(gs_HDG(i,:)-HDG(2,:),norm4);
end
l4(find(v9>2.5e2),:)=[];
hold on; plot3(l4(:,1),l4(:,2),l4(:,3),'m.', 'MarkerSize', 25)
s4=cscvn(l4');
hold on; fnplt(s4, 'g', 2)
temp=fnval(s4, linspace(s4.breaks(1),s4.breaks(end),100))';
pts4 = SubCurve( temp, 8 )
hold on; plot3(pts4(:,1), pts4(:,2), pts4(:,3), 'b.', 'MarkerSize', 25)

HDGpts = [];
nrows = size(pts3,1);
pts30 = pts3; pts30(:,3)=zeros(nrows,1);

for row=1:nrows
    
    norm = cross(pts3(row,:)-pts4(row,:), pts3(row,:)-pts30(row,:));
    
    for i= 1:length(gs_HDG)
        v(i) = dot(gs_HDG(i,:)-pts3(row,:),norm);
    end
    
    l = gs_HDG;
    l(find( abs(v)>2.5e2),:)=[];
    l = [pts4(row,:); l; pts3(row,:)];
    
    s=cscvn(l');
    temp=fnval(s, linspace(s.breaks(1),s.breaks(end),100))';
    HDGpts = cat(1, HDGpts, SubCurve( temp, nrows ));
    
end