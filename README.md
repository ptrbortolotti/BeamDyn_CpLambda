3 b# BeamDyn_CpLambda
Repository to code2code compare OpenFAST's BeamDyn and Polimi/TUM Cp-Lambda

# List of tests

Test 1: Straight box beam - only diagonal terms - static tip load (BeamDyn vs Cp-Lambda vs HAWC2 ok)

Test 2: Curved box beam - only diagonal terms - static tip load (BeamDyn vs HAWC2 ok)

Test 3: Straight box beam - some non-diagonal terms - static tip load (BeamDyn vs HAWC2 ok)

Test 4: Straight box beam - full stiffness matrix - static distributed load (BeamDyn vs HAWC2 ok)

Test 5: Test 1 rotating around x with gravity starting at 0 azimuth (BeamDyn vs HAWC2 vs OpenFAST ok)

Test 6: Test 2 rotating around x with gravity starting at 0 azimuth (BeamDyn vs HAWC2 vs OpenFAST ok)

Test 7: Test 2 rotating around x with prebend instead of sweep with gravity starting at 0 azimuth (BeamDyn vs HAWC2 vs OpenFAST ok)

Test 8: BAR3 blade with prebend and sweep rotating around x with gravity starting at 0 azimuth (BeamDyn vs HAWC2 vs OpenFAST ok)

Test 9: Composite curved beam - distributed load (not yet verified)

Test 10: Test 4 rotating around x with gravity starting at 0 azimuth (BeamDyn vs HAWC2 vs OpenFAST ok)

Test 12: BAR3 blade with prebend - BD 3 blades vs OpenFAST (Blade 1 ok, Blades 2/3 fail)

Test 13: BAR3 without prebend - BD 3 blades vs OpenFAST (Blades 1/2/3 ok)

Test 14: curved box beam from Test 2 rotating around x with gravity starting at 0/120/240 azimuth (BeamDyn vs OpenFAST ok)

Test 15: test 14 with non-linear twist and prebend=sweep (Blade 1 ok, Blades 2/3 fail!!)

Test 16: test 15 with stiffness and inertia matrices from Test 12 (BeamDyn vs OpenFAST ok)

Test 17: Test 12 with cubic twist and order_elem=5 (Blade 1 ok, Blades 2/3 fail). Increasing order_elem decreases the error, which disappears for linear twist