# -*- coding: utf-8 -*-
"""
Created on Thu Jun  4 09:44:04 2020

@author: Daniel.Feeney
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

# Define constants and options
fThresh = 85; #below this value will be set to 0.
minStepLen = 10; #minimal step length
writeData = 0; #will write to spreadsheet if 1 entered
desiredStepLength = 20; #length to look forward after initial contact
apple = 0; #1 for apple 0 otherwise

# Read in file and add names
fPath = 'C:/Users/Daniel.Feeney/Dropbox (Boa)/Endurance Protocol Trail Run/Outdoor_Protocol_March2020/KH/'
entries = os.listdir(fPath)
fName = entries[2] #temporarily hard coding one file

dat = pd.read_csv(fPath+fName,sep='\t', skiprows = 4, header = 0)
dat.columns = ['Time', 'LeftHeel', 'LeftMedial','LeftLateral','Left','Time2','RightLateral','RightMedial','RightHeel','Right','pass']

subName = fName.split(sep = "_")[0]
config = fName.split(sep = "_")[1]
timePoint = fName.split(sep = "_")[2]


##### Filter force below threshold to 0 #####
LForce = dat.Left
LForce[LForce<fThresh] = 0

# delimit steps on left side
lic = []
count = 1;
for step in range(len(LForce)-1):
    if LForce[step] == 0 and LForce[step + 1] >= fThresh:
        lic.append(step)
        count = count + 1
#left toe off
lto = []
count = 1;
for step in range(len(LForce)-1):
    if LForce[step] >= fThresh and LForce[step + 1] == 0:
        lto.append(step + 1)
        count = count + 1

# Remove 0s from lists
lic = [s for s in lic if s != 0]
lto = [s for s in lto if s != 0]

# trim first contact/toe off if not a full step
if lic[0] > lto[0]:
    lto = np.delete(lto, [0])

    
if lic[-1] > lto[-1]:
    lic = lic[:-1]

### Calculate step lengths, remove steps that were too short and first three and last 2 steps
LStepLens = np.array(lto) - np.array(lic)
# remove first 3 and last two steps #
LStepLens = np.delete(LStepLens, [0,1,2])   #First 3
LStepLens = LStepLens[:-2]                  #Last 2
lic = np.delete(lic, [0,1,2])
lic = lic[:-2]
lto = np.delete(lto, [0,1,2])
lto = lto[:-2]

# Removing false steps
falseSteps = np.where(LStepLens < minStepLen) #Find indices to remove
# Remove all occurrences of elements below below minStepLen
LStepLens = LStepLens[ LStepLens > minStepLen ]
#Trim IC and TO for false steps
lic = np.delete(lic, falseSteps)
lto = np.delete(lto, falseSteps)

###### extract relevent features ###### 
LTot = []
LHeel = []
LLat = []
LMed = []
    
for landing in lic:
    LTot.append(LForce[landing:landing+desiredStepLength])
    LHeel.append(dat.LeftHeel[landing:landing+desiredStepLength])
    LLat.append(dat.LeftLateral[landing:landing+desiredStepLength])
    LMed.append(dat.LeftMedial[landing:landing+desiredStepLength])
noSteps = len(lic)
####
LeftMat = np.reshape(LTot, (noSteps,desiredStepLength))
LHeelMat = np.reshape(LHeel, (noSteps, desiredStepLength))
LLatMat = np.reshape(LLat, (noSteps, desiredStepLength))
LMedMat = np.reshape(LMed, (noSteps,desiredStepLength))

## plotting left side
fig, ax = plt.subplots(4)
for i in range(noSteps):
    ax[0].plot(LeftMat[i,:])
    ax[1].plot(LHeelMat[i,:])
    ax[2].plot(LLatMat[i,:])
    ax[3].plot(LMedMat[i,:])
    
ax[0].set_title('Total Left Force')
ax[1].set_title('Left Heel Force')
ax[2].set_title('Left Lateral Force')
ax[3].set_title('Left Medial Force')

#%%
#### Do the same thing for the right side #### 
##### Filter force below threshold to 0 #####
RForce = dat.Right
RForce[RForce<fThresh] = 0

# delimit steps on left side
ric = []
count = 1;
for step in range(len(LForce)-1):
    if LForce[step] == 0 and LForce[step + 1] >= fThresh:
        ric.append(step)
        count = count + 1
#left toe off
rto = []
count = 1;
for step in range(len(RForce)-1):
    if RForce[step] >= fThresh and RForce[step + 1] == 0:
        rto.append(step + 1)
        count = count + 1

# Remove 0s from lists
ric = [s for s in ric if s != 0]
rto = [s for s in rto if s != 0]
#%%
# trim first contact/toe off if not a full step
if ric[0] > rto[0]:
    rto = np.delete(rto, [0])

    
if ric[-1] > rto[-1]:
    ric = ric[:-1]

### Calculate step lengths, remove steps that were too short and first three and last 2 steps
RStepLens = np.array(rto) - np.array(ric)
# remove first 3 and last two steps #
RStepLens = np.delete(RStepLens, [0,1,2])   #First 3
RStepLens = RStepLens[:-2]                  #Last 2
ric = np.delete(ric, [0,1,2])
ric = ric[:-2]
rto = np.delete(rto, [0,1,2])
rto = rto[:-2]

# Removing false steps
falseSteps = np.where(RStepLens < minStepLen) #Find indices to remove
# Remove all occurrences of elements below below minStepLen
RStepLens = RStepLens[ RStepLens > minStepLen ]
#Trim IC and TO for false steps
ric = np.delete(ric, falseSteps)
rto = np.delete(rto, falseSteps)
#%%
###### extract relevent features ###### 
RTot = []
RHeel = []
RLat = []
RMed = []
    
for landing in lic:
    RTot.append(RForce[landing:landing+desiredStepLength])
    RHeel.append(dat.RightHeel[landing:landing+desiredStepLength])
    RLat.append(dat.RightLateral[landing:landing+desiredStepLength])
    RMed.append(dat.RightMedial[landing:landing+desiredStepLength])
noSteps = len(ric)
####
RightMat = np.reshape(RTot, (noSteps,desiredStepLength))
RHeelMat = np.reshape(RHeel, (noSteps, desiredStepLength))
RLatMat = np.reshape(RLat, (noSteps, desiredStepLength))
RMedMat = np.reshape(RMed, (noSteps,desiredStepLength))

## plotting left side
fig, ax = plt.subplots(4)
for i in range(noSteps):
    ax[0].plot(RightMat[i,:])
    ax[1].plot(RHeelMat[i,:])
    ax[2].plot(RLatMat[i,:])
    ax[3].plot(RMedMat[i,:])
    
ax[0].set_title('Total Right Force')
ax[1].set_title('Right Heel Force')
ax[2].set_title('Right Lateral Force')
ax[3].set_title('Right Medial Force')