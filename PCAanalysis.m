%%%%%% PCA and SVM of plantar data %%%%%
clear
dat = importRaw('C:\Users\Daniel.Feeney\Dropbox (Boa)\Trail Run Internal Pilot\PedarFiles\Mazzio_Jon\20190416\Mazzio_Jon_3.asc');
dat = table2array(dat);

% start at frame 204

for frame = 127:146
    resDat = pedarReshape(dat, frame);
    figure
    contourf(resDat);
end

pedDat = pedarReshape(dat, 127);
contourf(pedDat)


% current reshaping is going down the columns then rows. Need to do r,c