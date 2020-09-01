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

# Read in files
# only read .asc files for this work
fPath = 'C:/Users/Daniel.Feeney/Dropbox (Boa)/EndurancePerformance/SalomonQuicklace_Aug2020/Joe_Pressure_Data/'
fileExt = r".csv"
entries = [fName for fName in os.listdir(fPath) if fName.endswith(fileExt)]
fThresh = 200; #below this value will be set to 0.

# hard code a single entry for now
BOAfile = entries[0]
boa = pd.read_csv(fPath+BOAfile, header = 0)
boa.columns = ['Time', 'ToeForce', 'ToeMaxP', 'ToeMeanP', 'Toe%mean', 'LatFFForce','LatFMaxP','LatFMeanP','LatF%mean',
               'HeelForce','HeelMaxP','HeelMeanP','Heel%mean','MedFForce','MedFMaxP','MedFMeanP','MedF%mean',
               'LatMFForce','LatMFMaxP', 'LatMFMeanP', 'LatMF%mean', 'MedMFForce', 'MedMFMaxP', 'MedMFMeanP', 'MedMF%mean']
boa['totalForce'] = boa['ToeForce'] + boa['LatFFForce'] + boa['HeelForce'] + boa['MedFForce'] + boa['LatMFForce'] + boa['MedMFForce']

force = np.array(boa['totalForce'])
force[force<fThresh] = 0

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


ric_initial = findLandings(force)
rto_initial = findTakeoffs(force)

ric = trimLandings(ric_initial, rto_initial)
rto = trimTakeoffs(ric, rto_initial) #Error here