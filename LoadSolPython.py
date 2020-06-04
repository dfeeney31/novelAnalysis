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
fThresh = 50; #below this value will be set to 0.
minStepLen = 10; #minimal step length
writeData = 0; #will write to spreadsheet if 1 entered
desiredStepLength = 20; #length to look forward after initial contact
apple = 0; #1 for apple 0 otherwise

# Read in file and add names
fPath = 'C:/Users/Daniel.Feeney/Dropbox (Boa)/Endurance Protocol Trail Run/Outdoor_Protocol_March2020/KH/'
entries = os.listdir(fPath)
fName = entries[1] #temporarily hard coding one file

dat = pd.read_csv(fPath+fName,sep='\t', skiprows = 4, header = 0)
dat.columns = ['Time', 'LeftHeel', 'LeftMedial','LeftLateral','Left','Time2','RightLateral','RightMedial','RightHeel','Right','pass']

subName = fName.split(sep = "_")[0]
config = fName.split(sep = "_")[1]
timePoint = fName.split(sep = "_")[2]

##### Filter force below threshold to 0 #####
LForce = dat.Left
LForce[LForce<fThresh] = 0
plt.plot(LForce)

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

