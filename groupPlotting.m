%%%%% Plotting the results %%%%%

%% Plots for Jon
%Right side, switchback
col_no = 13; col_no2 = 11; col_no3 = 15; col_no4 = 17;
figure(1)
plot(mean(longdata.COPxR{1,col_no}), mean(longdata.COPyR{1,col_no}),'LineWidth',2)
title('S1 Right Saucony Switchback', 'FontSize',16)
ylabel('Anterior - Posterior (mm)', 'FontSize',14)
xlabel('Medial-Lateral (mm)', 'FontSize',14)
hold on
plot(mean(longdata.COPxR{1,col_no2}), mean(longdata.COPyR{1,col_no2}),'LineWidth',2)
plot(mean(longdata.COPxR{1,col_no3}), mean(longdata.COPyR{1,col_no3}),'LineWidth',2)
plot(mean(longdata.COPxR{1,col_no4}), mean(longdata.COPyR{1,col_no4}),'LineWidth',2)
xlim([35 75])
ylim([150 230])
legend('Laced','LR','Tri strap', 'X')
% Left side
col_no = 13; col_no2 = 11; col_no3 = 15; col_no4 = 17;
figure(2)
plot(mean(longdata.COPxL{1,col_no}), mean(longdata.COPyL{1,col_no}),'LineWidth',2)
title('S1 Left Saucony Switchback', 'FontSize',16)
ylabel('Anterior - Posterior (mm)', 'FontSize',14)
xlabel('Medial-Lateral (mm)', 'FontSize',14)
hold on
plot(mean(longdata.COPxL{1,col_no2}), mean(longdata.COPyL{1,col_no2}),'LineWidth',2)
plot(mean(longdata.COPxL{1,col_no3}), mean(longdata.COPyL{1,col_no3}),'LineWidth',2)
plot(mean(longdata.COPxL{1,col_no4}), mean(longdata.COPyL{1,col_no4}),'LineWidth',2)
xlim([30 75])
ylim([150 230])
legend('Laced','LR','Tri strap', 'X')

% NB plots. 
%Right side
col_no = 12; col_no2 = 10; col_no3 = 14; col_no4 = 16;
figure(3)
plot(mean(longdata.COPxR{1,col_no}), mean(longdata.COPyR{1,col_no}),'LineWidth',2)
title('S1 Right New Balance Hierro', 'FontSize',16)
ylabel('Anterior - Posterior (mm)', 'FontSize',14)
xlabel('Medial-Lateral (mm)', 'FontSize',14)
hold on
plot(mean(longdata.COPxR{1,col_no2}), mean(longdata.COPyR{1,col_no2}),'LineWidth',2)
plot(mean(longdata.COPxR{1,col_no3}), mean(longdata.COPyR{1,col_no3}),'LineWidth',2)
plot(mean(longdata.COPxR{1,col_no4}), mean(longdata.COPyR{1,col_no4}),'LineWidth',2)
xlim([35 75])
ylim([150 230])
legend('Laced','LR','Tri strap', 'X')

%Left side
col_no = 12; col_no2 = 10; col_no3 = 14; col_no4 = 16;
figure(4)
plot(mean(longdata.COPxL{1,col_no}), mean(longdata.COPyL{1,col_no}),'LineWidth',2)
title('S1 Left New Balance Hierro', 'FontSize',16)
ylabel('Anterior - Posterior (mm)', 'FontSize',14)
xlabel('Medial-Lateral (mm)', 'FontSize',14)
hold on
plot(mean(longdata.COPxL{1,col_no2}), mean(longdata.COPyL{1,col_no2}),'LineWidth',2)
plot(mean(longdata.COPxL{1,col_no3}), mean(longdata.COPyL{1,col_no3}),'LineWidth',2)
plot(mean(longdata.COPxL{1,col_no4}), mean(longdata.COPyL{1,col_no4}),'LineWidth',2)
xlim([35 75])
ylim([150 230])
legend('Laced','LR','Tri strap', 'X')

%% Plots for Bobby
col_no = 4; col_no2 = 2; col_no3 = 6; col_no4 = 8;
figure(5)
plot(mean(longdata.COPxR{1,col_no}), mean(longdata.COPyR{1,col_no}),'LineWidth',2)
title('S2 Right Saucony Switchback', 'FontSize',16)
ylabel('Anterior - Posterior (mm)', 'FontSize',14)
xlabel('Medial-Lateral (mm)', 'FontSize',14)
hold on
plot(mean(longdata.COPxR{1,col_no2}), mean(longdata.COPyR{1,col_no2}),'LineWidth',2)
plot(mean(longdata.COPxR{1,col_no3}), mean(longdata.COPyR{1,col_no3}),'LineWidth',2)
plot(mean(longdata.COPxR{1,col_no4}), mean(longdata.COPyR{1,col_no4}),'LineWidth',2)
legend('Laced','LR','Tri strap', 'X')

col_no = 3; col_no2 = 1; col_no3 = 5; col_no4 = 7;
figure(6)
plot(mean(longdata.COPxR{1,col_no}), mean(longdata.COPyR{1,col_no}),'LineWidth',2)
title('S2 Right New Balance Hierro', 'FontSize',16)
ylabel('Anterior - Posterior (mm)', 'FontSize',14)
xlabel('Medial-Lateral (mm)', 'FontSize',14)
hold on
plot(mean(longdata.COPxR{1,col_no2}), mean(longdata.COPyR{1,col_no2}),'LineWidth',2)
plot(mean(longdata.COPxR{1,col_no3}), mean(longdata.COPyR{1,col_no3}),'LineWidth',2)
plot(mean(longdata.COPxR{1,col_no4}), mean(longdata.COPyR{1,col_no4}),'LineWidth',2)
legend('Laced','LR','Tri strap', 'X')