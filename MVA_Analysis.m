%%%%% impot the MVA file, use force threshold and min step length to remove
%%%%% bad steps, calcualte the metrics, save output 
%%%% Columns 2-5 are left side, 6-9 are right side. 1 is time vector

clear
addpath('C:\Users\Daniel.Feeney\Documents\novel_data')

input_dir = 'C:\Users\Daniel.Feeney\Dropbox (Boa)\Hike Work Research\Data\NovelData';% Change to correct filepath

cd(input_dir)
files = dir('*.mva');
dataList = {files.name};
dataList = sort(dataList);
[f,~] = listdlg('PromptString','Select data files for all subjects in group','SelectionMode','multiple','ListString',dataList);
NumbFiles = length(f);

outputAllConfigs = {'SubName','Config','TrialNo','StepNo','force', 'pressure', 'meanPressure', 'FTI','StanceTime'};
%% Set constants
forceThresh = 180; %Force threshold
minStepLen = 20; %minimal step length

for s = 1:NumbFiles
    close all
    clearvars stepLengths2 takeoffsR landings falseSteps2 stepLengths takeoffs landingsR falseSteps
    
    %extract file metadata
    fileName = dataList{f(s)};
    fileLoc = [input_dir '\' fileName];
    dat = importMVA(fileLoc);
    
    splitFName = strsplit(fileName,'_'); subName = splitFName{1};
    configName = splitFName{2};
    trialNo = splitFName{4}(1);
   
    % Filter all force values below forceThresh to 0
    dat.forceN(dat.forceN < forceThresh) = 0;
    dat.forceN1(dat.forceN1 < forceThresh) = 0;
    
    % Trim the trial to be after the three stomps
    plot(dat.forceN1)
    disp('Select start and end of trial')
    [pos, locs] = ginput(2);
    pos(1) = floor(pos(1)); pos(2) = floor(pos(2));
    % new variables
    Lforce = dat.forceN(pos(1):pos(2)); Rforce = dat.forceN1(pos(1):pos(2));
    LMaxpressure = dat.maxpressure(pos(1):pos(2));RMaxpressure = dat.maxpressure1(pos(1):pos(2));
    LMeanpressure = dat.meanpressure(pos(1):pos(2));RMeanpressure = dat.meanpressure1(pos(1):pos(2));
    
    % delimit steps. Starting with left side.
    landings = zeros(1,20);
    counter = 1;
    for ind = 1:length(Lforce)-1
        
        if Lforce(ind) == 0 && Lforce(ind + 1) > 0
            landings(counter) = ind;
            counter = counter + 1;
        end
        
    end
    
    takeoffs = zeros(1,20);
    counter = 1;
    for ind = 1:length(Lforce)-1
        if Lforce(ind) > 0 && Lforce(ind + 1) == 0
            takeoffs(counter) = ind + 1;
            counter = counter + 1;
        end
    end
    % Trimming the first and last index if recording began with a takeoff or
    % landing
    if landings(1) > takeoffs(1)
        takeoffs(1) = [];
        landings(end) = [];
    end
    % trimming length
    if ~ (length(landings) == length(takeoffs))
        if landings(end) < takeoffs(end)
            takeoffs(end) = [];
        end
    end
    
    % Cleaning false steps on the left size with minStepLen
    stepLengths = takeoffs - landings;
    falseSteps = find(stepLengths < minStepLen);
    landings(falseSteps) = []; takeoffs(falseSteps) = []; stepLengths(falseSteps) = [];
    
    
    % Right side
    landingsR = zeros(1,20);
    counter = 1;
    for ind = 1:length(Rforce)-1
        
        if Rforce(ind) == 0 && Rforce(ind + 1) > forceThresh
            landingsR(counter) = ind;
            counter = counter + 1;
        end
        
    end
    
    takeoffsR = zeros(1,20);
    counter = 1;
    for ind = 1:length(Rforce)-1
        
        if Rforce(ind) > forceThresh && Rforce(ind + 1) == 0
            takeoffsR(counter) = ind + 1;
            counter = counter + 1;
        end

    end
    
    % Trimming the first and last index if recording began with a takeoff or
    % landing
    if landingsR(1) > takeoffsR(1)
        takeoffsR(1) = [];
        landingsR(end) = [];
    end
    
    % check for equal lengths and trim if not equal
    while ~ (length(landingsR) == length(takeoffsR))
        if landingsR(end) > takeoffsR(end)
            takeoffsR(end) = [];
        end
        if takeoffsR(1) < landingsR(1)
            takeoffsR(1) = [];
        end
    end
    
    % Cleaning false steps on the right size with minStepLen
    stepLengths2 = takeoffsR - landingsR;
    falseSteps2 = find(stepLengths2 < minStepLen);
    landingsR(falseSteps2) = []; takeoffs(falseSteps2) = [];
    
    % Extract features from left foot
    %Preallocation
    maxF = zeros(1,length(takeoffs));
    maxP = zeros(1,length(takeoffs));
    meanP = zeros(1,length(takeoffs));
    FTI = zeros(1,length(takeoffs));
    
    % loop through and extract
    for step = 1:(length(landings) - 1)
        try
            tmp_stepF = Lforce(landings(step):takeoffs(step));
            tmp_stepP = LMaxpressure(landings(step):takeoffs(step));
            tmp_stepmP = LMeanpressure(landings(step):takeoffs(step));
            [maxF(step), maxInd] = max(tmp_stepF);
            FTI(step) = sum(tmp_stepF);
            maxP(step) = max(tmp_stepP);
            meanP(step) = tmp_stepmP(maxInd);
        catch
            maxF(step) = 0;
            FTI(step) = 0;
            maxP(step) = 0;
            meanP(step) = 0;
        end
        
    end
    
    
    
    % Right foot
    %Preallocation
    maxFR = zeros(1,length(takeoffsR));
    maxPR = zeros(1,length(takeoffsR));
    meanPR = zeros(1,length(takeoffsR));
    FTIR = zeros(1,length(takeoffsR));
    
    % loop through and extract
    for step = 1:(length(landingsR) - 1)
        tmp_stepF = Rforce(landingsR(step):takeoffsR(step));
        tmp_stepP = RMaxpressure(landingsR(step):takeoffsR(step));
        tmp_stepmP = RMeanpressure(landingsR(step):takeoffsR(step));
        try
            [maxFR(step), MaxI2] = max(tmp_stepF);
            FTIR(step) = sum(tmp_stepF);
            maxPR(step) = max(tmp_stepP);
            meanPR(step) = tmp_stepmP(MaxI2);
        catch
            maxFR(step) = 0;
            FTIR(step) = 0;
            maxPR(step) = 0;
            meanPR(step) = 0;
        end
        
    end
    
%     fig=figure;
%     hax=axes;
%     plot(Rforce)
%     hold on
%     for i = 1:length(landingsR)
%         line([landingsR(i) landingsR(i)],get(hax,'YLim'),'Color',[1 0 0])
%         line([takeoffsR(i) takeoffsR(i)],get(hax,'YLim'))
%     end
    
    % Determine which foot fall was first
    
    forceLong = zeros(50,1);
    pressureLong = zeros(50,1);
    meanPressureLong = zeros(50,1);
    FTIlong = zeros(50,1);
    stanceLong = zeros(50,1);
    
    count = 1;
    for i = 1:2:(length(maxF) * 2)
        forceLong(i) = maxF(count);
        forceLong(i+1) = maxFR(count);
        pressureLong(i) = maxP(count);
        pressureLong(i+1) = maxPR(count);
        meanPressureLong(i) = meanP(count);
        meanPressureLong(i+1) = meanPR(count);
        FTIlong(i) = FTI(count);
        FTIlong(i+1) = FTIR(count);
        stanceLong(i) = stepLengths(count);
        stanceLong(i+1) = stepLengths2(count);
        
        count = count + 1;
    end
    
    %filter out 0 values from preallocation, reshape to correct size
    kinData = [forceLong, pressureLong, meanPressureLong, FTIlong, stanceLong];
    kinData = kinData(any(kinData,2),:);
    
    % metadata
    subNameTmp = cell(length(kinData),1); configNameTmp = cell(length(kinData),1); upDownTmp = cell(length(kinData),1);
    
    for i = 1:length(kinData)
        subNameTmp(i) = {subName};
        configNameTmp(i) = {configName};
        upDownTmp(i) = {trialNo};
    end
    stepNo = (1:length(kinData))';
    % Tidy up and add to previous data
    kinData = num2cell(kinData); stepNo = num2cell(stepNo);
    kinData = horzcat(subNameTmp,configNameTmp,upDownTmp,stepNo,kinData); %modulate this to subject name and config
    outputAllConfigs = vertcat(outputAllConfigs, kinData);
    
    if s == length(NumbFiles)
        close all
    end
    
end
%convert to table
T = cell2table(outputAllConfigs(2:end,:),'VariableNames',outputAllConfigs(1,:));
writetable(T,'BVhike1.csv')