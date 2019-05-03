%%%%%% PCA and SVM of plantar data %%%%%
clear
dat = importRaw('C:\Users\Daniel.Feeney\Dropbox (Boa)\Trail Run Internal Pilot\PedarFiles\Mazzio_Jon\20190416\Mazzio_Jon_3.asc');
dat = importRaw('C:\Users\Daniel.Feeney\Dropbox (Boa)\Boa Team Folder\PilotNovelData\20190429\BrettSwing.asc');
dat = table2array(dat);
dat2 = dat(:,100:end); %include the 100th column because pedarReshape ignores the first column (normally time). 

for frame = 127:140
    resDat = pedarReshape(dat, frame);
    figure
    contourf(resDat);
end

pedDat = pedarReshape(dat, 128);
contourf(pedDat)
