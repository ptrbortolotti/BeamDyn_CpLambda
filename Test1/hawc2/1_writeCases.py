import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
# Local 
from shutil import copyfile
from welib.fast.beamdyn import BeamDyn2Hawc2

# --- Parameters
simDir='cases'
HAWC2='hawc2'
BD_mainfile    = '../bd_static_load_conv/f_1.5e6/solid_beam_BeamDyn.dat'
BD_bladefile   = '../bd_static_load_conv/solid_beam_BeamDyn_Blade.dat'
H2_htcfile_old = './template.htc'
H2_htcfile_new = os.path.join(simDir,'default.htc')
H2_stfile      = os.path.join(simDir,'solid_beam_st.st')
vf=[1.5e6 ,1e4 ,1e5 ,1e6 ,1e7 ,2.5e6 ,2e4 ,2e5 ,2e6 ,3e6 ,4e4 ,4e5 ,4e6 ,6e4 ,6e5 ,6e6 ,8e4 ,8e5 ,8e6] 

# --- First create default htc and st file (BeamDyn to hawc2)
try:
    os.mkdir(simDir)
except:
    pass
copyfile(H2_htcfile_old, H2_htcfile_new)
BeamDyn2Hawc2(BD_mainfile, BD_bladefile, H2_htcfile_new, H2_stfile, 'beam1', A=None, E=None, G=None)

# --- Then create all htc files with tip load
simfiles=[]
simfiles_rel=[]
for isim, load in enumerate(vf):
    # Copy htc file from default
    H2_htcfile_sim = H2_htcfile_new.replace('default.htc', 'f_{:5.1e}.htc'.format(load))
    copyfile(H2_htcfile_new, H2_htcfile_sim)

    simfiles.append(H2_htcfile_sim)
    simfiles_rel.append(os.path.relpath(H2_htcfile_sim, simDir))
    print(H2_htcfile_sim)

    # Patch htc file for output filename and tip load
    with open(H2_htcfile_sim, 'r') as f :
      filedata = f.read()
    filedata = filedata.replace('{OUTPUTNAME}', 'f_{:5.1e}'.format(load))
    filedata = filedata.replace('{FX}', '{:5.1e}'.format(0))
    filedata = filedata.replace('{FY}', '{:5.1e}'.format(load))
    filedata = filedata.replace('{FZ}', '{:5.1e}'.format(0))
    with open(H2_htcfile_sim, 'w') as f:
      f.write(filedata)

# --- Write batch file
with open(os.path.join(simDir,'run.bat'),'w') as f:
    for sf in simfiles_rel:
        f.write('{} {}\n'.format(HAWC2, sf))

if __name__ == '__main__':
    pass


