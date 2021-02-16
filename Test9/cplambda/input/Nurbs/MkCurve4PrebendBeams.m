%
% Write Cp-Lambda beam files with preBend and twist distribution loaded from external file using NURBS
%

clear all
close all
clc

%% add path
addpath nurbs_toolbox

%% Read blade geometry data
% DataGeo=load('INPUT_FromBeamDym.txt');
DataGeo=load('test9_ref_axis.dat');

%x	y	z	Twist	Chord	"Pitch axis aft LE"	Relative thickness
XX =  DataGeo(:,3);        % blade span, towards tip
YY = -DataGeo(:,2);        % chordwise, positive towards LE
ZZ =  DataGeo(:,1);        % downwind (PS to SS)

PreBend = ZZ;
Radius  = XX;                  
AeroTws = DataGeo(:,4)*pi/180;
clear DataGeo;

Eta = Radius./Radius(end);

%% Blade Structural data
DataStr=[];
% Section Number	BlFract	"Rotor radius"	Structural Twist
% (-)	            (-)	     (m)	        (deg)	        

EtaStruct   =  Eta;%DataStr(:,2);
DeltaStrcTws = AeroTws;%-DataStr(:,4)*pi/180;  %% Warning minus! 
clear DataStr;

%% Blade Structural Data on FINE mesh (I.e. FINE aero mesh)
DeltaStrcTws_Fine = spline(EtaStruct,DeltaStrcTws,Eta);

StrcTws = AeroTws + DeltaStrcTws_Fine;


%% Create the NURBS interpolating Radius and PreBend data
srf=MakeNURBS(Radius,PreBend,zeros(size(Radius)));

