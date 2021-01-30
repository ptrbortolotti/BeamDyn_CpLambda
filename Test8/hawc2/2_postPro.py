import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
# Local 
import weio

from welib.fast.fastlib import find_matching_pattern, averageDF



# --- Parameters
BD_mainfile    = '../beamdyn/BAR3_BeamDyn.dat'
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
dfOut['TipTDxr_[m]'] = df['beam1N50yb_[m]']-y[-1]
dfOut['TipTDyr_[m]'] =-(df['beam1N50xb_[m]']-x[-1])
dfOut['TipTDzr_[m]'] = df['beam1N50zb_[m]']-z[-1]
dfOut['TipRDxr_[-]'] =-df['beam1N50rot_r2b_[-]'] #*180/np.pi
dfOut['TipRDyr_[-]'] = df['beam1N50rot_r1b_[-]'] #*180/np.pi
dfOut['TipRDzr_[-]'] = df['beam1N50rot_r3b_[-]'] #*180/np.pi


Map={
  1: 4,
  2: 9,
  3:15,
  4:20,
  5:25,
  6:30,
  7:35,
  8:40,
  9:45,
}
print(df.keys())

for k,v in Map.items():
    dfOut['N{}TDxr_[m]'.format(k)]  =   df['beam1N{}yb_[m]'   .format(v)]-y[-1]
    dfOut['N{}TDyr_[m]'.format(k)]  = -(df['beam1N{}xb_[m]'   .format(v)]-x[-1])
    dfOut['N{}TDzr_[m]'.format(k)]  =   df['beam1N{}zb_[m]'   .format(v)]-z[-1]
    dfOut['N{}Fxl_[N]' .format(k)]  =   df['beam1N{}Fyb_[kN]' .format(v)]*1000
    dfOut['N{}Fyl_[N]' .format(k)]  =  -df['beam1N{}Fxb_[kN]' .format(v)]*1000
    dfOut['N{}Fzl_[N]' .format(k)]  =   df['beam1N{}Fzb_[kN]' .format(v)]*1000
    dfOut['N{}Mxl_[N-m]'.format(k)] =   df['beam1N{}Myb_[kNm]'.format(v)]*1000
    dfOut['N{}Myl_[N-m]'.format(k)] =  -df['beam1N{}Mxb_[kNm]'.format(v)]*1000
    dfOut['N{}Mzl_[N-m]'.format(k)] =   df['beam1N{}Mzb_[kNm]'.format(v)]*1000


dfOut['RootFxr_[N]'  ] =   df['beam1N{}Fyb_[kN]' .format(1)]*1000
dfOut['RootFyr_[N]'  ] =  -df['beam1N{}Fxb_[kN]' .format(1)]*1000
dfOut['RootFzr_[N]'  ] =   df['beam1N{}Fzb_[kN]' .format(1)]*1000
dfOut['RootMxr_[N-m]'] =   df['beam1N{}Myb_[kNm]'.format(1)]*1000
dfOut['RootMyr_[N-m]'] =  -df['beam1N{}Mxb_[kNm]'.format(1)]*1000
dfOut['RootMzr_[N-m]'] =   df['beam1N{}Mzb_[kNm]'.format(1)]*1000



dfOut.to_csv('BAM3.csv', index=False, sep='\t')




# 
#      3         3         7.25391E-02       0.00000E+00       6.89634E+00
#      6         6         2.35457E-01       0.00000E+00       1.72408E+01
#      9         9         3.36077E-01       0.00000E+00       2.75852E+01
#     12        12         2.85457E-01       0.00000E+00       3.79296E+01
#     15        15         4.12202E-02       0.00000E+00       4.82741E+01
#     18        18        -4.05861E-01       0.00000E+00       5.86185E+01
#     21        21        -1.04532E+00       0.00000E+00       6.89629E+01
#     24        24        -1.86043E+00       0.00000E+00       7.93074E+01
#     27        27        -2.84165E+00       0.00000E+00       8.96519E+01
# 
#       sec    4	-0.000000e+00	 4.377470e-02	 6.122220e+00	 1.756440e+01;  N1
#       sec    9	-0.000000e+00	 2.233910e-01	 1.632590e+01	 1.236440e+01;
#       sec   15	-0.000000e+00	 3.563250e-01	 2.857040e+01	 5.068490e+00;
#       sec   20	-0.000000e+00	 2.531470e-01	 3.877410e+01	 5.017180e+00;
#       sec   25	-0.000000e+00	 1.176130e-02	 4.897780e+01	 4.489440e+00;
#       sec   30	-0.000000e+00	-4.254250e-01	 5.918150e+01	 2.995440e+00;
#       sec   35	-0.000000e+00	-1.072980e+00	 6.938520e+01	 1.823820e+00;
#       sec   40	-0.000000e+00	-1.884480e+00	 7.958890e+01	-4.885640e-01;
#       sec   45	-0.000000e+00	-2.858300e+00	 8.979260e+01	-2.923610e+00;






if __name__ == '__main__':
    pass
