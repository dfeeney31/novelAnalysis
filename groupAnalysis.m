%%%%%%%%%%%% Script to calculate M-L trajectories frrom Novel %%%%%%%%%%%%%
%%%%%%%%%%%% Takes fgt files in alphabetical order 

clear
%cd 'C:\Users\Daniel.Feeney\Dropbox (Boa)\SensoriaFolder\StretchTesting'
cd 'C:\Users\Daniel.Feeney\Dropbox (Boa)\AgilityPerformance\AsicsTennis\SkaterFGT'
files = dir('*.fgt');
longdata = struct();

addpath('C:\Users\Daniel.Feeney\Documents\novel_data') 

step_size = 60;
counter_outside = 1;
for file = files'
   COP_dat = importfile(file.name);
    % Do some stuff
    clear counter_var filt_force locs pks zeros_1 
    
    % delimit the Right steps. This is still not fool-proof
    R_steps = zeros(1,20);
    counter = 1;
    for i = 1:(length(COP_dat.RForce)-1)
        if (COP_dat.RForce(i) < 60) && (COP_dat.RForce(i+1) > 90)
            R_steps(counter) = i;
            counter = counter + 1;
        end
    end
    R_steps = R_steps(R_steps~=0);
    
    % Repeat for the left side
    L_steps = zeros(1,20);
    counter = 1;
    for i = 1:(length(COP_dat.LForce)-1)
        if (COP_dat.LForce(i) < 60) && (COP_dat.LForce(i+1) > 100)
            L_steps(counter) = i;
            counter = counter + 1;
        end
    end
    L_steps = L_steps(L_steps~=0);
    
    %%%%% Stack the values into matrix for storing %%%%
    
    R_stepsCOP = R_steps +1; %increment by 1 index to avoid the 0,0 being plotted
    ForceR_stacked = zeros(length(R_steps),step_size+1);
    COPy_stackedR = zeros(length(R_steps), step_size+1);
    COPx_stackedR = zeros(length(R_steps), step_size+1);
    for step = 1:(length(R_steps) - 1)
        COPy_stackedR(step,:) = COP_dat.RCOPy(R_stepsCOP(step):R_stepsCOP(step)+step_size);
        COPx_stackedR(step,:) = COP_dat.RCOPx(R_stepsCOP(step):R_stepsCOP(step)+step_size);
        ForceR_stacked(step,:) = COP_dat.RForce(R_steps(step):R_steps(step)+step_size);
    end
    COPy_stackedR = COPy_stackedR(~any(COPy_stackedR == 0,2),:);
    COPx_stackedR = COPx_stackedR(~any(COPx_stackedR == 0,2),:);
    
    % Stack the values for left insole
    L_stepsCOP = L_steps + 1; %increment by 1 index to avoid the 0,0 being plotted
    COPy_stackedL = zeros(length(L_steps), step_size+1);
    COPx_stackedL = zeros(length(L_steps), step_size+1);
    for step = 1:(length(L_steps)-1)
        if ~any(COP_dat.LCOPy(L_stepsCOP(step):L_stepsCOP(step)+step_size))
            pass
        else
            COPy_stackedL(step,:) = COP_dat.LCOPy(L_stepsCOP(step):L_stepsCOP(step)+step_size);
            COPx_stackedL(step,:) = COP_dat.LCOPx(L_stepsCOP(step):L_stepsCOP(step)+step_size);
            ForceL_stacked(step,:) = COP_dat.LForce(L_steps(step):L_steps(step)+step_size);
        end
    end
    
    COPy_stackedL = COPy_stackedL(~any(COPy_stackedL == 0,2),:);
    COPx_stackedL = COPx_stackedL(~any(COPx_stackedL == 0,2),:);
    
    %Calcualte the peaks for M-L trajectory
    [pksR,locsL] = findpeaks(-1 * COP_dat.RCOPx); % find peaks but need to multiply by -1 to get the medial peak
    pksR = pksR(pksR ~=0); pksR = -1 * pksR; %Remove false 0 peaks and return back to the correct sign
    falsePeakValRHigh = 50; falsePeakValRLow = 30;
    pksR = pksR(pksR < falsePeakValRHigh);
    pksR = pksR(pksR > falsePeakValRLow);
    
    %Calculate the lateral peaks
    [LpksR,locsL] = findpeaks(COP_dat.RCOPx);
    LpksR = LpksR(LpksR > 50);
    
    % Left side
    [pksL,locsL] = findpeaks(-1 * COP_dat.LCOPx);
    pksL = pksL(pksL ~=0); pksL = -1 * pksL;
    falsePeakValLHigh = 50; falsePeakValLow = 30; 
    pksL = pksL(pksL < falsePeakValLHigh);
    pksL = pksL(pksL > falsePeakValLow);
    
    %Calculate the lateral peaks
    [LpksL,locsL] = findpeaks(COP_dat.LCOPx);
    LpksL = LpksL(LpksL > 50);
    
    %%%%%% Save the data of interest into a cell array
    longdata.name{counter_outside} = file.name;
    longdata.COPyL{counter_outside} = COPy_stackedL;
    longdata.COPxL{counter_outside} = COPx_stackedL;
    longdata.COPyR{counter_outside} = COPy_stackedR;
    longdata.COPxR{counter_outside} = COPx_stackedR;
    longdata.ForceR{counter_outside} = ForceR_stacked;
    longdata.ForceL{counter_outside} = ForceL_stacked;
    longdata.LMedPeak{counter_outside} = mean(pksL);
    longdata.RMedPeak{counter_outside} = mean(pksR);
    longdata.LLatPeak{counter_outside} = mean(LpksL);
    longdata.RLatPeak{counter_outside} = mean(LpksR);
    
    counter_outside = counter_outside + 1;
end


