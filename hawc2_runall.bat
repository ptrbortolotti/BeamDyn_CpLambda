:: NOTE: needs to be relative to "cases" folder
set hawc2= ..\..\..\HAWC2MB_v12.8.exe

cd Test1/hawc2/cases
%hawc2% f_1.5e+06.htc
%hawc2% f_1.0e+04.htc
%hawc2% f_1.0e+05.htc
%hawc2% f_1.0e+06.htc
%hawc2% f_1.0e+07.htc
%hawc2% f_2.5e+06.htc
%hawc2% f_2.0e+04.htc
%hawc2% f_2.0e+05.htc
%hawc2% f_2.0e+06.htc
%hawc2% f_3.0e+06.htc
%hawc2% f_4.0e+04.htc
%hawc2% f_4.0e+05.htc
%hawc2% f_4.0e+06.htc
%hawc2% f_6.0e+04.htc
%hawc2% f_6.0e+05.htc
%hawc2% f_6.0e+06.htc
%hawc2% f_8.0e+04.htc
%hawc2% f_8.0e+05.htc
%hawc2% f_8.0e+06.htc
cd ../../../

cd Test2/hawc2/cases
%hawc2% f_2.0e+05.htc
%hawc2% f_5.0e+05.htc
%hawc2% f_1.0e+06.htc
%hawc2% f_1.5e+06.htc
%hawc2% f_2.0e+06.htc
%hawc2% f_4.0e+06.htc
%hawc2% f_5.0e+06.htc
%hawc2% f_8.0e+06.htc
%hawc2% f_1.0e+07.htc
cd ../../../


cd Test3/hawc2/cases
%hawc2% f_1.0e+05.htc
%hawc2% f_2.0e+05.htc
%hawc2% f_3.0e+05.htc
%hawc2% f_4.0e+05.htc
%hawc2% f_5.0e+05.htc
%hawc2% f_1.0e+06.htc
%hawc2% f_2.0e+06.htc
cd ../../../


cd Test5/hawc2/cases
%hawc2% sim.htc
cd ../../../

cd Test6/hawc2/cases
%hawc2% sim.htc
cd ../../../

cd Test7/hawc2/cases
%hawc2% sim.htc
cd ../../../


