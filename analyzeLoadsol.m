%% Analysis of Novel Loadsol force insoles %%

addpath('C:\Users\Daniel.Feeney\Documents\novel_data')
dat = importLoadsol('C:\Users\Daniel.Feeney\Dropbox (Boa)\Hike Work Research\Data\mattWalk_20-02-05 11-14-23-719.txt');
dat.Properties.VariableNames = {'Time' 'LeftHeel' 'LeftLateral' 'LeftMedial','Left','Time2','RightLateral','RightMedial','RightHeel','Right','toBePassed'};
dat = dat(:,1:10);


%% plotting
figure
plot(dat.LeftHeel)
hold on
title('Left Insole')
plot(dat.LeftLateral)
plot(dat.LeftMedial)
plot(dat.Left, 'LineWidth',2)
legend('Heel','Lateral','Medial','Total')

figure
plot(dat.RightHeel)
hold on
title('Right Insole')
plot(dat.RightLateral)
plot(dat.RightMedial)
plot(dat.Right, 'LineWidth',2)
legend('Heel','Lateral','Medial','Total')