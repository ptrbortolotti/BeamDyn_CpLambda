```

def K66toProps(K, convention='BeamDyn'):
    """
    Convert stiffness properties of a 6x6 section to beam properties
    This assumes that the axial and bending loads are decoupled.



    INPUTS:
    - K : 6x6 array of stiffness elements. Each element may be an array (e.g. for all spanwise values)
    OUTPUTS:
    - EA, EIx, EIy: axial and bending stiffnesses
    - kxGA, kyGA, GKt: shear and torsional stiffness
    - xC,yC : centroid
    - xS,yS : shear center
    - theta_p, theta_s: angle to principal axes and shear axes
    """
    K11=K[0,0]
    K22=K[1,1]
    K33=K[2,2]
    K44=K[3,3]
    K55=K[4,4]
    K66=K[5,5]



    K12=K[0,1]
    K16=K[0,5]
    K26=K[1,5]
    K34=K[2,3]
    K35=K[2,4]
    K45=K[3,4]



    if convention=='BeamDyn':
    # --- EA, EI, centroid, principal axes
    EA = K33
    yC = K34/EA
    xC = -K35/EA
    Hxx= K44-EA*yC**2
    Hyy= K55-EA*yC**2
    Hxy= -K45+EA*xC*yC



    if np.all(np.abs(Hxy))<1e-16:
    # NOTE: Assumes theta_p ==0
    EIx = Hxx
    EIy = Hyy
    theta_p=0*EA
    else:
    raise NotImplementedError('Solve for EI and thetap using H')



    # --- Torsion, shear terms, shear center
    Kxx = K11
    Kxy = -K12
    Kyy = K22
    yS = (Kyy*K16+Kxy*K26)/(-Kyy*Kxx + Kxy**2)
    xS = (Kxy*K16+Kxx*K26)/( Kyy*Kxx - Kxy**2)
    GKt = K66 - Kxx*yS**2 -2*Kxy*xS*yS - Kyy*xS**2
    if np.all(np.abs(Kxy))<1e-16:
    # Assumes theta_s=0
    kxsGA = Kxx
    kysGA = Kyy
    theta_s=0*EA
    else:
    raise NotImplementedError('Solve for kx and thetas using K')
    # sanity check
    np.testing.assert_array_almost_equal(K16, -Kxx*yS-Kxy*xS)
    else:
    raise NotImplementedError()



    return EA, EIx, EIy, kxsGA, kysGA, GKt, xC, yC, xS, yS, theta_p, theta_s