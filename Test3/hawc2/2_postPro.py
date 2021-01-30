import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
# Local 
import weio

from welib.fast.fastlib import find_matching_pattern, averageDF



# --- Parameters
IPostPro=[0,1]
simDir='cases'
BD_mainfile    = '../load_conv/f_1e5/Box_Beam_SCALED_1_BeamDyn.dat'
load = 500000;
vf = np.array([0.2,0.4,0.6,0.8,1.0,2.0,4.0])*load;
vf.sort()


# --- Derived params
bdLine = weio.read(BD_mainfile).toDataFrame()
kp_x  = bdLine['kp_xr_[m]'].values
kp_y  = bdLine['kp_yr_[m]'].values
# Hawc2 = BeamDyn
x = -kp_y
y  = kp_x
z  = bdLine['kp_zr_[m]'].values
nSpan=len(z)



if 0 in IPostPro:
    # --- Loop on outputs and extract deflections
    for isim, load in enumerate(vf):
        outfilename = os.path.join(simDir,'f_{:5.1e}.dat'.format(load))
        print(outfilename)
        df          = weio.read(outfilename).toDataFrame()
        dfAvg = averageDF(df,avgMethod='constantwindow',avgParam=2.0)
        colsX, sIdx = find_matching_pattern(df.columns, 'N(\d+)xb')
        colsY, sIdx = find_matching_pattern(df.columns, 'N(\d+)yb')
        colsZ, sIdx = find_matching_pattern(df.columns, 'N(\d+)zb')
        Icol = [int(s) for s in sIdx]
        if len(colsX)!=nSpan:
            raise Exception('Number of columns dont match. Make this script more general or adapt')

        u=np.zeros((3,nSpan))
        for i,(cx,cy,cz,id) in enumerate(zip(colsX,colsY,colsZ,Icol)):
            if i+1!=id:
                raise Exception('Index mismatch, columns are not sorted')
            u[:,i]=[dfAvg[cx]-x[i] ,dfAvg[cy]-y[i] ,dfAvg[cz]-z[i]]

        fig,axes = plt.subplots(3, 1, sharex=True, figsize=(6.4,4.8)) # (6.4,4.8)
        fig.subplots_adjust(left=0.12, right=0.95, top=0.95, bottom=0.11, hspace=0.20, wspace=0.20)
        for i,(ax,sc) in enumerate(zip(axes.ravel(),['x','y','z'])):
            ax.plot(z, u[i,:]*1000) #, label=r'$u_{}$'.format(sc))
            ax.set_ylabel(r'$u_{}$ [mm]'.format(sc))
            ax.tick_params(direction='in')
        ax.set_xlabel('Span [m]')
        #plt.show()
        fig.savefig(outfilename.replace('.dat','.png'))

        cols=['r_[m]','u_x_[m]','u_y_[m]','u_z_[m]']
        data =np.column_stack((z,u.T))
        dfOut = pd.DataFrame(columns=cols, data=data)
        dfOut.to_csv(outfilename.replace('.dat','.csv'), index=False, sep=',')

if 1 in IPostPro:
    # --- Loop on csv and extract tip deflections
    utip=np.zeros((3,len(vf)))
    for isim, load in enumerate(vf):
        outfilename = os.path.join(simDir,'f_{:5.1e}.csv'.format(load))
        df=weio.read(outfilename).toDataFrame()
        utip[:,isim] = [df['u_x_[m]'].values[-1], df['u_y_[m]'].values[-1], df['u_z_[m]'].values[-1]]


    cols=['f_[N]','u_x_[m]','u_y_[m]','u_z_[m]']
    data =np.column_stack((vf,utip.T))
    dfOut = pd.DataFrame(columns=cols, data=data)
    dfOut.to_csv('tiploads3.csv', index=False, sep='\t')

    fig,axes = plt.subplots(3, 1, sharex=True, figsize=(6.4,4.8)) # (6.4,4.8)
    fig.subplots_adjust(left=0.12, right=0.95, top=0.95, bottom=0.11, hspace=0.20, wspace=0.20)
    for i,(ax,sc) in enumerate(zip(axes.ravel(),['x','y','z'])):
        ax.plot(np.arange(len(vf))+1, utip[i,:]*1000) #, label=r'$u_{}$'.format(sc))
        ax.set_ylabel(r'$u_{}$ [mm]'.format(sc))
        ax.tick_params(direction='in')
    ax.set_xlabel('Load i')
    fig.savefig('tiploads3.png')





if __name__ == '__main__':
    pass
