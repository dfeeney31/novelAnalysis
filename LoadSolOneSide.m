%% Analysis of Novel Loadsol force insoles %%
clear
addpath('C:\Users\Daniel.Feeney\Documents\novel_data')
% The files should be named sub_balance_Config_trialNo - Forces.txt
%input_dir = 'C:\Users\Daniel.Feeney\Dropbox (Boa)\Endurance Protocol Trail Run\Outdoor_Protocol_March2020\DF';% Change to correct filepath
input_dir = 'C:\Users\Daniel.Feeney\Dropbox (Boa)\Hike Work Research\OutdoorProtocolMarch2020';% Change to correct filepath


cd(input_dir)
files = dir('*.txt');
dataList = {files.name};
dataList = sort(dataList);
[f,~] = listdlg('PromptString','Select data files for all subjects in group','SelectionMode','multiple','ListString',dataList);
NumbFiles = length(f);

outputAllConfigs = {'Subject','Config','UpDown','PrePost','stanceTime','PkTotal', 'ImpulseTotal', 'PkHeel', 'HeelImpulse',...
    'PkLat','LatImpulse','PkMed','MedImpulse','RateTotal'};

%Define constants and options
fThresh = 50; %below this value will be set to 0.
minStepLen = 20; %minimal step length
writeData = 1; %will write to spreadsheet
desiredStepLength = 70; %length to look forward for plotting and data gathering 

