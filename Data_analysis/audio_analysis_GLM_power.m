TrialNum=120;
fs=1000;
Psize = size(PowerTrials);
PowerTrialsZ = PowerTrials;
baseT = 1000;

clear ITIbase
clear PowerTrialsZ
for trial=1:TrialNum
    baseEvent = SkipEvents + 4*trial -2;
    ITIbase = squeeze( ...
        PowerLFP(round(1000*EventTimes(baseEvent)):(round(1000*EventTimes(baseEvent))+baseT),:,:));
    PowerTrialsZ(:,:,:,trial) = (PowerTrials(:,:,:,trial) - repmat(mean(ITIbase,1),Psize(1),1,1)) ./ ...
        repmat(std(ITIbase,1),Psize(1),1,1);
end

nbins = 40;
%binsize = floor(size(PowerTrials,1)/nbins);
binsize = 100;
pre = 500;

clear PowerTrialsBin;
for(i = 1:nbins)
    PowerTrialsBin(i,:,:,:) = mean(PowerTrialsZ((pre+1+(i-1)*binsize):(pre+i*binsize),:,:,:));
end

YY = squeeze(mean(PowerTrialsBin(:,findfreq(50,175,fq),:,:),2));

Y = reshape(YY, [size(YY,1)*size(YY,2) size(YY,3)])';


%Y = squeeze(YY(:,contact,:))';

[n,d] = size(Y);

clear Xcell;

Xmat = [ones(n,1) cell2mat(Lglm(:,[2:6,10:11]))];

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

nch = size(YY,2);
nt = size(YY,1);
figure;  %title(num2str(contact))
for el=1:nch
    for b=1:ndim
        thisB = B(b,(nt*(el-1)+1):(nt*el))';
        ax=subplot('Position', [(el-1)/nch, (ndim-b)/ndim, 1/nch, 1/ndim]);
        %subplot(ndim,nch,nch*(b-1)+el); 
        %subplot(ndim,1,b); 
        plot((1:nt)-nt/2,thisB, 'color', 'b');
        %title(['beta ', num2str(b-1)]);
        if b==1
            ylim([-2.5 2.5])
        else
            ylim([-1 1])
        end
        hold on; plot([0 0], ylim, 'color', [.9 .9 .9])
        ax.XTick = [];
        ax.YTick = [];
        
        psig = find(p((nt*(el-1)+1):(nt*el),b)<0.05/d);
        psigadj = find(psig(2:end)-psig(1:end-1)==1);
        hold on; plot(psig-nt/2, thisB(psig)', 'r.')
        for i=1:length(psigadj)
            hold on; plot([psig(psigadj(i)) psig(psigadj(i))+1]-nt/2, thisB([psig(psigadj(i)) psig(psigadj(i))+1]), 'r')
        end
    end
end
    
%% subsets
sb = [7];
nsb = length(sb);
sch = [9 10 11 22 23 24];
nrow = 2;
ncol = 3;
nsch = length(sch);

figure;
for el=1:nsch
    for b=1:nsb
        thisB = B(sb(b),(nt*(sch(el)-1)+1):(nt*sch(el)))';
        row = ceil(el/ncol);
        col = el - (row-1)*ncol;
        ax=subplot('Position', [(col-1)/ncol, (nrow-row)/nrow, 1/ncol, 1/nrow]);
        %subplot(ndim,nch,nch*(b-1)+el); 
        %subplot(ndim,1,b); 
        plot((1:nt)-nt/2,thisB, 'color', 'b');
        %title(['beta ', num2str(b-1)]);
        ylim([-1 1])
        hold on; plot([0 0], ylim, 'color', [.9 .9 .9])
        ax.XTick = [];
        ax.YTick = [];
        
        psig = find(p((nt*(sch(el)-1)+1):(nt*sch(el)),sb(b))<0.05/d);
        psigadj = find(psig(2:end)-psig(1:end-1)==1);
        hold on; plot(psig-nt/2, thisB(psig)', 'r.', 'markersize', 12)
        for i=1:length(psigadj)
            hold on; plot([psig(psigadj(i)) psig(psigadj(i))+1]-nt/2, thisB([psig(psigadj(i)) psig(psigadj(i))+1]), 'r')
        end
    end
end