function [vsal] = camarafe_a_mundo_vect(param,vpixinput)
%
N1=length(vpixinput);
vxi=vpixinput(1:(N1/2));
vyi=vpixinput((N1/2+1):end);


% k=952.16+(10*randn);%K con incerteza.

x0=1920/2;
y0=1920/2;


alfa=param(1);
beta=param(2);
gama=param(3);
xc_m=param(4);
yc_m=param(5);
zc_m=param(6);
k=param(7);
for n=1:length(vxi)
    
xi=vxi(n);
yi=vyi(n);
phii=atan2(yi-y0,xi-x0);

ri=sqrt((xi-x0)^2+(yi-y0)^2);


titac=2*atan(ri/k);
phic=phii;

%calculo Rc
Rc=-zc_m/(cos(beta)*cos(gama)*cos(titac)-cos(phic)*sin(beta)*sin(titac)+cos(beta)*sin(gama)*sin(phic)*sin(titac));

%calculo xc yc zc que son las coord del punto P respect. a {C}
xc=Rc*cos(phic)*sin(titac);
yc=Rc*sin(phic)*sin(titac);
zc=Rc*cos(titac);

%Tc_m: T de la camara respecto al mundo
Tc_m(1,:)=[ cos(alfa)*cos(beta), cos(alfa)*sin(beta)*sin(gama) - cos(gama)*sin(alfa), sin(alfa)*sin(gama) + cos(alfa)*cos(gama)*sin(beta),xc_m];
Tc_m(2,:)=[ cos(beta)*sin(alfa), cos(alfa)*cos(gama) + sin(alfa)*sin(beta)*sin(gama), cos(gama)*sin(alfa)*sin(beta) - cos(alfa)*sin(gama),yc_m];
Tc_m(3,:)=[          -sin(beta),                                 cos(beta)*sin(gama),                                 cos(beta)*cos(gama),zc_m];
Tc_m(4,:)=[ 0, 0, 0, 1];

pm=Tc_m*[xc;yc;zc;1];

vxm(n)=pm(1);
vym(n)=pm(2);

end

vsal=[vxm vym];

end

