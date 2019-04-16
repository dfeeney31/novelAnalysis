%%%%%%% Import novel with custom function importfile.m from the novel
%%%%%%% analysis directory.
clear
COP_dat = importfile('Feeney_Dan_3.fgt');

%This is just a test to look at COP values during one step L/R
figure(1)
plot(COP_dat.LCOPx(432:455), COP_dat.LCOPy(432:455))
hold on
plot(COP_dat.RCOPx(466:491), COP_dat.RCOPy(466:491))
legend('Left', 'Right')

%Test to look at Force values during one step L/R
figure(2)
plot(COP_dat.LForce(432:455))
hold on
plot(COP_dat.RForce(466:491))
legend('Left', 'Right')

%% Find the start of each step
R_steps = zeros(1,20);
counter = 1;
for i = 1:(length(COP_dat.RForce)-1)
    if COP_dat.RForce(i) == 0 && COP_dat.RForce(i+1) > COP_dat.RForce(i) + 75
       R_steps(counter) = i;
       counter = counter + 1;
    end
end
R_steps = R_steps(R_steps~=0);
%% Now find the end of each step
R_ends = zeros(1,20);
counter = 1;
for i = 1:(length(COP_dat.RForce)-1)
    if COP_dat.RForce(i) ~= 0 && COP_dat.RForce(i+1) == 0
       R_ends(counter) = i;
       counter = counter + 1;
    end
end
R_ends = R_ends(R_ends~=0); R_ends = R_ends(R_ends > 10); %Remove falsely preallocated 0s and false early steps due to NAs

%% Repeat for the left side
L_steps = zeros(1,20);
counter = 1;
for i = 1:(length(COP_dat.LForce)-1)
    if COP_dat.LForce(i) == 0 && COP_dat.LForce(i+1) > 75
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
plot(COP_dat.RForce(R_steps(1):R_ends(1)))
title('Right Force')
hold on
for l = 2:length(R_steps)
    plot(COP_dat.RForce(R_steps(l):R_ends(l)))
end

figure(4)
plot(COP_dat.LForce(L_steps(1):L_ends(1)))
title('Left Force')
hold on
for l = 2:length(L_steps)
    plot(COP_dat.LForce(L_steps(l):L_ends(l)))
end

%% plot COP as above
R_stepsCOP = R_steps +1; %increment by 1 index to avoid the 0,0 being plotted
figure(5)
plot(COP_dat.RCOPx(R_stepsCOP(1):R_ends(1)), COP_dat.RCOPy(R_stepsCOP(1):R_ends(1)))
title('Right COP')
hold on
for ll = 2:length(R_stepsCOP)
    plot(COP_dat.RCOPx(R_stepsCOP(ll):R_ends(ll)), COP_dat.RCOPy(R_stepsCOP(ll):R_ends(ll)))
end

L_stepsCOP = L_steps + 1; %increment by 1 index to avoid the 0,0 being plotted
figure(6)
plot(COP_dat.RCOPx(L_stepsCOP(1):L_ends(1)), COP_dat.RCOPy(L_stepsCOP(1):L_ends(1)))
title('Left COP')
hold on
for jj = 2:length(L_stepsCOP)
    plot(COP_dat.LCOPx(L_stepsCOP(jj):L_ends(jj)), COP_dat.LCOPy(L_stepsCOP(jj):L_ends(jj)))
end


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