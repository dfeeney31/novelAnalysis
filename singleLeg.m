%%%%%%% Single leg landing analysis %%%%%%%
clear
addpath('C:\Users\Daniel.Feeney\Documents\novel_data')  
COP_dat = importfile('C:\Users\Daniel.Feeney\Dropbox (Boa)\Boa Team Folder\PilotNovelData\HopBoa.fgt');

%Plot the force values and input start and end of jumping period
figure
plot(COP_dat.LForce)
hold on
plot(COP_dat.RForce)
legend('Left', 'Right')
disp('Select just before landing and near the end of the trial')
[locs, vals] = ginput(2);

figure
plot(COP_dat.RCOPx(floor(locs(1)):floor(locs(2))), COP_dat.RCOPy(floor(locs(1)):floor(locs(2))))

landing = find(COP_dat.RForce(floor(locs(1)):end) > 60, 1);
landing = landing + floor(locs(1));

SD_vec = zeros(1,70);
for i = floor(locs(1)):floor(locs(2)-30)
   win =  COP_dat.RForce(i:i+30);
   SD_vec(i) = std(win);
end
figure 
plot(SD_vec(floor(locs(1)):end))

find(SD_vec(landing:end) < 50,1)