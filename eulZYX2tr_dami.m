function [Tcrm] = eulZYX2tr_dami(alfa,beta,gama)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%
%Tc_m: T de la camara respecto al mundo
Tcrm(1,:)=[ cos(alfa)*cos(beta), cos(alfa)*sin(beta)*sin(gama) - cos(gama)*sin(alfa), sin(alfa)*sin(gama) + cos(alfa)*cos(gama)*sin(beta),0];
Tcrm(2,:)=[ cos(beta)*sin(alfa), cos(alfa)*cos(gama) + sin(alfa)*sin(beta)*sin(gama), cos(gama)*sin(alfa)*sin(beta) - cos(alfa)*sin(gama),0];
Tcrm(3,:)=[          -sin(beta),                                 cos(beta)*sin(gama),                                 cos(beta)*cos(gama),0];
Tcrm(4,:)=[ 0, 0, 0, 1];

end

