clc; close all; clear all;

E = 200e9;
G = 79.3e9;
sh_coeff = 0.83333;
l = 10;
b = 0.5;
h = 0.25;
A = b*h;

Ib = 1/12*b*(h^3);
Ih = 1/12*(b^3)*h;
J = Ib + Ih;

{ 0:1, 1:2, 2:0, 3:4, 4:5, 5:3 }

c_mat = zeros(6);

c_mat(1,1) = sh_coeff*G*A;
c_mat(2,2) = sh_coeff*G*A;
c_mat(3,3) = E*A;
c_mat(4,4) = E*Ih;
c_mat(5,5) = E*Ib;
c_mat(6,6) = G*0.229*b*h*h*h;

c_mat=[2.5000e+10 0.0000e+00 0.0000e+00 0.0000e+00 0.0000e+00 0.0000e+00;
  0.0000e+00 8.2641e+09 0.0000e+00 0.0000e+00 0.0000e+00 0.0000e+00;
  0.0000e+00 0.0000e+00 7.8747e+09 0.0000e+00 0.0000e+00 0.0000e+00;
 0.0000e+00 0.0000e+00 0.0000e+00 1.4179e+08 0.0000e+00 0.0000e+00;
  0.0000e+00 0.0000e+00 0.0000e+00 0.0000e+00 1.3021e+08 0.0000e+00;
  0.0000e+00 0.0000e+00 0.0000e+00 0.0000e+00 0.0000e+00 5.2083e+08];

m_mat = [975.       0.       0.       0.       0.       0. ;
   0.     975.       0.       0.       0.       0.   ;
   0.       0.     975.       0.       0.       0.    ;
   0.       0.       0.      20.3125   0.       0.    ;
   0.       0.       0.       0.       5.0781   0.    
   0.       0.       0.       0.       0.      25.3906]