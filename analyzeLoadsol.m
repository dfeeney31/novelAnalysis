%% Analysis of Novel Loadsol force insoles %%
clear
addpath('C:\Users\Daniel.Feeney\Documents\novel_data')
% The files should be named sub_balance_Config_trialNo - Forces.txt
input_dir = 'C:\Users\Daniel.Feeney\Dropbox (Boa)\Endurance Protocol Trail Run\Outdoor_Protocol_March2020\KH';% Change to correct filepath
%input_dir = 'C:\Users\Daniel.Feeney\Dropbox (Boa)\Hike Work Research\OutdoorProtocolMarch2020';% Change to correct filepath


cd(input_dir)
files = dir('*.txt');
dataList = {files.name};
dataList = sort(dataList);
[f,~] = listdlg('PromptString','Select data files for all subjects in group','SelectionMode','multiple','ListString',dataList);
NumbFiles = length(f);

outputAllConfigs = {'Config','TrialNo','Side','PrePost','stanceTime','PkTotal', 'ImpulseTotal', 'PkHeel', 'HeelImpulse',...
    'PkLat','LatImpulse','PkMed','MedImpulse','RateTotal'};

%Define constants and options
fThresh = 50; %below this value will be set to 0.
minStepLen = 10; %minimal step length
writeData = 1; %will write to spreadsheet
desiredStepLength = 20; %length to look forward after initial contact
apple = 0; %1 for apple 2 for Android

