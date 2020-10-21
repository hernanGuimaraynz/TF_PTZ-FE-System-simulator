function [Tcrm] = eulZYX2tr_dami_ptz(alfa,beta,gama,phiptz,titaptz)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%
%Tc_m: T de la camara respecto al mundo ZYX
Tptz0rm(1,:)=[ cos(alfa)*cos(beta), cos(alfa)*sin(beta)*sin(gama) - cos(gama)*sin(alfa), sin(alfa)*sin(gama) + cos(alfa)*cos(gama)*sin(beta),0];
Tptz0rm(2,:)=[ cos(beta)*sin(alfa), cos(alfa)*cos(gama) + sin(alfa)*sin(beta)*sin(gama), cos(gama)*sin(alfa)*sin(beta) - cos(alfa)*sin(gama),0];
Tptz0rm(3,:)=[          -sin(beta),                                 cos(beta)*sin(gama),                                 cos(beta)*cos(gama),0];
Tptz0rm(4,:)=[ 0, 0, 0, 1];

%modificacion si el mecanismo pan-tilt es RY
%Tcrptz0(1,:)=[ cos(phiptz)*cos(titaptz), -sin(phiptz), cos(phiptz)*sin(titaptz), 0];
%Tcrptz0(2,:)=[ cos(titaptz)*sin(phiptz),  cos(phiptz), sin(phiptz)*sin(titaptz), 0];
%Tcrptz0(3,:)=[            -sin(titaptz),            0,             cos(titaptz), 0];
%Tcrptz0(4,:)=[                        0,            0,                        0, 1];

%modificacion si el mecanismo pan-tilt es ZX
Tcrptz0(1,:)=[ cos(phiptz), -cos(titaptz)*sin(phiptz),  sin(phiptz)*sin(titaptz), 0];
Tcrptz0(2,:)=[ sin(phiptz),  cos(phiptz)*cos(titaptz), -cos(phiptz)*sin(titaptz), 0];
Tcrptz0(3,:)=[           0,              sin(titaptz),              cos(titaptz), 0];
Tcrptz0(4,:)=[           0,                         0,                         0, 1];

%Tcrptz0(1,:)=[  cos(phiptz)*cos(titaptz), -cos(titaptz)*sin(phiptz), sin(titaptz), 0];
%Tcrptz0(2,:)=[               sin(phiptz),               cos(phiptz),            0, 0];
%Tcrptz0(3,:)=[ -cos(phiptz)*sin(titaptz),  sin(phiptz)*sin(titaptz), cos(titaptz), 0];
%Tcrptz0(4,:)=[                         0,                         0,            0, 1];


Tcrm=Tptz0rm*Tcrptz0;
end

