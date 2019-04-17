%%%%%%%%%%%% Script to calculate M-L trajectories frrom Novel %%%%%%%%%%%%%
%%%%%%%%%%%% Takes fgt files in alphabetical order 

clear
files = dir('*.fgt');
longdata = struct();

counter_outside = 1;
for file = files'
   COP_dat = importfile(file.name);
    % Do some stuff
    clear counter_var filt_force locs pks zeros_1 
    
    % delimit the Right steps
    R_steps = zeros(1,20);
    counter = 1;
    for i = 1:(length(COP_dat.RForce)-1)
        if (COP_dat.RForce(i) < 25) && (COP_dat.RForce(i+1) > COP_dat.RForce(i) + 50)
            R_steps(counter) = i;
            counter = counter + 1;
        end
    end
    R_steps = R_steps(R_steps~=0);
    
    % Repeat for the left side
    L_steps = zeros(1,20);
    counter = 1;
    for i = 1:(length(COP_dat.LForce)-1)
        if (COP_dat.LForce(i) < 25) && (COP_dat.LForce(i+1) > COP_dat.LForce(i) + 50)
            L_steps(counter) = i;
            counter = counter + 1;
        end
    end
    L_steps = L_steps(L_steps~=0);
    
    %%%%% Stack the values into matrix for storing %%%%
    R_stepsCOP = R_steps +1; %increment by 1 index to avoid the 0,0 being plotted
    COPy_stackedR = zeros(22, 21);
    COPx_stackedR = zeros(22, 21);
    for step = 1:(length(R_steps) - 1)
        COPy_stackedR(step,:) = COP_dat.RCOPy(R_stepsCOP(step):R_stepsCOP(step)+20);
        COPx_stackedR(step,:) = COP_dat.RCOPx(R_stepsCOP(step):R_stepsCOP(step)+20);
    end
    COPy_stackedR = COPy_stackedR(~any(COPy_stackedR == 0,2),:);
    COPx_stackedR = COPx_stackedR(~any(COPx_stackedR == 0,2),:);
    
    % Stack the values for left insole
    L_stepsCOP = L_steps + 1; %increment by 1 index to avoid the 0,0 being plotted
    COPy_stackedL = zeros(length(L_steps), 21);
    COPx_stackedL = zeros(length(L_steps), 21);
    for step = 1:(length(L_steps)-1)
        if ~any(COP_dat.LCOPy(L_stepsCOP(step):L_stepsCOP(step)+20))
            pass
        else
            COPy_stackedL(step,:) = COP_dat.LCOPy(L_stepsCOP(step):L_stepsCOP(step)+20);
            COPx_stackedL(step,:) = COP_dat.LCOPx(L_stepsCOP(step):L_stepsCOP(step)+20);
            
        end
    end
    
    COPy_stackedL = COPy_stackedL(~any(COPy_stackedL == 0,2),:);
    COPx_stackedL = COPx_stackedL(~any(COPx_stackedL == 0,2),:);
    
    %Calcualte the peaks for M-L trajectory
%     [pksR,locsL] = findpeaks(-1 * COP_dat.RCOPx); % find peaks but need to multiply by -1 to get the medial peak
%     pksR = pksR(pksR ~=0); pksR = -1 * pksR; %Remove false 0 peaks and return back to the correct sign
%     figure(1)
%     findpeaks(-1 * COP_dat.RCOPx)
%     falsePeakValR = input('Input the value to remove false peaks: ')
%     pksR = pksR(pksR < falsePeakValR);
%     
%     [pksL,locsL] = findpeaks(-1 * COP_dat.LCOPx);
%     pksL = pksL(pksL ~=0); pksL = -1 * pksL;
%     figure(2)
%     findpeaks(-1 * COP_dat.LCOPx)
%     falsePeakValL = input('Input the value to remove false peaks: ')
%     pksL = pksL(pksL < falsePeakValL);
    
    
    %%%%%% Save the data of interest into a cell array
    longdata.name{counter_outside} = file.name;
    longdata.COPyL{counter_outside} = COPy_stackedL;
    longdata.COPxL{counter_outside} = COPx_stackedL;
    longdata.COPyR{counter_outside} = COPy_stackedR;
    longdata.COPxR{counter_outside} = COPx_stackedR;
%     longdata.LMedPeak = mean(pksL);
%     longdata.RMedPeak = mean(pksR);
    
    counter_outside = counter_outside + 1;
end

%% Plots for Jon
col_no = 13; col_no2 = 11; col_no3 = 15; col_no4 = 17;
figure(1)
plot(mean(longdata.COPxR{1,col_no}), mean(longdata.COPyR{1,col_no}))
title('S1 Saucony Switchback')
ylabel('Anterior - Posterior (mm)')
xlabel('Medial-Lateral (mm)')
hold on
plot(mean(longdata.COPxR{1,col_no2}), mean(longdata.COPyR{1,col_no2}))
plot(mean(longdata.COPxR{1,col_no3}), mean(longdata.COPyR{1,col_no3}))
plot(mean(longdata.COPxR{1,col_no4}), mean(longdata.COPyR{1,col_no4}))
legend('Laced','LR','Tri strap', 'X')

col_no = 12; col_no2 = 10; col_no3 = 14; col_no4 = 16;
figure(2)
plot(mean(longdata.COPxR{1,col_no}), mean(longdata.COPyR{1,col_no}))
title('S1 New Balance Hierro')
ylabel('Anterior - Posterior (mm)')
xlabel('Medial-Lateral (mm)')
hold on
plot(mean(longdata.COPxR{1,col_no2}), mean(longdata.COPyR{1,col_no2}))
plot(mean(longdata.COPxR{1,col_no3}), mean(longdata.COPyR{1,col_no3}))
plot(mean(longdata.COPxR{1,col_no4}), mean(longdata.COPyR{1,col_no4}))
legend('Laced','LR','Tri strap', 'X')

%% Plots for Bobby
% col_no = 4; col_no2 = 2; col_no3 = 6; col_no4 = 8;
% figure(3)
% plot(mean(longdata.COPxR{1,col_no}), mean(longdata.COPyR{1,col_no}))
% title('S2 Saucony Switchback')
% ylabel('Anterior - Posterior (mm)')
% xlabel('Medial-Lateral (mm)')
% hold on
% plot(mean(longdata.COPxR{1,col_no2}), mean(longdata.COPyR{1,col_no2}))
% plot(mean(longdata.COPxR{1,col_no3}), mean(longdata.COPyR{1,col_no3}))
% plot(mean(longdata.COPxR{1,col_no4}), mean(longdata.COPyR{1,col_no4}))
% legend('Laced','LR','Tri strap', 'X')
% 
% col_no = 3; col_no2 = 11; col_no3 = 5; col_no4 = 7;
% figure(4)
% plot(mean(longdata.COPxR{1,col_no}), mean(longdata.COPyR{1,col_no}))
% title('S2 New Balance Hierro')
% ylabel('Anterior - Posterior (mm)')
% xlabel('Medial-Lateral (mm)')
% hold on
% plot(mean(longdata.COPxR{1,col_no2}), mean(longdata.COPyR{1,col_no2}))
% plot(mean(longdata.COPxR{1,col_no3}), mean(longdata.COPyR{1,col_no3}))
% plot(mean(longdata.COPxR{1,col_no4}), mean(longdata.COPyR{1,col_no4}))
% legend('Laced','LR','Tri strap', 'X')