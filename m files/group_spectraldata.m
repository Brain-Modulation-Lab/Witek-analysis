function LFPresults = group_spectraldata(LFPdata)

labels = {};
LENGTH = 600000; % 60 second samples for spectral analysis

for j = 1:length(LFPdata)
    
    % ------- DEBUG -------
    disp(['loading ', LFPdata{j,1}, '...']);
    
    % open .nds file directly
    sf = 10000;
    encoding = 'int16';
    scale_factor = 10000/(2^16-1);
    channel_num = 2;
    skip = 517;
    
    % open PFC/BLA file
    if ~strcmp(LFPdata{j,4}, 'X')
        LFPresults(j).pb.missing = 0;
        fid = fopen([LFPdata{j,3}, '/', LFPdata{j,3}, LFPdata{j,4}, '.nds']);
        frewind(fid);
        V_raw = fread(fid, encoding);
        fclose(fid);
        Vlength = floor((length(V_raw)-skip)/channel_num);
        V = zeros(Vlength, channel_num);
        for i = 1:channel_num
            V(:,i) = scale_factor*V_raw((skip + channel_num*(1:Vlength) - channel_num + i)');
        end
        Vpfc = V(1:LENGTH,1);
        Vbla = V(1:LENGTH,2);
        % end of code for opening .nds file directly
        
        % analyze PFC/BLA data
        [Ppfc,f] = periodogram(Vpfc,[],25000,sf);
        [Pbla,f] = periodogram(Vbla,[],25000,sf);
        
        LFPresults(j).pb.Ppfc = Ppfc(max(find(f<=0.5)):max(find(f<60)));
        LFPresults(j).pb.Pbla = Pbla(max(find(f<=0.5)):max(find(f<60)));
        
        LFPresults(j).pb.totPpfc = sum(Ppfc(max(find(f<=0.5)):max(find(f<60))));
        LFPresults(j).pb.totPbla = sum(Pbla(max(find(f<=0.5)):max(find(f<60))));
        
        LFPresults(j).pb.deltaPFC = sum(Ppfc(max(find(f<=0.5)):max(find(f<4))));
        LFPresults(j).pb.thetaPFC = sum(Ppfc(max(find(f<=4)):max(find(f<8))));
        LFPresults(j).pb.alphaPFC = sum(Ppfc(max(find(f<=8)):max(find(f<12))));
        LFPresults(j).pb.betaPFC = sum(Ppfc(max(find(f<=12)):max(find(f<25))));
        LFPresults(j).pb.gammaPFC = sum(Ppfc(max(find(f<=25)):max(find(f<60))));
        
        LFPresults(j).pb.deltaBLA = sum(Pbla(max(find(f<=0.5)):max(find(f<4))));
        LFPresults(j).pb.thetaBLA = sum(Pbla(max(find(f<=4)):max(find(f<8))));
        LFPresults(j).pb.alphaBLA = sum(Pbla(max(find(f<=8)):max(find(f<12))));
        LFPresults(j).pb.betaBLA = sum(Pbla(max(find(f<=12)):max(find(f<25))));
        LFPresults(j).pb.gammaBLA = sum(Pbla(max(find(f<=25)):max(find(f<60))));
        
        [c,lags] = xcorr(Vpfc, Vbla, 10000);
        LFPresults(j).pb.xcorr = c;
        LFPresults(j).pb.lags = lags/sf;
        
    else
        LFPresults(j).pb.missing = 1;
    end
    
    % open vHPC/BLA file
    if ~strcmp(LFPdata{j,5}, 'X')
        LFPresults(j).hb.missing = 0;
        fid = fopen([LFPdata{j,3}, '/', LFPdata{j,3}, LFPdata{j,5}, '.nds']);
        frewind(fid);
        V_raw = fread(fid, encoding);
        fclose(fid);
        Vlength = floor((length(V_raw)-skip)/channel_num);
        V = zeros(Vlength, channel_num);
        for i = 1:channel_num
            V(:,i) = scale_factor*V_raw((skip + channel_num*(1:Vlength) - channel_num + i)');
        end
        Vhpc = V(1:LENGTH,1);
        Vbla = V(1:LENGTH,2);
        % end of code for opening .nds file directly
        
        % analyze vHPC/BLA data
        [Phpc,f] = periodogram(Vhpc,[],25000,sf);
        [Pbla,f] = periodogram(Vbla,[],25000,sf);
        
        LFPresults(j).hb.Phpc = Phpc(max(find(f<=0.5)):max(find(f<60)));
        LFPresults(j).hb.Pbla = Pbla(max(find(f<=0.5)):max(find(f<60)));
        
        LFPresults(j).hb.totPhpc = sum(Phpc(max(find(f<=0.5)):max(find(f<60))));
        LFPresults(j).hb.totPbla = sum(Pbla(max(find(f<=0.5)):max(find(f<60))));
        
        LFPresults(j).hb.deltaHPC = sum(Phpc(max(find(f<=0.5)):max(find(f<4))));
        LFPresults(j).hb.thetaHPC = sum(Phpc(max(find(f<=4)):max(find(f<8))));
        LFPresults(j).hb.alphaHPC = sum(Phpc(max(find(f<=8)):max(find(f<12))));
        LFPresults(j).hb.betaHPC = sum(Phpc(max(find(f<=12)):max(find(f<25))));
        LFPresults(j).hb.gammaHPC = sum(Phpc(max(find(f<=25)):max(find(f<60))));
        
        LFPresults(j).hb.deltaBLA = sum(Pbla(max(find(f<=0.5)):max(find(f<4))));
        LFPresults(j).hb.thetaBLA = sum(Pbla(max(find(f<=4)):max(find(f<8))));
        LFPresults(j).hb.alphaBLA = sum(Pbla(max(find(f<=8)):max(find(f<12))));
        LFPresults(j).hb.betaBLA = sum(Pbla(max(find(f<=12)):max(find(f<25))));
        LFPresults(j).hb.gammaBLA = sum(Pbla(max(find(f<=25)):max(find(f<60))));
        
        [c,lags] = xcorr(Vhpc, Vbla, 10000);
        LFPresults(j).hb.xcorr = c;
        LFPresults(j).hb.lags = lags/sf;
        
    else
        LFPresults(j).hb.missing = 1;
    end
    
    % open vHPC/PFC file
    if ~strcmp(LFPdata{j,6}, 'X')
        LFPresults(j).hp.missing = 0;
        fid = fopen([LFPdata{j,3}, '/', LFPdata{j,3}, LFPdata{j,6}, '.nds']);
        frewind(fid);
        V_raw = fread(fid, encoding);
        fclose(fid);
        Vlength = floor((length(V_raw)-skip)/channel_num);
        V = zeros(Vlength, channel_num);
        for i = 1:channel_num
            V(:,i) = scale_factor*V_raw((skip + channel_num*(1:Vlength) - channel_num + i)');
        end
        Vhpc = V(1:LENGTH,1);
        Vpfc = V(1:LENGTH,2);
        % end of code for opening .nds file directly
        
        % analyze vHPC/PFC data
        [Phpc,f] = periodogram(Vhpc,[],25000,sf);
        [Ppfc,f] = periodogram(Vpfc,[],25000,sf);
        
        LFPresults(j).hp.Phpc = Phpc(max(find(f<=0.5)):max(find(f<60)));
        LFPresults(j).hp.Pbla = Ppfc(max(find(f<=0.5)):max(find(f<60)));
        
        LFPresults(j).hp.totPhpc = sum(Phpc(max(find(f<=0.5)):max(find(f<60))));
        LFPresults(j).hp.totPpfc = sum(Ppfc(max(find(f<=0.5)):max(find(f<60))));
        
        LFPresults(j).hp.deltaHPC = sum(Phpc(max(find(f<=0.5)):max(find(f<4))));
        LFPresults(j).hp.thetaHPC = sum(Phpc(max(find(f<=4)):max(find(f<8))));
        LFPresults(j).hp.alphaHPC = sum(Phpc(max(find(f<=8)):max(find(f<12))));
        LFPresults(j).hp.betaHPC = sum(Phpc(max(find(f<=12)):max(find(f<25))));
        LFPresults(j).hp.gammaHPC = sum(Phpc(max(find(f<=25)):max(find(f<60))));
        
        LFPresults(j).hp.deltaPFC = sum(Ppfc(max(find(f<=0.5)):max(find(f<4))));
        LFPresults(j).hp.thetaPFC = sum(Ppfc(max(find(f<=4)):max(find(f<8))));
        LFPresults(j).hp.alphaPFC = sum(Ppfc(max(find(f<=8)):max(find(f<12))));
        LFPresults(j).hp.betaPFC = sum(Ppfc(max(find(f<=12)):max(find(f<25))));
        LFPresults(j).hp.gammaPFC = sum(Ppfc(max(find(f<=25)):max(find(f<60))));
        
        [c,lags] = xcorr(Vhpc, Vpfc, 10000);
        LFPresults(j).hp.xcorr = c;
        LFPresults(j).hp.lags = lags/sf;
        
    else
        LFPresults(j).hp.missing = 1;
    end
    
    LFPresults(j).group = LFPdata{j,2};
    
end


