# -*- coding: utf-8 -*-
"""
Created on Tue Aug 11 09:49:21 2020

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
fPath = 'C:/Users/Daniel.Feeney/Dropbox (Boa)/Snow Protocol/InLabPressures/NovelData/'
fileExt = r".asc"
entries = [fName for fName in os.listdir(fPath) if fName.endswith(fileExt)]

# Import data. Hard coded for now
# All values are pressure in kPa
BOAfile = entries[11]
boa = pd.read_csv(fPath+BOAfile, delim_whitespace=True, skiprows = 9, header = 0)
boa = boa.iloc[:,100:199]

Bucklefile = entries[13]
buckle = pd.read_csv(fPath+Bucklefile, delim_whitespace=True, skiprows = 9, header = 0)
buckle = buckle.iloc[:,100:199]

# Feature engineering mean, SD, and CV across entire boot
boa['Mean'] = boa.mean(axis=1)
buckle['Mean'] = buckle.mean(axis=1)
boa['SD'] = boa.std(axis=1)
buckle['SD'] = buckle.std(axis=1)
boa['CV'] = boa['SD'] / boa['Mean'] 
buckle['CV'] = buckle['SD'] / buckle['Mean']

CTboa = []
for row in range(len(boa)):
    CTboa.append(np.count_nonzero(np.array(boa.iloc[row,:])))
    
CTbuckle = []
for row in range(len(buckle)):
    CTbuckle.append(np.count_nonzero(np.array(buckle.iloc[row,:])))
plt.plot(CTbuckle)

f, (ax0, ax1, ax2) = plt.subplots(1,3)
ax0.plot(buckle['Mean'])
ax0.plot(boa['Mean'])
ax0.title.set_text('Mean Pressure')

ax1.plot(buckle['SD'])
ax1.plot(boa['SD'])
ax1.title.set_text('SD Pressure')

ax2.plot(buckle['CV'])
ax2.plot(boa['CV'])
ax2.title.set_text('CV Pressure')
ax2.legend(['Buckles','BOA'])
plt.tight_layout()
plt.legend(['Buckles','BOA'])


print(boa['Mean'].mean())
print(buckle['Mean'].mean())
print(boa['SD'].mean())
print(buckle['SD'].mean())
print(boa['CV'].mean())
print(buckle['CV'].mean())
print(np.array(CTboa).max())
print(np.array(CTbuckle).max())
print(np.array(CTboa).max() - np.array(CTboa).min())
print(np.array(CTbuckle).max()- np.array(CTbuckle).min())
