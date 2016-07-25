[ns_RESULT, hFile] = ns_OpenFile('datafile0004.ns5');
for i = 1:4
    for j = 1:4
        fprintf('Extracting data from %s-%d-%d...\n', GridAntSupLabel(i,j).port, GridAntSupLabel(i,j).headstage, GridAntSupLabel(i,j).channel);
        [ns_RESULT, entityIDs] = get_ripple_entity(hFile, GridAntSupLabel(i,j).port, GridAntSupLabel(i,j).headstage, GridAntSupLabel(i,j).channel);
        analog_entities = entityIDs(strcmp({entityIDs(:).type}, 'Analog'));
        file_indexes = [hFile.Entity([analog_entities(:).index]).FileType];
        periods = [hFile.FileInfo(file_indexes).Period];
        entity30kHz = find(periods==1);
        [ns_RESULT, entityInfo] = ns_GetEntityInfo(hFile, analog_entities(entity30kHz).index);
        [ns_RESULT, countList, GridAntSupData(:,i,j)] = ns_GetAnalogData(hFile, analog_entities(entity30kHz).index, 1, entityInfo.ItemCount);
    end
end
for i = 1:4
    for j = 1:4
        GridAntSupData1kHz(:,i,j) = downsample(GridAntSupData(:,i,j), 30);
    end
end
for i = 1:31
    G50GoBlock(:,i) = GridAntSupData1kHz(floor(1000*(time_stamps(7+5*(i-1))-1)):floor(1000*(time_stamps(7+5*(i-1))+2.5)),2,3);
end


for i = 1:4
    for j = 1:4
        fprintf('Processing %s-%d-%d...\n', GridLabel(i,j).port, GridLabel(i,j).headstage, GridLabel(i,j).channel);
        for k = 1:30
            ThisElectrodeGoBlock(:,k) = GridData1kHz(floor(1000*(time_stamps(7+5*(k-1))-5)):floor(1000*(time_stamps(7+5*(k-1))+5)),i,j);
        end
        iwin100=0;
        iwin10=0;
        ilose10=0;
        ilose100=0;
        isqueeze=0;
        irest=0;
        for k = 1:30
            switch UnilateralMotivationTaskSW1{k,4}
                case 'WIN $100'
                    iwin100=iwin100+1; ThisElectrodeGoBlockWin100(:,iwin100) = ThisElectrodeGoBlock(:,k);
                case 'WIN $10'
                    iwin10=iwin10+1; ThisElectrodeGoBlockWin10(:,iwin10) = ThisElectrodeGoBlock(:,k);
                case 'LOSE $10'
                    ilose10=ilose10+1; ThisElectrodeGoBlockLose10(:,ilose10) = ThisElectrodeGoBlock(:,k);
                case 'LOSE $100'
                    ilose100=ilose100+1; ThisElectrodeGoBlockLose100(:,ilose100) = ThisElectrodeGoBlock(:,k);
                case 'SQUEEZE'
                    isqueeze=isqueeze+1; ThisElectrodeGoBlockSqueeze(:,isqueeze) = ThisElectrodeGoBlock(:,k);
                case 'REST'
                    irest=irest+1; ThisElectrodeGoBlockRest(:,irest) = ThisElectrodeGoBlock(:,k);
            end
        end
        [S_W100_Grid{i,j},t,f,Serr]=mtspecgramc(ThisElectrodeGoBlockWin100,movingwin,params);
        [S_W10_Grid{i,j},t,f,Serr]=mtspecgramc(ThisElectrodeGoBlockWin10,movingwin,params);
        [S_L100_Grid{i,j},t,f,Serr]=mtspecgramc(ThisElectrodeGoBlockLose100,movingwin,params);
        [S_L10_Grid{i,j},t,f,Serr]=mtspecgramc(ThisElectrodeGoBlockLose10,movingwin,params);
        [S_R_Grid{i,j},t,f,Serr]=mtspecgramc(ThisElectrodeGoBlockRest,movingwin,params);
        [S_S_Grid{i,j},t,f,Serr]=mtspecgramc(ThisElectrodeGoBlockSqueeze,movingwin,params);
    end
end