% Vector of nondimensional blade span for evaluating the nurbs
r_l=[Radius(end)*([0:0.000001:0.045,0.046:0.001:1])'; Radius];
r_long=unique(r_l);
eta_long=[r_long(1:end-1)./r_long(end); 1];

[p, w]=nrbeval(srf,eta_long);

% prebend angle
theta_pb = atan2(diff(p(2,:)),diff(p(1,:)))*180/pi;
radius_int = 0.5*(p(1,2:end)+p(1,1:end-1));

% Length of the blade
dL=sqrt((p(1,2:end)-p(1,1:end-1)).^2+(p(2,2:end)-p(2,1:end-1)).^2+(p(3,2:end)-p(3,1:end-1)).^2);
s=zeros(size(r_long));

for nl=1:length(dL)
    s(nl+1)=s(nl)+dL(nl);
end
L=s(end);


%% Flattening procedures (for the part of the blade without prebend)
% see Piegl and Tiller, "The NURBS book", pag. 542


% Find the part of the blade without prebend
last_unbended_points=find(PreBend==0,1,'last');
if isempty(last_unbended_points)
    last_unbended_points = 1
end

line_end=Radius(last_unbended_points)/L;

% Create new knots (trial and error ?!?)
delta=line_end/16;
new_knots=[delta:delta:line_end-delta];

% Add new knots
srf2=nrbkntins(srf,new_knots);

figure(1)
plot(srf2.coefs(1,:),srf2.coefs(2,:),'s')
hold on
plot(Radius,PreBend,'o')
plot(srf.coefs(1,:),srf.coefs(2,:),'+r')
aux=find(srf2.coefs(1,:)>Radius(last_unbended_points));
srf2.coefs(2,[1:aux+1])=srf2.coefs(2,[1:aux+1])*0;
plot(srf2.coefs(1,:),srf2.coefs(2,:),'x')
legend('Original knots','Blade data','New knots',' knots with flattening')

% New flat NURBS
[p2, w]=nrbeval(srf2,eta_long);

theta_pb2 = atan2(diff(p2(2,:)),diff(p2(1,:)))*180/pi;
radius_int2 = 0.5*(p2(1,2:end)+p2(1,1:end-1));

eta_sections=interp1(r_long,s,Radius)/L;

% Compute derivatives of nurbs
dsrf = nrbderiv(srf);
[pnt, jac] = nrbdeval(srf, dsrf, eta_sections);
% Compute derivatives of nurbs
dsrf2 = nrbderiv(srf2);
[pnt2, jac2] = nrbdeval(srf2, dsrf2, eta_sections);
[pnt3, jac3] = nrbdeval(srf2, dsrf2, eta_long);
ddsrf2 = nrbderiv(dsrf2);
[pnt4, jac4] = nrbdeval(srf2, ddsrf2, eta_long);

ddsrf = nrbderiv(dsrf);
[pnt5, jac5] = nrbdeval(srf, dsrf, eta_long);
[pnt6, jac6] = nrbdeval(srf, ddsrf, eta_long);

angleNURBS=atan2(jac(2,:),jac(1,:))*180/pi;
angleNURBS2=atan2(jac2(2,:),jac2(1,:))*180/pi;

% 
angleNURBS_int = interp1(radius_int,theta_pb,Radius,'spline');
angleNURBS2_int = interp1(radius_int2,theta_pb2,Radius,'spline');


figure(2)
plot(p(1,:),p(2,:),'r',p2(1,:),p2(2,:),'k')
hold on
plot(Radius,PreBend,'o')
legend('NURBS without flattening','NURBS with flattening')


figure(3)
plot(Radius,angleNURBS,'--r',Radius,angleNURBS2,'--k',Radius,angleNURBS_int,'r',Radius,angleNURBS2_int,'k')  
legend('NURBS without flattening','NURBS with flattening')
title('Angles of nurbs')
% axis([-0.1 5.1 -0.015 0.25])

figure(4)
plot(pnt5(1,:),jac5(2,:)./jac5(1,:),'r')
hold on
plot(pnt3(1,:),jac3(2,:)./jac3(1,:),'b')
title('First derivatives')
legend('NURBS without flattening','NURBS with flattening')
%xlim([-0.1 3.1])
figure(5)
plot(pnt6(1,:),jac6(2,:)./jac6(1,:),'r')
hold on
plot(pnt4(1,:),jac4(2,:)./jac4(1,:),'b')
title('Second derivatives')
legend('NURBS without flattening','NURBS with flattening')

%% Reverse Nurbs (for Lifting Lines)
srf2_rev = nrbreverse(srf2) 


%% Compute Cp-Lambda input data for BEAMs

disp('USE NO FLATTERING!!!')
NumberOfControlPoints = srf.number;
DegreeOfCurve         = srf.order-1;
Coordinates           = [srf.coefs(1,:); srf.coefs(3,:); srf.coefs(2,:); srf.coefs(4,:); ]; % warning here the Cp-Lambda reference system
KnotSequences         = srf.knots;
% disp('USE FLATTERING!!!')
% NumberOfControlPoints = srf2.number;
% DegreeOfCurve         = srf2.order-1;
% Coordinates           = [srf2.coefs(1,:); srf2.coefs(3,:); -srf2.coefs(2,:); srf2.coefs(4,:); ]; % warning here the Cp-Lambda reference system
% KnotSequences         = srf2.knots;

% local references
% first a rotation of -theta (struct) along X (i.e. along blade axis): R(-thetaT*X)
% second a rotation of PreBendAngle along Y (i.e. along flap axis):    R(thetaPB*Y)
for ie = 1:length(Eta)
    Rt  = so3(-StrcTws(ie)*[1,0,0]);
%     Rpb = so3(-angleNURBS2_int(ie)*[0,1,0]*pi/180);
    Rpb = so3(-angleNURBS_int(ie)*[0,1,0]*pi/180);
    R = Rpb*Rt;
    ee2(ie,:) = R*[0,1,0]';
    ee3(ie,:) = R*[0,0,1]';
end


%% Write Cp-Lambda BEAM input file
FileName = 'BeamCurveTest9.dat';
fout=fopen(FileName,'w');
fprintf(fout,'    # WRITTEN BY MATLAB on %s\n',date);

fprintf(fout,'Points : \n');
fprintf(fout,'  Point :\n');
fprintf(fout,'    Name : pt_blade_root ;\n');
fprintf(fout,'    Coordinates :  %1.5e,  %1.5e ,  %1.5e ; \n',Coordinates(1:3,1));
fprintf(fout,'    InReferenceFrame : blade_root_frame ; \n');
fprintf(fout,'   ;\n');
fprintf(fout,'  Point :\n');
fprintf(fout,'    Name : pt_blade_tip ;\n');
fprintf(fout,'    Coordinates :  %1.5e,  %1.5e ,  %1.5e ; \n',Coordinates(1:3,end));
fprintf(fout,'    InReferenceFrame : blade_root_frame ; \n');
fprintf(fout,'   ;\n');
fprintf(fout,' ; \n'); 

fprintf(fout,'\n'); 
fprintf(fout,'\n'); 
fprintf(fout,'    # WRITTEN BY MATLAB on %s\n',date);
fprintf(fout,'\n'); 
fprintf(fout,'\n'); 


fprintf(fout,'    Points : \n');
fprintf(fout,'        NumberOfControlPoints :  %i ;\n',NumberOfControlPoints);
fprintf(fout,'        DegreeOfCurve         :  %i ;\n',DegreeOfCurve);
fprintf(fout,'        RationalCurveFlag     : YES ;\n');
fprintf(fout,'        EndPoint0             : pt_blade_root ; Weights : 1;\n');
for ic=2:srf2.number-1
    fprintf(fout,'        Coordinates           : %1.5e, ',Coordinates(1,ic));
    fprintf(fout,' %1.5e,', Coordinates(2,ic));
    fprintf(fout,' %1.5e,', Coordinates(3,ic));
    fprintf(fout,' %1.5e;\n',Coordinates(4,ic));
end
fprintf(fout,'        EndPoint1             : pt_blade_tip ; Weights : 1;\n');
fprintf(fout,'    ; \n');
fprintf(fout,'    KnotSequences : \n');
fprintf(fout,'        KnotSequence : ');
for ik=1:length(KnotSequences)-1
    fprintf(fout,'  %1.5e, ',KnotSequences(ik));
end
fprintf(fout,'  %1.5e; \n',KnotSequences(ik+1));
fprintf(fout,'    ; \n');
fprintf(fout,'    Triads : \n');
fprintf(fout,'        NumberOfTerms :  %i ;\n',length(Eta));
for ie = 1:length(Eta)
    fprintf(fout,'        EtaValue : %1.5e ;       YVector : %1.8e, %1.8e, %1.8e;         ZVector : %1.8e, %1.8e, %1.8e; \n',Eta(ie),   ee2(ie,1),ee2(ie,2),ee2(ie,3),  ee3(ie,1),ee3(ie,2),ee3(ie,3));
end
fprintf(fout,'    ;\n');
fprintf(fout,'  CurveMeshParameter : mesh_blade ;\n');
fprintf(fout,'  ;\n');
fprintf(fout,';\n');
fclose(fout);

return
%% Compute Cp-Lambda input data for LIFTING LINE

NumberOfControlPoints = srf2_rev.number;
DegreeOfCurve         = srf2_rev.order-1;
Coordinates           = [srf2_rev.coefs(1,:); srf2_rev.coefs(3,:); -srf2_rev.coefs(2,:); srf2_rev.coefs(4,:); ]; % warning here the Cp-Lambda reference system
KnotSequences         = srf2_rev.knots;
% local references
% first a rotation of -theta (struct) along X (i.e. along blade axis): R(-thetaT*X)
% second a rotation of PreBendAngle along Y (i.e. along flap axis):    R(thetaPB*Y)
iee = 0;
for ie = length(Eta):-1:1
    iee = iee + 1;
    Rtz  = so3(-AeroTws(ie)*[1,0,0]);
    Rty  = so3((pi-AeroTws(ie))*[1,0,0]);
    Rpb = so3(angleNURBS2_int(ie)*[0,1,0]*pi/180);
    Ry = Rpb*Rty;
    Rz = Rpb*Rtz;
    ee2(iee,:) = Ry*[0,1,0]';
    ee3(iee,:) = Rz*[0,0,1]';
    Eta_ll(iee) = 1-Eta(ie);
end

%% Write Cp-Lambda LIFTING LINE input file
FileName = 'LiftingLineCurve.dat';
fout=fopen(FileName,'w');
fprintf(fout,'    # WRITTEN BY MATLAB on %s\n',date);
fprintf(fout,'    Points : \n');
fprintf(fout,'        NumberOfControlPoints :  %i ;\n',NumberOfControlPoints);
fprintf(fout,'        DegreeOfCurve         :  %i ;\n',DegreeOfCurve);
fprintf(fout,'        RationalCurveFlag     : YES ;\n');
fprintf(fout,'        EndPoint0             : pt_lifting_1_1 ; Weights : 1;\n');
for ic=2:srf2.number-1
    fprintf(fout,'        Coordinates           : %1.5e, ',Coordinates(1,ic));
    fprintf(fout,' %1.5e,', Coordinates(2,ic));
    fprintf(fout,' %1.5e,', Coordinates(3,ic));
    fprintf(fout,' %1.5e;\n',Coordinates(4,ic));
end
fprintf(fout,'        EndPoint1             : pt_lifting_2_1 ; Weights : 1;\n');
fprintf(fout,'    ; \n');
fprintf(fout,'    KnotSequences : \n');
fprintf(fout,'        KnotSequence : ');
for ik=1:length(KnotSequences)-1
    fprintf(fout,'  %1.5e, ',KnotSequences(ik));
end
fprintf(fout,'  %1.5e; \n',KnotSequences(ik+1));
fprintf(fout,'    ; \n');
fprintf(fout,'    Triads : \n');
fprintf(fout,'        NumberOfTerms :  %i ;\n',length(Eta_ll));
for ie = 1:length(Eta_ll)
    fprintf(fout,'        EtaValue : %1.5e ;       YVector : %1.8e, %1.8e, %1.8e;         ZVector : %1.8e, %1.8e, %1.8e; \n',Eta_ll(ie),   ee2(ie,1),ee2(ie,2),ee2(ie,3),  ee3(ie,1),ee3(ie,2),ee3(ie,3));
end
fprintf(fout,'    ;\n');
fprintf(fout,'  CurveMeshParameter : mesh_blade ;\n');
fprintf(fout,'  ;\n');
fprintf(fout,';\n');
fclose(fout);

