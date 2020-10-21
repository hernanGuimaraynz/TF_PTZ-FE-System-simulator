function [vsal] = camptz_a_mundo_vect_270116(param,vpixinput)
%
N1=length(vpixinput);
vxi=vpixinput(1:(N1/2));
vyi=vpixinput((N1/2+1):end);

% vxi=vpixinput(1,:);
% vyi=vpixinput(2,:);

global camptz
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%  entrada: titac phic
%  parametros: alfa beta gama zc_m , xc_m yc_m
 global parptz
% 
 x0=parptz.x0;
 y0=parptz.y0;
 
f= param(7);

tita_tilt=parptz.tita_tilt;
phi_pan=parptz.phi_pan;
 titaptz=tita_tilt;
 phiptz=phi_pan;

 


alfa=param(1);
beta=param(2);
gama=param(3);
xc_m=param(4);
yc_m=param(5);
zc_m=param(6);


for n=1:length(vxi)
    
xi=vxi(n);
yi=vyi(n);

phii=atan2(yi-y0,xi-x0);
ri=sqrt((xi-x0)^2+(yi-y0)^2);
titac=atan(ri/f);
phic=phii;

%calculo Rc: Arroyo 2015
%Rc=-zc_m/(cos(beta)*cos(gama)*cos(titac)-cos(phic)*sin(beta)*sin(titac)+cos(beta)*sin(gama)*sin(phic)*sin(titac));

xcv=cos(phic)*sin(titac);
ycv=sin(phic)*sin(titac);
zcv=cos(titac);

%Rc= -zc_m/(ycv*(sin(beta)*sin(phiptz) + cos(beta)*cos(phiptz)*sin(gama))...
%     - xcv*(cos(titaptz)*(cos(phiptz)*sin(beta) - cos(beta)*sin(gama)*sin(phiptz))...
%     + cos(beta)*cos(gama)*sin(titaptz)) - zcv*(sin(titaptz)*(cos(phiptz)*sin(beta)...
%     - cos(beta)*sin(gama)*sin(phiptz)) - cos(beta)*cos(gama)*cos(titaptz)));

%ZYX -> ZX
Rc= -zc_m/(-xcv*(cos(phiptz)*sin(beta) - cos(beta)*sin(gama)*sin(phiptz)) ...
     + ycv*(cos(titaptz)*(sin(beta)*sin(phiptz) + cos(beta)*cos(phiptz)*sin(gama)) + cos(beta)*cos(gama)*sin(titaptz)) ...
     - zcv*(sin(titaptz)*(sin(beta)*sin(phiptz) + cos(beta)*cos(phiptz)*sin(gama)) - cos(beta)*cos(gama)*cos(titaptz)));
  
%calculo xc yc zc que son las coord del punto P respect. a {C}
xc=Rc*cos(phic)*sin(titac);
yc=Rc*sin(phic)*sin(titac);
zc=Rc*cos(titac);

%%Tcrm: T de la camara respecto al mundo ZYX
Tptz0rm(1,:)=[ cos(alfa)*cos(beta), cos(alfa)*sin(beta)*sin(gama) - cos(gama)*sin(alfa), sin(alfa)*sin(gama) + cos(alfa)*cos(gama)*sin(beta),xc_m];
Tptz0rm(2,:)=[ cos(beta)*sin(alfa), cos(alfa)*cos(gama) + sin(alfa)*sin(beta)*sin(gama), cos(gama)*sin(alfa)*sin(beta) - cos(alfa)*sin(gama),yc_m];
Tptz0rm(3,:)=[          -sin(beta),                                 cos(beta)*sin(gama),                                 cos(beta)*cos(gama),zc_m];
Tptz0rm(4,:)=[ 0, 0, 0, 1];

%modificacion si el mecanismo pan-tilt es ZY
%Tcrptz0(1,:)=[ cos(phiptz)*cos(titaptz), -sin(phiptz), cos(phiptz)*sin(titaptz), 0];
%Tcrptz0(2,:)=[ cos(titaptz)*sin(phiptz),  cos(phiptz), sin(phiptz)*sin(titaptz), 0];
%Tcrptz0(3,:)=[            -sin(titaptz),            0,             cos(titaptz), 0];
%Tcrptz0(4,:)=[                        0,            0,                        0, 1];

%modificacion si el mecanismo pan-tilt es ZX
Tcrptz0(1,:)=[ cos(phiptz), -cos(titaptz)*sin(phiptz),  sin(phiptz)*sin(titaptz), 0];
Tcrptz0(2,:)=[ sin(phiptz),  cos(phiptz)*cos(titaptz), -cos(phiptz)*sin(titaptz), 0];
Tcrptz0(3,:)=[           0,              sin(titaptz),              cos(titaptz), 0];
Tcrptz0(4,:)=[           0,                         0,                         0, 1];

% XZ
%Tcrptz0(1,:)=[  cos(phiptz)*cos(titaptz), -cos(titaptz)*sin(phiptz), sin(titaptz), 0];
%Tcrptz0(2,:)=[               sin(phiptz),               cos(phiptz),            0, 0];
%Tcrptz0(3,:)=[ -cos(phiptz)*sin(titaptz),  sin(phiptz)*sin(titaptz), cos(titaptz), 0];
%Tcrptz0(4,:)=[                         0,                         0,            0, 1];

Tcrm=Tptz0rm*Tcrptz0;%de al camara al mundo
%%
pm=Tcrm*[xc;yc;zc;1];

vxm(n)=pm(1);
vym(n)=pm(2);

end

vsal=[vxm,vym];

end

