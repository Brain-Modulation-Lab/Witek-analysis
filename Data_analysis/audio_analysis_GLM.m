%%% Lmatrix %%%
% Lglm = L;
% for s=1:length(Lglm)
%     idx = find(strcmp(Lglm{s,1}, Lmatrix(1,:)));
%     if Lmatrix{34,idx}==1
%         Lglm{s,3} = 1;
%     else
%         Lglm{s,3} = 0;
%     end
%     for feature=2:7
%         if Lmatrix{feature,idx}==1
%             Lglm{s,2+feature} = 1;
%         else
%             Lglm{s,2+feature} = 0;
%         end
%     end
% end
% for s=1:length(Lglm)
% Lglm{s,2}=s;
% end
%%%
 
%%% Lmatrix2 %%%
Lglm = L(:,1);
for s=1:length(Lglm)
    idx = find(strcmp(Lglm{s,1}, Lmatrix2(:,1)));
    Lglm{s,2} = s;
    Lglm(s,3:11) = Lmatrix2(idx,5:13);
end

NNbin = NNbina;

clear NNbinZ
baseT = 1; %sec
for trial=1:TrialNum
    baseEvent = SkipEvents + 4*trial -2;
    baseN = bin(D((round(30000*EventTimes(baseEvent))+1):...
        round(30000*(EventTimes(baseEvent)+baseT))),floor(baseT/binsize));
    NNbinZ(:,trial) = (NNbin(:,trial)-mean(baseN))/std(baseN);
end

NNbin = NNbina;

clear NNbinZ
baseT = [-1 1]; %sec
for trial=1:TrialNum
    baseEvent = SkipEvents + 4*trial -2;
    baseN = bin(D((round(30000*EventTimes(baseEvent))+baseT(1)+1):...
        round(30000*(EventTimes(baseEvent)+baseT(2)))),floor((baseT(2)-baseT(1))/binsize));
    NNbinZ(:,trial) = (NNbin(:,trial)-mean(baseN))/std(baseN);
end


Y = NNbinZ';
[n,d] = size(Y);

clear Xcell;
 
Xmat = [ones(n,1) cell2mat(Lglm(:,[2:11]))];
%Xmat = [ones(n,1) cell2mat(Lglm(:,2:4)) AudioAmp];

Xcell = cell(1,n);
for i = 1:n
    Xcell{i} = [kron([Xmat(i,:)],eye(d))];
end
 
[beta,sigma,E,V] = mvregress(Xcell,Y,'covtype','diagonal');
 
B = reshape(beta,d,size(Xmat,2))';
 
mean((Xmat*B).^2)/mean(Y.^2)
%%%
     
clear p;
clear H;
ndim = size(Xmat,2);
for b=1:ndim
    H = zeros(1,ndim); 
    H(b) = 1; % test against null hypothesis beta(b) = 1
    for t=1:d
        p(t,b) = linhyptest(beta(d*(0:ndim-1)+t),V(d*(0:ndim-1)+t,d*(0:ndim-1)+t),0,H);
    end
end
 
figure;
for b=1:ndim
    %subplot(ndim,1,b); 
    ax=subplot('Position',[0,(ndim-b)/ndim,1,1/ndim]);
    plot(B(b,:)', 'color', [0.85 .85 .85]);
    if b~=1
        ylim([-4 4])
    end
    xlim([0.5 d+0.5])
    %title(['beta ', num2str(b-1)]);
    hold on; plot([d d]/2, ylim, 'k')
    ax.XTick = [];
    ax.YTick = [];

    psig = find(p(:,b)<0.05); 
    psigadj = find(psig(2:end)-psig(1:end-1)==1);
    hold on; plot(psig, B(b,psig)', 'r.')
    for i=1:length(psigadj)
        hold on; plot([psig(psigadj(i)) psig(psigadj(i))+1], B(b,[psig(psigadj(i)) psig(psigadj(i))+1])', 'r')
    end
end

%% determine independence of features
RHO = corr(Xmat);
figure;
for i=1:ndim
    for j=1:i
        subplot(ndim,ndim, ndim*(i-1)+j);
        text(0, 0, num2str(RHO(i,j))); axis off;
    end
end
