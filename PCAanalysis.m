%%%%%% PCA and SVM of plantar data %%%%%
%dat = importRaw('C:\Users\Daniel.Feeney\Dropbox (Boa)\Trail Run Internal Pilot\PedarFiles\Mazzio_Jon\20190416\Mazzio_Jon_3.asc')

dat = MazzioJon1;
% start at frame 204
plot(dat(:,2))
for frame = 490:510
    resDat = pedarReshape(dat, frame);
    figure
    contourf(resDat);
end

pedarReshape(dat, 510)
contourf(ans)
dat(510,96)

% current reshaping is going down the columns then rows. Need to do r,c