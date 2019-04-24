%%%%%% PCA and SVM of plantar data %%%%%
%dat = importRaw('C:\Users\Daniel.Feeney\Dropbox (Boa)\Trail Run Internal Pilot\PedarFiles\Mazzio_Jon\20190416\Mazzio_Jon_3.asc')

dat = MazzioJon1;
% start at frame 204

for frame = 204:220
    resDat = pedarReshape(dat, frame);
    figure
    contourf(resDat);
end

