import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
# Local 
from shutil import copyfile
from welib.fast.beamdyn import BeamDyn2Hawc2
np.set_printoptions(linewidth=500)
import welib.weio as weio

# --- Parameters
simDir='cases'
HAWC2='hawc2'
BD_mainfile    = '../load_conv/f_1e3/Box_Beam_SCALED_2_BeamDyn.dat'
BD_bladefile   = '../load_conv/f_1e3/Box_Beam_SCALED_2_BeamDyn_Blade.dat'
H2_htcfile_old = './template.htc'
H2_htcfile_new = os.path.join(simDir,'default.htc')
H2_stfile      = os.path.join(simDir,'solid_beam_st.st')
vf = np.array([1e3,2e3,3e3,4e3,5e3]);

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
    filedata = filedata.replace('{IEXT}', str(isim+1))
    #filedata = filedata.replace('{FX}', '{:5.1e}'.format(0))
    #filedata = filedata.replace('{FY}', '{:5.1e}'.format(load))
    #filedata = filedata.replace('{FZ}', '{:5.1e}'.format(0))
    with open(H2_htcfile_sim, 'w') as f:
      f.write(filedata)

# --- Write load files
bdLine = weio.read(BD_mainfile).toDataFrame()
z  = bdLine['kp_zr_[m]'].values
dz=np.diff(z)

for isim, load in enumerate(vf):
    filename=os.path.join(simDir,'ext_force.0{:d}'.format(isim+1))
    print(filename)
    with open(filename,'w') as f:
        f.write('# input file for ext_force.dll, distributed force along y of value {:5.1e} N/m\n'.format(load))
        f.write('1 0.02 {:d} nstep dt nchan\n'.format(len(z)))
        print('dz:',dz[0],dz[-1],'point load:',dz[0]*load)
        for i in np.arange(len(z)):
            if i==0:
                fp = load*dz[0] #/2.
            elif i==len(z)-1:
                fp = load*dz[-1] #/2.
            else:
                fp = load*(dz[i-1] + dz[i])/2.
            f.write('{:.9e} '.format(fp))
        f.write('\n')




# --- Write batch file
with open(os.path.join(simDir,'run.bat'),'w') as f:
    for sf in simfiles_rel:
        f.write('{} {}\n'.format(HAWC2, sf))

if __name__ == '__main__':
    pass


