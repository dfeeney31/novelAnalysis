# -*- coding: utf-8 -*-
"""
Created on Tue Sep  1 16:22:27 2020

@author: Daniel.Feeney
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
from scipy.misc import electrocardiogram
from scipy.signal import find_peaks
import seaborn as sns

# list of functions 
# finding landings on the force plate once the filtered force exceeds the force threshold
def findLandings(force):
    ric = []
    for step in range(len(force)-1):
        if force[step] == 0 and force[step + 1] >= fThresh:
            ric.append(step)
    return ric

#Find takeoff from FP when force goes from above thresh to 0
def findTakeoffs(force):
    rto = []
    for step in range(len(force)-1):
        if force[step] >= fThresh and force[step + 1] == 0:
            rto.append(step + 1)
    return rto

def trimLandings(landings, takeoffs):
    trimTakeoffs = landings
    if len(takeoffs) > len(landings) and takeoffs[0] > landings[0]:
        del(trimTakeoffs[0])
    return(trimTakeoffs)

def trimTakeoffs(landings, takeoffs):
    if len(takeoffs) < len(landings):
        del(landings[-1])
    return(landings)
# Read in files
# only read .asc files for this work
fPath = 'C:/Users/Daniel.Feeney/Dropbox (Boa)/EndurancePerformance/SalomonQuicklace_Aug2020/Joe_Pressure_Data/'
fileExt = r".csv"
entries = [fName for fName in os.listdir(fPath) if fName.endswith(fileExt)]
fThresh = 200; #below this value will be set to 0.

# hard code a single entry for now
#BOAfile = entries[0]

## Preallocate lists
fileName = []
peakToeP = []
meanToeP = []
peakLFFP = []
meanLFFP = []
peakMFFP = []
meanMFFP = []
peakLMFP = []
meanLMFP = []
peakMMFP = []
meanMMFP = []


for file in entries:
    try:
        # Read in a single file as pandas DF, calc total force
        fName = file #Load one file at a time
        boa = pd.read_csv(fPath+fName, header = 0)
        boa.columns = ['Time', 'ToeForce', 'ToeMaxP', 'ToeMeanP', 'Toe%mean', 'LatFFForce','LatFMaxP','LatFMeanP','LatF%mean',
               'HeelForce','HeelMaxP','HeelMeanP','Heel%mean','MedFForce','MedFMaxP','MedFMeanP','MedF%mean',
               'LatMFForce','LatMFMaxP', 'LatMFMeanP', 'LatMF%mean', 'MedMFForce', 'MedMFMaxP', 'MedMFMeanP', 'MedMF%mean']
        boa['totalForce'] = boa['ToeForce'] + boa['LatFFForce'] + boa['HeelForce'] + boa['MedFForce'] + boa['LatMFForce'] + boa['MedMFForce']

## For automation, cutoff the force below the threshold to define approximate landings
        force = np.array(boa['totalForce'])
        force[force<fThresh] = 0
        ric = findLandings(force)
        
        # Loop through the landings
        for landing in ric:
            try:
                fileName.append(fName)
                peakToeP.append(np.max(boa['ToeMaxP'][landing:landing+20]))
                meanToeP.append(np.max(boa['ToeMeanP'][landing:landing+20])/np.max(boa['ToeMaxP'][landing:landing+20]))
                peakLFFP.append(np.max(boa['LatFMaxP'][landing:landing+20]))
                meanLFFP.append(np.max(boa['LatFMeanP'][landing:landing+20])/np.max(boa['LatFMaxP'][landing:landing+20]))
                peakMFFP.append(np.max(boa['MedFMaxP'][landing:landing+20]))
                meanMFFP.append(np.max(boa['MedFMeanP'][landing:landing+20])/np.max(boa['MedFMaxP'][landing:landing+20]))
                peakLMFP.append(np.max(boa['LatMFMaxP'][landing:landing+20]))
                meanLMFP.append(np.max(boa['LatMFMeanP'][landing:landing+20])/np.max(boa['LatMFMaxP'][landing:landing+20]))  
                peakMMFP.append(np.max(boa['MedMFMaxP'][landing:landing+20]))
                meanMMFP.append(np.max(boa['MedMFMeanP'][landing:landing+20])/np.max(boa['MedMFMaxP'][landing:landing+20]))  
            except:
                print(landing)
                
    except:
        print(file)
 
       
outcomes = pd.DataFrame({'fName':list(fileName),'ToeMaxP':list(peakToeP), 'meanToeP': list(meanToeP), 'PeakLFFP': list(peakLFFP),
                 'meanLFFP': list(meanLFFP), 'peakMFFP': list(peakMFFP),'meanMFFP': list(meanMFFP), 'peakLMFP':list(peakLMFP),
                 'meanLMFP':list(meanLMFP), 'peakMMFP':list(peakMMFP), 'meanMMFP':list(meanMMFP)})

filt_outcomes = outcomes.loc[outcomes['ToeMaxP'] > 100]
    
ax = sns.boxplot(y='ToeMaxP', x='fName', 
                 data=filt_outcomes, 
                 palette="colorblind")
ax.set(xlabel='Condition', ylabel='Max Toe Pressure')

ax2 = sns.boxplot(y='meanToeP', x='fName', 
                 data=filt_outcomes, 
                 palette="colorblind")
ax2.set(xlabel='Condition', ylabel='Mean/Max Toe Pressure')

sns.boxplot(y='PeakLFFP', x='fName', 
                 data=filt_outcomes, 
                 palette="colorblind")

sns.boxplot(y='peakMFFP', x='fName', 
                 data=filt_outcomes, 
                 palette="colorblind")

sns.boxplot(y='peakLMFP', x='fName', 
                 data=filt_outcomes, 
                 palette="colorblind")

sns.boxplot(y='peakMMFP', x='fName', 
                 data=filt_outcomes, 
                 palette="colorblind")