for s = 1:NumbFiles
    %% loop
    fileName = dataList{f(s)};
    fileLoc = [input_dir '\' fileName];
   
    if apple == 1
        dat = importLoadsol(fileLoc);
        dat.Properties.VariableNames = {'Time' 'LeftHeel' 'LeftMedial' 'LeftLateral','Left','Time2','RightLateral','RightMedial','RightHeel','Right','toBePassed'};

    else
        dat = importLoadsolAndroid(fileLoc);
        dat.Properties.VariableNames = {'Time' 'LeftHeel' 'LeftMedial' 'LeftLateral','Left','Time2','RightLateral','RightMedial','RightHeel','Right',...
            'toBePassed', 'pass2','pass3','pass4','pass5'};

    end

    dat = dat(:,1:10);
    
    splitFName = strsplit(fileName,'_'); configName = splitFName{2};
    trialNo = splitFName{4}(1); PrePost = splitFName{3};
    
    %% left side
    LForce = dat.Left; LForce(LForce<fThresh) = 0;
    
    % delimit steps
    lic = zeros(15,1);
    count = 1;
    for step = 1:length(LForce)-1
        if (LForce(step) == 0 && LForce(step + 1) >= fThresh)
            lic(count) = step;
            count = count + 1;
        end
    end
    
    lto = zeros(15,1);
    count = 1;
    for step = 1:length(LForce)-1
        if (LForce(step) >= fThresh && LForce(step + 1) == 0)
            lto(count) = step + 1;
            count = count + 1;
        end
    end
    % trim first contact/toe off if not a full step
    if (lic(1) > lto(1))
        lto(1) = [];
    end
    lic(lic == 0) = []; lto(lto == 0) = [];
    
    if (lic(end) > lto(end))
        lic(end) = [];
    end

    % Calculate step lengths, remove steps that were too short and first
    % three and last 2 steps
    LStepLens = lto - lic;
    falseSteps = find(LStepLens < minStepLen);
    lic(falseSteps) = []; lto(falseSteps) = []; LStepLens(falseSteps) = [];
    
    %remove first 3 and last 2. This can only be run once per iteration,
    %otherwise additional steps will be removed.
    vecLen = length(lic); %should be equal to lto and LStepLens too
    stepsToRem = [1,2,3,vecLen - 2, vecLen - 1];
    lic(stepsToRem) = []; lto(stepsToRem) = []; LStepLens(stepsToRem) = [];
    
    LTot = zeros(length(lic),21);
    LHeel = zeros(length(lic),21);
    LLat = zeros(length(lic),21);
    LMed = zeros(length(lic),21);
    
    for i = 1:(length(lic) - 1)
        LTot(i,:) = LForce(lic(i):lic(i)+desiredStepLength);
        LHeel(i,:) = dat.LeftHeel(lic(i):lic(i)+desiredStepLength);
        LLat(i,:) = dat.LeftLateral(lic(i):lic(i)+desiredStepLength);
        LMed(i,:) = dat.LeftMedial(lic(i):lic(i)+desiredStepLength);
    end
    %% right side
    RForce = dat.Right; RForce(RForce<fThresh) = 0;
    
    % delimit steps
    ric = zeros(15,1);
    count = 1;
    for step = 1:length(RForce)-1
        if (RForce(step) == 0 && RForce(step + 1) >= fThresh)
            ric(count) = step;
            count = count + 1;
        end
    end
    
    rto = zeros(15,1);
    count = 1;
    for step = 1:length(RForce)-1
        if (RForce(step) >= fThresh && RForce(step + 1) == 0)
            rto(count) = step + 1;
            count = count + 1;
        end
    end
    % trim first contact/toe off if not a full step
    if (ric(1) > rto(1))
        rto(1) = [];
    end
    ric(ric == 0) = []; rto(rto == 0) = [];
    
    if (ric(end) > rto(end))
        ric(end) = [];
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
    
    RTot = zeros(length(ric),21);
    RHeel = zeros(length(ric),21);
    RLat = zeros(length(ric),21);
    RMed = zeros(length(ric),21);
    
    for i = 1:(length(ric) - 1)
        RTot(i,:) = RForce(ric(i):ric(i)+desiredStepLength);
        RHeel(i,:) = dat.RightHeel(ric(i):ric(i)+desiredStepLength);
        RLat(i,:) = dat.RightLateral(ric(i):ric(i)+desiredStepLength);
        RMed(i,:) = dat.RightMedial(ric(i):ric(i)+desiredStepLength);
    end
    %% extract features from each step
    %left preallocation
    pkTot = zeros(1,length(lic)); totImpulse = zeros(1,length(lic)); 
    pkHeel = zeros(1,length(lic)); heelImpulse = zeros(1,length(lic));
    pkLat = zeros(1,length(lic)); latImpulse = zeros(1,length(lic));
    pkMed = zeros(1,length(lic)); medImpulse = zeros(1,length(lic));
    rateTot = zeros(1,length(lic)); stanceTime = zeros(1,length(lic));
    I = zeros(1,length(lic));
    %right preallocation
    pkTotR = zeros(1,length(ric)); totImpulseR = zeros(1,length(ric)); 
    pkHeelR = zeros(1,length(ric)); heelImpulseR = zeros(1,length(ric));
    pkLatR = zeros(1,length(ric)); latImpulseR = zeros(1,length(ric));
    pkMedR = zeros(1,length(ric)); medImpulseR = zeros(1,length(ric));
    rateTotR = zeros(1,length(ric)); stanceTimeR = zeros(1,length(ric));
    Ir = zeros(1,length(ric));
    
    for step = 1:length(lic)
        %left
        [pkTot(step), I(step)]= max(LTot(step,:)); totImpulse(step) = sum(LTot(step,:));
        pkHeel(step) = max(LHeel(step,:)); heelImpulse(step) = sum(LHeel(step,:));
        pkLat(step) = max(LLat(step,:)); latImpulse(step) = sum(LLat(step,:));
        pkMed(step) = max(LMed(step,:)); medImpulse(step) = sum(LMed(step,:));
        rateTot(step) = pkTot(step) / (I(step)/100);
        tmpF = LTot(step,:);
        stanceTime(step) = length(tmpF(tmpF>0));
        %right
        [pkTotR(step), Ir(step)]= max(RTot(step,:)); totImpulseR(step) = sum(RTot(step,:));
        pkHeelR(step) = max(RHeel(step,:)); heelImpulseR(step) = sum(RHeel(step,:));
        pkLatR(step) = max(RLat(step,:)); latImpulseR(step) = sum(RLat(step,:));
        pkMedR(step) = max(RMed(step,:)); medImpulseR(step) = sum(RMed(step,:));
        rateTotR(step) = pkTotR(step) / (Ir(step)/100);
        tmpFR = RTot(step,:);
        stanceTimeR(step) = length(tmpFR(tmpFR>0));
    end
    
    %concatenate left features and remove 0 rows
    leftFeat = [stanceTime; pkTot; totImpulse; pkHeel; heelImpulse; pkLat; latImpulse; pkMed; medImpulse; rateTot]';
    leftFeat = leftFeat(any(leftFeat,2),:); %removing row with all 0s

    %concatenate right features and remove 0 rows
    rightFeat = [stanceTimeR; pkTotR; totImpulseR; pkHeelR; heelImpulseR; pkLatR; latImpulseR; pkMedR; medImpulseR; rateTotR]';
    rightFeat = rightFeat(any(rightFeat,2),:); %removing row with all 0s

    %%%%%%%%%
    kinData = [leftFeat; rightFeat];
    %
    rVecTmp = cell(size(rightFeat,1),1);
    for l = 1:length(rVecTmp)
       rVecTmp(l) = {'r'}; 
    end
    
    lVecTmp = cell(size(leftFeat,1),1);
    for l = 1:length(lVecTmp)
       lVecTmp(l) = {'l'}; 
    end
    %%%%%%%%%%%%%
   %make vectors of left or right and configuration name to add into file
    LRtmp = vertcat(lVecTmp, rVecTmp); %left or right side into a vector
    configNameTmp = cell(length(LRtmp),1); %configuration name from early in the file
    trialNoTmp = cell(length(LRtmp),1); %configuration name from early in the file
    PrePostTmp = cell(length(LRtmp),1); %configuration name from early in the file
    for i = 1:length(LRtmp)
        configNameTmp(i) = {configName};
        trialNoTmp(i) = {trialNo};
        PrePostTmp(i) = {PrePost};
    end
    
    % clean up and concatenate
    kinData = [leftFeat; rightFeat];
    kinData = num2cell(kinData);
    kinData = horzcat(configNameTmp,trialNoTmp,LRtmp, PrePostTmp, kinData); %modulate this to subject name and config
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
% %% make plots 
% figure(3)
% shadedErrorBar(0:desiredStepLength, LTot, {@mean, @std}, 'lineprops','blue');
% hold on
% shadedErrorBar(0:desiredStepLength, RTot, {@mean, @std}, 'lineprops','red');
% title('Total Force')
% 
% figure(5)
% shadedErrorBar(0:desiredStepLength, LHeel, {@mean, @std},'lineprops', 'blue')
% hold on
% shadedErrorBar(0:desiredStepLength, RHeel, {@mean, @std},'lineprops', 'red')
% title('left (blue) vs. right (red) heel')
% 
% figure(6)
% shadedErrorBar(0:desiredStepLength, LMed, {@mean, @std},'lineprops', 'blue')
% hold on
% shadedErrorBar(0:desiredStepLength, RMed, {@mean, @std},'lineprops', 'red')
% title('left (blue) vs. right (red) medial forefoot')
% 
% figure(7)
% shadedErrorBar(0:desiredStepLength, LLat, {@mean, @std},'lineprops', 'blue')
% hold on
% shadedErrorBar(0:desiredStepLength, RLat, {@mean, @std},'lineprops', 'red')
% title('left (blue) vs. right (red) lateral forefoot')