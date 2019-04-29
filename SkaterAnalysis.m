%%%% Skater jump Novel data Analysis %%%%
clear
addpath('C:\Users\Daniel.Feeney\Documents\novel_data')  
COP_dat = importfile('C:\Users\Daniel.Feeney\Dropbox (Boa)\Boa Team Folder\PilotNovelData\20190429\BrettSkater.fgt');

figure
plot(COP_dat.LForce)
hold on
plot(COP_dat.RForce)
ylabel('Force (N)')
xlabel('Time (1/100th s)')
title('Normal Force')
legend('Left','Right')
hold off

%% Find the start of each landing
R_steps = zeros(1,3);
counter = 1;
for i = 1:(length(COP_dat.RForce)-1)
    if (COP_dat.RForce(i) < 60) && (COP_dat.RForce(i+1) > 100)
       R_steps(counter) = i;
       counter = counter + 1;
    end
end
R_steps = R_steps(R_steps~=0);

%% Find the end of each landing
R_ends = zeros(1,length(R_steps));
counter = 1;
for i = 1:(length(COP_dat.RForce)-1)
    if COP_dat.RForce(i) > 100 && COP_dat.RForce(i+2) < 65
       R_ends(counter) = i;
       counter = counter + 1;
    end
end
R_ends = R_ends(R_ends~=0); R_ends = R_ends(R_ends > 10); %Remove falsely preallocated 0s and false early steps due to NAs

