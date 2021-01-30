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
HAWC2='hawc2'
BD_mainfile    = '../beamdyn/BAR3_BeamDyn.dat'
BD_bladefile   = '../beamdyn/BAR3_BeamDyn_Blade.dat'
H2_htcfile_old = './template.htc'
H2_htcfile_new = './sim.htc'
H2_stfile      = './solid_beam_st.st'

copyfile(H2_htcfile_old, H2_htcfile_new)
BeamDyn2Hawc2(BD_mainfile, BD_bladefile, H2_htcfile_new, H2_stfile, 'beam1', A=None, E=None, G=None)



