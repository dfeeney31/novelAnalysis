%%%% Golf Novel data Analysis %%%%
clear
addpath('C:\Users\Daniel.Feeney\Documents\novel_data')  
COP_dat = importfile('C:\Users\Daniel.Feeney\Dropbox (Boa)\Boa Team Folder\PilotNovelData\20190429\BrettSwing.fgt');
%COP_dat = importfile('C:\Users\Daniel.Feeney\Dropbox (Boa)\Boa Team Folder\PilotNovelData\20190429\BrettSwing2.fgt');
%COP_dat = importfile('C:\Users\Daniel.Feeney\Dropbox (Boa)\Boa Team Folder\PilotNovelData\20190429\BrettSwing3.fgt');

figure
plot(COP_dat.LForce)
hold on
plot(COP_dat.RForce)
ylabel('Force (N)')
xlabel('Time (1/100th s)')
title('Normal Force')
legend('Left','Right')
hold off

figure
plot(COP_dat.LCOPx, COP_dat.LCOPy)
hold on
plot(COP_dat.RCOPx, COP_dat.RCOPy)
title('Center of Pressure')
ylabel('Anterior - Posterior (mm)')
xlabel('Medial - Lateral (mm)')
legend('Left','Right')

[lPk,lPkLoc] = max(COP_dat.LForce);
[rPk,rPkLoc] = max(COP_dat.RForce);

firstPt = "The maximal lead foot force is: %f N";
sprintf(firstPt,max(COP_dat.LForce))
firstPt2 = "The maximal rear foot force is: %f N";
sprintf(firstPt2,max(COP_dat.RForce))

COP_total.Lx = sum(abs(diff(COP_dat.LCOPx(lPkLoc-20:lPkLoc+20))));
COP_total.Ly = sum(abs(diff(COP_dat.LCOPy(lPkLoc-20:lPkLoc+20))));
COP_total.Rx = sum(abs(diff(COP_dat.RCOPx(rPkLoc-20:rPkLoc+20))));
COP_total.Ry = sum(abs(diff(COP_dat.RCOPy(rPkLoc-20:rPkLoc+20))));
COP_total.Lforce = max(COP_dat.LForce);
COP_total.Rforce = max(COP_dat.RForce);
COP_total.LRFD = (max(COP_dat.LForce) - COP_dat.LForce(lPkLoc - 20)) / 0.2;
COP_total.RRFD = (max(COP_dat.RForce) - COP_dat.RForce(rPkLoc - 20)) / 0.2;
output = struct2table(COP_total)
