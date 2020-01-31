%%%%%%%%%%% Ski analysis %%%%%%%%%%%
%% Import data
clear
addpath('C:\Users\Daniel.Feeney\Documents\novel_data')  
COP_dat = importfile('C:\Users\Daniel.Feeney\Dropbox (Boa)\Snow Protocol\Protocol_Data\BV_Groomer_1.fgt');
COP_dat2 = importfile('C:\Users\Daniel.Feeney\Dropbox (Boa)\Snow Protocol\Protocol_Data\BV_Groomer_2.fgt');
COP_dat3 = importfile('C:\Users\Daniel.Feeney\Dropbox (Boa)\Snow Protocol\Protocol_Data\BV_Groomer_Unbuckled.fgt');

%% Set values below 100 N to be 0
% Trial 1
filt_forceL = COP_dat.LForce;
filt_forceL(filt_forceL<100) = 0;
filt_forceR = COP_dat.RForce;
filt_forceR(filt_forceR<100) = 0;

%Trial 2
filt_forceL2 = COP_dat2.LForce;
filt_forceL2(filt_forceL2<100) = 0;
filt_forceR2 = COP_dat2.RForce;
filt_forceR2(filt_forceR2<100) = 0;

%Trial 3
filt_forceL3 = COP_dat3.LForce;
filt_forceL3(filt_forceL3<100) = 0;
filt_forceR3 = COP_dat3.RForce;
filt_forceR3(filt_forceR3<100) = 0;


% Align force data. For plotting purposes only
figure(1)
plot(filt_forceL)
hold on
plot(filt_forceL2)
plot(filt_forceL3)
ylim([-100 2000])
legend('Trial 1', 'Trial 2', 'Trial 3')
% Select locations for start of first turn
disp('Select start of 1st(blue) trial')
disp('Select start of 2nd (orange) trial')
disp('Select start of 3rd (yellow) trial')
locations = ginput(3);
close

%% plot aligned data
figure(2)
plot(filt_forceL(floor(locations(1):end)))
hold on
plot(filt_forceL2(floor(locations(2):end)))
plot(filt_forceL3(floor(locations(3):end)))
legend('Trial 1', 'Trial 2', 'Trial 3')
title('Left side')

figure(3)
plot(filt_forceR(floor(locations(1):end)), 'LineWidth',1)
hold on
plot(filt_forceR2(floor(locations(2):end)), 'LineWidth',1)
plot(filt_forceR3(floor(locations(3):end)), 'LineWidth',1)
legend('Trial 1', 'Trial 2', 'Trial 3')
title('Right Side')

%% Quantify peak force and CoV of force for each turn

win_len = 25; %Window length (0.25s) for determination of peak force and CV force
pks1R = zeros(1,5000); pks2R = zeros(1,5000); pks3R = zeros(1,5000);
pksL1 = zeros(1,5000); pks2L = zeros(1,5000); pks3L = zeros(1,5000);
for win = 1:5000
   try 
       tmp_window1 = filt_forceR(win:win+win_len);
       pks1R(win) = mean(tmp_window1);
       tmp_window1L = filt_forceL(win:win+win_len);
       pksL1(win) = mean(tmp_window1L);
       
       tmp_window2 = filt_forceR2(win:win+win_len);
       pks2R(win) = mean(tmp_window2);
       tmp_window1L2 = filt_forceL2(win:win+win_len);
       pksL2(win) = mean(tmp_window1L2);
       
       tmp_window3 = filt_forceR3(win:win+win_len);
       pks3R(win) = mean(tmp_window3);
       tmp_window1L3 = filt_forceL3(win:win+win_len);
       pksL3(win) = mean(tmp_window1L3);
   end
   
end

[peaks1,locs1] = findpeaks(pks1R, 'MinPeakDistance',200, 'MinPeakHeight',500); [peaksL1,locsl1] = findpeaks(pksL1, 'MinPeakDistance',200, 'MinPeakHeight',400);
[peaks2,locs2] = findpeaks(pks2R, 'MinPeakDistance',200, 'MinPeakHeight',500);[peaksL2,locsl2] = findpeaks(pksL2, 'MinPeakDistance',200, 'MinPeakHeight',400);
[peaks3,locs3] = findpeaks(pks3R, 'MinPeakDistance',200, 'MinPeakHeight',500);[peaksL3,locsl3] = findpeaks(pksL3, 'MinPeakDistance',200, 'MinPeakHeight',300);

rightPeaks = [peaks1(1:6)';peaks2(1:6)';peaks3(1:6)'];
leftPeaks = [peaksL1(1:6)';peaksL2(1:6)';peaksL3(1:6)'];


%% Coefficient of variation surrounding peaks
% Scratch work to determine appropriate epoch for precision (CoV)
% figure
% for i = 1:6
%     plot(filt_forceL3(locsl3(i)-100:locsl3(i)+100))
%     hold on
% end
% 
% figure
% for i = 1:6
%     plot(filt_forceR3(locs3(i)-100:locs3(i)+100))
%     hold on
% end
window_length = 50;
CVR1 = zeros(1,6); CVR2 = zeros(1,6); CVL3 = zeros(1,6);
for turn = 1:6
    CVR1(turn) = std(filt_forceR(locs1(turn)-window_length:locs1(turn)+window_length)) /mean(filt_forceR(locs1(turn)-window_length:locs1(turn)+window_length)); 
    CVR2(turn) = std(filt_forceR2(locs2(turn)-window_length:locs2(turn)+window_length)) /mean(filt_forceR2(locs2(turn)-window_length:locs2(turn)+window_length)); 
    CVR3(turn) = std(filt_forceR3(locs3(turn)-window_length:locs3(turn)+window_length)) /mean(filt_forceR3(locs3(turn)-window_length:locs3(turn)+window_length)); 
end

outputCV = [CVR1';CVR2';CVR3']
outputForces = [rightPeaks,leftPeaks]
