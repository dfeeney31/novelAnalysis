%%%%%%% Single leg landing analysis %%%%%%%
clear
addpath('C:\Users\Daniel.Feeney\Documents\novel_data')  
Boa_landing = importfile('C:\Users\Daniel.Feeney\Dropbox (Boa)\Boa Team Folder\PilotNovelData\HopBoa.fgt');
NL_landing = importfile('C:\Users\Daniel.Feeney\Dropbox (Boa)\Boa Team Folder\PilotNovelData\HopNL.fgt');


%Plot the force values and input start and end of jumping period
figure
plot(Boa_landing.LForce)
hold on
plot(Boa_landing.RForce)
title('Boa')
legend('Left', 'Right')
disp('Select just before landing and near the end of the trial for Boa')
[locs_boa, vals_boa] = ginput(2);

%Same thing for non laced
figure
plot(NL_landing.LForce)
hold on
plot(NL_landing.RForce)
title('Non Laced')
legend('Left', 'Right')
disp('Select just before landing and near the end of the trial for non laced')
[locs_NL, vals_NL] = ginput(2);

%Plot center of pressure during landing and stabilization for both
%conditions
figure
plot(Boa_landing.RCOPx(floor(locs_boa(1)):floor(locs_boa(1)+100)), Boa_landing.RCOPy(floor(locs_boa(1)):floor(locs_boa(1)+100)))
hold on
plot(NL_landing.RCOPx(floor(locs_NL(1)):floor(locs_NL(1)+100)), NL_landing.RCOPy(floor(locs_NL(1)):floor(locs_NL(1)+100)))
legend('Boa','Non laced')

%calculate a point with relatively high confidence where landing has begun
landing_boa = find(Boa_landing.RForce(floor(locs_boa(1)):end) > 60, 1); %Threshold of 60N is beta testing as of 5/3/19
landing_boa = landing_boa + floor(locs_boa(1));
%NL
landing_NL = find(NL_landing.RForce(floor(locs_NL(1)):end) > 60, 1);
landing_NL = landing_NL + floor(locs_NL(1));

%Create a vector of standard deviations for windows of 0.3s
SD_Boa = zeros(1,70);
for i = floor(locs_boa(1)):floor(locs_boa(2)-30)
   win =  Boa_landing.RForce(i:i+30);
   SD_Boa(i) = std(win);
end

% Same SD vecto for NL
SD_NL = zeros(1,70);
for i = floor(locs_NL(1)):floor(locs_NL(2)-30)
   win =  NL_landing.RForce(i:i+30);
   SD_NL(i) = std(win);
end
%Plot the SD vectors of both trials 
figure 
plot(SD_Boa(floor(locs_boa(1)):end))
hold on
plot(SD_NL(floor(locs_NL(1)):end))
title('SD of 0.3s windows')
legend('Boa','Non laced')

% Calculate a point where stability has occured. Still being tested
find(SD_Boa(landing_boa:end) < 50,1)
find(SD_NL(landing_NL:end) < 50,1)

% Trial testing COP movement 