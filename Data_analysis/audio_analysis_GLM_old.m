%%%
Lglm = L;
for s=1:length(Lglm)
    idx = find(strcmp(Lglm{s,1}, Lmatrix(1,:)));
    if Lmatrix{34,idx}==1
        Lglm{s,3} = 1;
    else
        Lglm{s,3} = 0;
    end
    for feature=2:7
        if Lmatrix{feature,idx}==1
            Lglm{s,2+feature} = 1;
        else
            Lglm{s,2+feature} = 0;
        end
    end
end
 
for s=1:length(Lglm)
Lglm{s,2}=s;
end
%%%
 
Y = NNbin';
[n,d] = size(Y);
 
Xmat = [ones(n,1) cell2mat(Lglm(:,2:8))];
 
 
Xcell = cell(1,n);
for i = 1:n
    Xcell{i} = [kron([Xmat(i,:)],eye(d))];
end
 
[beta,sigma,E,V] = mvregress(Xcell,Y);
 
B = reshape(beta,d,size(Xmat,2))';
 
%%%
 
for b=1:8
    H = zeros(1,size(Xmat,2)); 
    H(b) = 1; % test against null hypothesis beta(b) = 1
    for t=1:50
        p(t,b) = linhyptest(beta(50*(0:7)+t),V(50*(0:7)+1,50*(0:7)+t),c,H);
    end
end
 
figure;
for b=1:8
    subplot(8,1,b); plot(B(b,:)', 'color', [0.85 .85 .85]);
    title(['beta ', num2str(b-1)]);
    hold on; plot([25 25], ylim, 'k')
    
    psig = find(p(:,b)<0.05/50); 
    psigadj = find(psig(2:end)-psig(1:end-1)==1);
    hold on; plot(psig, B(b,psig)', 'r.')
    for i=1:length(psigadj)
        hold on; plot([psig(psigadj(i)) psig(psigadj(i))+1], B(b,[psig(psigadj(i)) psig(psigadj(i))+1])', 'r')
    end
end
