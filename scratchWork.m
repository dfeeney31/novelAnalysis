%%%%%%% Import novel with custom function importfile.m from the novel
%%%%%%% analysis directory.
clear
COP_dat = importfile('C:\Users\Daniel.Feeney\Dropbox (Boa)\Trail Run Internal Pilot\PedarFiles\TimeSeriesData\BobbyXNB.fgt');

%This is just a test to look at COP values during one step L/R
% figure(1)
% plot(COP_dat.LCOPx(432:455), COP_dat.LCOPy(432:455))
% hold on
% plot(COP_dat.RCOPx(466:491), COP_dat.RCOPy(466:491))
% legend('Left', 'Right')
% 
% %Test to look at Force values during one step L/R
% figure(2)
% plot(COP_dat.LForce(432:455))
% hold on
% plot(COP_dat.RForce(466:491))
% legend('Left', 'Right')

%% Find the start of each step
R_steps = zeros(1,20);
counter = 1;
for i = 1:(length(COP_dat.RForce)-1)
    if (COP_dat.RForce(i) < 60) && (COP_dat.RForce(i+4) > 100)
       R_steps(counter) = i;
       counter = counter + 1;
    end
end
R_steps = R_steps(R_steps~=0);
%% Now find the end of each step
R_ends = zeros(1,20);
counter = 1;
for i = 1:(length(COP_dat.RForce)-1)
    if COP_dat.RForce(i) >65 && COP_dat.RForce(i+1) < 30
       R_ends(counter) = i;
       counter = counter + 1;
    end
end
R_ends = R_ends(R_ends~=0); R_ends = R_ends(R_ends > 10); %Remove falsely preallocated 0s and false early steps due to NAs

%% Repeat for the left side
L_steps = zeros(1,20);
counter = 1;
for i = 1:(length(COP_dat.LForce)-1)
    if (COP_dat.LForce(i) < 60) && (COP_dat.LForce(i+4) > 100)
       L_steps(counter) = i;
       counter = counter + 1;
    end
end
L_steps = L_steps(L_steps~=0);
%% Left step ends
L_ends = zeros(1,20);
counter = 1;
for i = 1:(length(COP_dat.LForce)-1)
    if COP_dat.LForce(i) ~= 0 && COP_dat.LForce(i+1) == 0
       L_ends(counter) = i;
       counter = counter + 1;
    end
end
L_ends = L_ends(L_ends~=0); L_ends = L_ends(L_ends > 10); %Remove falsely preallocated 0s and false early steps due to NAs


%% arrange data for plotting data with error bars

figure(3)
plot(COP_dat.RForce(R_steps(1):R_steps(1) + 30))
title('Right Force')
hold on
for l = 2:length(R_steps-1)
    plot(COP_dat.RForce(R_steps(l):R_steps(l) + 30))
end

figure(4)
plot(COP_dat.LForce(L_steps(1):L_steps(1) + 30))
title('Left Force')
hold on
for ll = 2:length(L_steps)
    plot(COP_dat.LForce(L_steps(ll):L_steps(ll) + 30))
end

%% plot COP as above
R_stepsCOP = R_steps +1; %increment by 1 index to avoid the 0,0 being plotted
figure(5)
plot(COP_dat.RCOPx(R_stepsCOP(1):R_stepsCOP(1)+20), COP_dat.RCOPy(R_stepsCOP(1):R_stepsCOP(1)+20))
title('Right COP')
hold on
for ll = 2:length(R_stepsCOP)
    plot(COP_dat.RCOPx(R_stepsCOP(ll):R_stepsCOP(ll)+20), COP_dat.RCOPy(R_stepsCOP(ll):R_stepsCOP(ll)+20))
end

% Stack the values 
COPy_stacked = zeros(22, 21);
COPx_stacked = zeros(22, 21);
for step = 1:length(R_steps)
   COPy_stacked(step,:) = COP_dat.RCOPy(R_stepsCOP(step):R_stepsCOP(step)+20);
   COPx_stacked(step,:) = COP_dat.RCOPx(R_stepsCOP(step):R_stepsCOP(step)+20);
end
COPy_stacked = COPy_stacked(~any(COPy_stacked == 0,2),:)
COPx_stacked = COPx_stacked(~any(COPx_stacked == 0,2),:)
plot(mean(COPx_stacked), mean(COPy_stacked))

L_stepsCOP = L_steps + 1; %increment by 1 index to avoid the 0,0 being plotted
figure(6)
plot(COP_dat.LCOPx(L_stepsCOP(1):L_stepsCOP(1)+20), COP_dat.LCOPy(L_stepsCOP(1):L_stepsCOP(1) + 20))
title('Left COP')
hold on
for jj = 2:length(L_stepsCOP)
    plot(COP_dat.LCOPx(L_stepsCOP(jj):L_stepsCOP(jj)+20), COP_dat.LCOPy(L_stepsCOP(jj):L_stepsCOP(jj)+20)) 
end


% Stack the values for left insole
for step = 1:length(L_steps)
   COPy_stackedL(step,:) = COP_dat.LCOPy(L_stepsCOP(step):L_stepsCOP(step)+20);
   COPx_stackedL(step,:) = COP_dat.LCOPx(L_stepsCOP(step):L_stepsCOP(step)+20);
end

COPy_stackedL = COPy_stackedL(~any(COPy_stackedL == 0,2),:)
COPx_stackedL = COPx_stackedL(~any(COPx_stackedL == 0,2),:)
plot(mean(COPx_stackedL), mean(COPy_stackedL))


%Calcualte the peaks for M-L trajectory
[pksR,locsL] = findpeaks(-1 * COP_dat.RCOPx); % find peaks but need to multiply by -1 to get the medial peak
pksR = pksR(pksR ~=0); pksR = -1 * pksR; %Remove false 0 peaks and return back to the correct sign
figure(7)
findpeaks(-1 * COP_dat.RCOPx) 
falsePeakValR = input('Input the value to remove false peaks: ')
pksR = pksR(pksR < falsePeakValR);

[pksL,locsL] = findpeaks(-1 * COP_dat.LCOPx);
pksL = pksL(pksL ~=0); pksL = -1 * pksL;
figure(8)
findpeaks(-1 * COP_dat.LCOPx)
falsePeakValL = input('Input the value to remove false peaks: ')
pksL = pksL(pksL < falsePeakValL);

L_med_peak = mean(pksL)
R_med_peak = mean(pksR)