for s = 1:NumbFiles
    %% loop
    fileName = dataList{f(s)};
    fileLoc = [input_dir '\' fileName];
    dat = importDualBelt(fileLoc);
    
    splitFName = strsplit(fileName,'_'); 
    TimePointTmp = strsplit(splitFName{4},'.');
    sName = splitFName{1};
    Config = splitFName{2};
    UpDown = splitFName{3};
    TimePoint = TimePointTmp{1};
    
    dat = importLoadsol(fileLoc);
    dat.Properties.VariableNames = {'Time' 'RightLateral' 'RightMedial' 'RightHeel','Right','pass','pass1','pass2','pass3','pass4','toBePassed'};
    dat = dat(:,1:5);

    %% right side
      % Trim the trial to be after the three stomps
    plot(dat.Right)
    disp('Select start and end of trial')
    [pos, locs] = ginput(2);
    pos(1) = floor(pos(1)); pos(2) = floor(pos(2));
    
    % new variables
    RForce = dat.Right(pos(1):pos(2)); RForce(RForce<fThresh) = 0;
    RHeelNew = dat.RightHeel(pos(1):pos(2)); RLatNew = dat.RightLateral(pos(1):pos(2));
    RMedNew = dat.RightMedial(pos(1):pos(2));
    % delimit steps
    ric = zeros(15,1);
    count = 1;
    for step = 1:length(RForce)-1
        if (RForce(step) == 0 && RForce(step + 1) > fThresh)
            ric(count) = step;
            count = count + 1;
        end
    end
    
    rto = zeros(15,1);
    count = 1;
    for step = 1:length(RForce)-1
        if (RForce(step) > fThresh && RForce(step + 1) == 0)
            rto(count) = step + 1;
            count = count + 1;
        end
    end
    
    % Calculate step lengths, remove steps that were too short and first
    % three and last 2 steps
    RStepLens = rto - ric;
    falseStepsR = find(RStepLens < minStepLen);
    if ~ isempty(falseStepsR)
        ric(falseStepsR) = []; rto(falseStepsR) = []; RStepLens(falseStepsR) = [];
    end
    
    
    %remove first 3 and last 2. This can only be run once per iteration,
    %otherwise additional steps will be removed.
    vecLen = length(ric); %should be equal to rto and RStepLens too
    stepsToRem = [1,2,3,vecLen - 2, vecLen - 1];
    ric(stepsToRem) = []; rto(stepsToRem) = []; RStepLens(stepsToRem) = [];
    
    RTot = zeros(length(ric),desiredStepLength+1);
    RHeel = zeros(length(ric),desiredStepLength+1);
    RLat = zeros(length(ric),desiredStepLength+1);
    RMed = zeros(length(ric),desiredStepLength+1);
    
    for i = 1:(length(ric) - 1)
        RTot(i,:) = RForce(ric(i):ric(i)+desiredStepLength);
        RHeel(i,:) = RHeelNew(ric(i):ric(i)+desiredStepLength);
        RLat(i,:) = RLatNew(ric(i):ric(i)+desiredStepLength);
        RMed(i,:) = RMedNew(ric(i):ric(i)+desiredStepLength);
    end
    %% extract features from each step
    %right preallocation
    pkTotR = zeros(1,length(ric)); totImpulseR = zeros(1,length(ric)); 
    pkHeelR = zeros(1,length(ric)); heelImpulseR = zeros(1,length(ric));
    pkLatR = zeros(1,length(ric)); latImpulseR = zeros(1,length(ric));
    pkMedR = zeros(1,length(ric)); medImpulseR = zeros(1,length(ric));
    rateTotR = zeros(1,length(ric)); stanceTimeR = zeros(1,length(ric));
    Ir = zeros(1,length(ric));
    
    for step = 1:length(ric)
        %right
        [pkTotR(step), Ir(step)]= max(RTot(step,:)); totImpulseR(step) = sum(RTot(step,:));
        pkHeelR(step) = max(RHeel(step,:)); heelImpulseR(step) = sum(RHeel(step,:));
        pkLatR(step) = max(RLat(step,:)); latImpulseR(step) = sum(RLat(step,:));
        pkMedR(step) = max(RMed(step,:)); medImpulseR(step) = sum(RMed(step,:));
        rateTotR(step) = pkTotR(step) / (Ir(step)/100);
        tmpFR = RTot(step,:);
        stanceTimeR(step) = length(tmpFR(tmpFR>0));
    end
    
    %concatenate right features and remove 0 rows
    rightFeat = [stanceTimeR; pkTotR; totImpulseR; pkHeelR; heelImpulseR; pkLatR; latImpulseR; pkMedR; medImpulseR; rateTotR]';
    rightFeat = rightFeat(any(rightFeat,2),:); %removing row with all 0s
    rVecTmp = cell(length(rightFeat),1);
    for l = 1:length(rightFeat)
       rVecTmp(l) = {'r'}; 
    end
   %make vectors of left or right and configuration name to add into file  
    SNameTmp = cell(length(rVecTmp),1); %Subject name
    configNameTmp = cell(length(rVecTmp),1); %configuration name from early in the file
    UpDownTmp = cell(length(rVecTmp),1); %configuration name from early in the file
    PrePostTmp = cell(length(rVecTmp),1); %configuration name from early in the file
    for i = 1:length(rVecTmp)
        SNameTmp(i) = {sName};
        configNameTmp(i) = {Config};
        UpDownTmp(i) = {UpDown};
        PrePostTmp(i) = {TimePoint};
    end

    % clean up and concatenate
    kinData = rightFeat;
    kinData = num2cell(kinData);
    kinData = horzcat(SNameTmp, configNameTmp,UpDownTmp,PrePostTmp, kinData); %modulate this to subject name and config
    outputAllConfigs = vertcat(outputAllConfigs, kinData);
    
    clearvars LRtmp configNameTmp rightFeat leftFeat ric lic rto lto
end

% make a table for saving
if writeData == 1
    % Convert cell to a table and use first row as variable names
    T = cell2table(outputAllConfigs(2:end,:),'VariableNames',outputAllConfigs(1,:));
    % Write the table to a CSV file
    writetable(T,'DFtest.csv')
end
% 
%% make plots 
% figure(3)
% shadedErrorBar(0:desiredStepLength, RTot, {@mean, @std}, 'lineprops','blue');
% title('Total Force')
% % 
% figure(5)
% shadedErrorBar(0:desiredStepLength, RHeel, {@mean, @std},'lineprops', 'red')
% title('Right heel')
% % 
% figure(6)
% shadedErrorBar(0:desiredStepLength, RMed, {@mean, @std},'lineprops', 'red')
% title('Right medial forefoot')
% % 
% figure(7)
% shadedErrorBar(0:desiredStepLength, RLat, {@mean, @std},'lineprops', 'blue')
% title('Right lateral forefoot')