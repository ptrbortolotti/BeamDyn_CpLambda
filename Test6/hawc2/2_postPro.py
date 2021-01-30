import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
# Local 
import weio

from welib.fast.fastlib import find_matching_pattern, averageDF



# --- Parameters
BD_mainfile    = '../beamdyn/solid_beam_BeamDyn.dat'
simDir='./'

# --- Derived params
bdLine = weio.read(BD_mainfile).toDataFrame()
kp_x  = bdLine['kp_xr_[m]'].values
kp_y  = bdLine['kp_yr_[m]'].values
# Hawc2 = BeamDyn
x = -kp_y
y  = kp_x
z  = bdLine['kp_zr_[m]'].values
nSpan=len(z)

df = weio.read('sim.dat').toDataFrame()
dfOut = pd.DataFrame()
dfOut['Time_[s]']    = df['Time_[s]']
dfOut['TipTDxr_[m]'] = (df['beam1N46yb_[m]']-y[-1])
dfOut['TipTDyr_[m]'] =-(df['beam1N46xb_[m]']-x[-1])
dfOut['TipTDzr_[m]'] = df['beam1N46zb_[m]']-z[-1]
dfOut['TipRDxr_[-]'] =-df['beam1N46rot_r2b_[-]'] #*180/np.pi
dfOut['TipRDyr_[-]'] = df['beam1N46rot_r1b_[-]'] #*180/np.pi
dfOut['TipRDzr_[-]'] = df['beam1N46rot_r3b_[-]'] #*180/np.pi

dfOut.to_csv('solid_beam_driver.csv', index=False, sep='\t')





if __name__ == '__main__':
    pass
