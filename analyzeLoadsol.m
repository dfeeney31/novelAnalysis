%% Analysis of Novel Loadsol force insoles %%
clear
addpath('C:\Users\Daniel.Feeney\Documents\novel_data')
dat = importLoadsol('C:\Users\Daniel.Feeney\Dropbox (Boa)\Endurance Protocol Trail Run\Outdoor_Protocol_March2020\DF\DD_pre_1.txt');
dat.Properties.VariableNames = {'Time' 'LeftHeel' 'LeftMedial' 'LeftLateral','Left','Time2','RightLateral','RightMedial','RightHeel','Right','toBePassed'};
dat = dat(:,1:10);

%Define constants
fThresh = 50; %below this value will be set to 0.
minStepLen = 10; %minimal step length
%% plotting
% figure
% plot(dat.LeftHeel)
% hold on
% title('Left Insole')
% plot(dat.LeftLateral)
% plot(dat.LeftMedial)
% plot(dat.Left, 'LineWidth',2)
% legend('Heel','Lateral','Medial','Total')
% 
% figure
% plot(dat.RightHeel)
% hold on
% title('Right Insole')
% plot(dat.RightLateral)
% plot(dat.RightMedial)
% plot(dat.Right, 'LineWidth',2)
% legend('Heel','Lateral','Medial','Total')

%% left side
LForce = dat.Left; LForce(LForce<fThresh) = 0;

% delimit steps
lic = zeros(15,1);
count = 1;
for step = 1:length(LForce)-1
    if (LForce(step) == 0 & LForce(step + 1) > fThresh)
        lic(count) = step;
        count = count + 1;
    end
end

lto = zeros(15,1);
count = 1;
for step = 1:length(LForce)-1
    if (LForce(step) > fThresh & LForce(step + 1) == 0)
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
    LTot(i,:) = LForce(lic(i):lic(i)+20);
    LHeel(i,:) = dat.LeftHeel(lic(i):lic(i)+20);
    LLat(i,:) = dat.LeftLateral(lic(i):lic(i)+20);
    LMed(i,:) = dat.LeftMedial(lic(i):lic(i)+20);
end
%% right side
RForce = dat.Right; RForce(RForce<fThresh) = 0;

% delimit steps
ric = zeros(15,1);
count = 1;
for step = 1:length(RForce)-1
    if (RForce(step) == 0 & RForce(step + 1) > fThresh)
        ric(count) = step;
        count = count + 1;
    end
end

rto = zeros(15,1);
count = 1;
for step = 1:length(RForce)-1
    if (RForce(step) > fThresh & RForce(step + 1) == 0)
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
    Ric(falseStepsR) = []; rto(falseStepsR) = []; RStepLens(falseStepsR) = [];
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
    RTot(i,:) = RForce(ric(i):ric(i)+20);
    RHeel(i,:) = dat.RightHeel(ric(i):ric(i)+20);
    RLat(i,:) = dat.RightLateral(ric(i):ric(i)+20);
    RMed(i,:) = dat.RightMedial(ric(i):ric(i)+20);
end


%% make plots 
figure(3)
shadedErrorBar(0:20, LTot, {@mean, @std}, 'lineprops','blue');
hold on
shadedErrorBar(0:20, RTot, {@mean, @std}, 'lineprops','red');
title('Total Force')

figure(5)
shadedErrorBar(0:20, LHeel, {@mean, @std},'lineprops', 'blue')
hold on
shadedErrorBar(0:20, RHeel, {@mean, @std},'lineprops', 'red')
title('left (blue) vs. right (red) heel')

figure(6)
shadedErrorBar(0:20, LMed, {@mean, @std},'lineprops', 'blue')
hold on
shadedErrorBar(0:20, RMed, {@mean, @std},'lineprops', 'red')
title('left (blue) vs. right (red) medial forefoot')

figure(7)
shadedErrorBar(0:20, LLat, {@mean, @std},'lineprops', 'blue')
hold on
shadedErrorBar(0:20, RLat, {@mean, @std},'lineprops', 'red')
title('left (blue) vs. right (red) lateral forefoot')