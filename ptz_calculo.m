function [pPtz,aP,ppP  ] = ptz_calculo(P,A,PP, xptz,yptz,zptz,alfa_ptz,beta_ptz,gama_ptz,fptz,phiptz,titaptz,Npixptzh,Npixptzw)



tampix=1; %tamaño pixel

f=fptz; %pix
h=zptz;   %m  


%Condiciones iniciales
xc_m=xptz; %xc en el plano
yc_m=yptz; %yc en el plano
zc_m=zptz; %zc en el plano


Tptz0rAA(1,:)=[ cos(alfa_ptz)*cos(beta_ptz), cos(alfa_ptz)*sin(beta_ptz)*sin(gama_ptz) - cos(gama_ptz)*sin(alfa_ptz), sin(alfa_ptz)*sin(gama_ptz) + cos(alfa_ptz)*cos(gama_ptz)*sin(beta_ptz),0];
Tptz0rAA(2,:)=[ cos(beta_ptz)*sin(alfa_ptz), cos(alfa_ptz)*cos(gama_ptz) + sin(alfa_ptz)*sin(beta_ptz)*sin(gama_ptz), cos(gama_ptz)*sin(alfa_ptz)*sin(beta_ptz) - cos(alfa_ptz)*sin(gama_ptz),0];
Tptz0rAA(3,:)=[          -sin(beta_ptz),                                 cos(beta_ptz)*sin(gama_ptz),                                 cos(beta_ptz)*cos(gama_ptz),0];
Tptz0rAA(4,:)=[ 0, 0, 0, 1];
 %  %modificacion si el mecanismo pan-tilt es ZX
Tcrptz0(1,:)=[ cos(phiptz), -cos(titaptz)*sin(phiptz),  sin(phiptz)*sin(titaptz), 0];
Tcrptz0(2,:)=[ sin(phiptz),  cos(phiptz)*cos(titaptz), -cos(phiptz)*sin(titaptz), 0];
Tcrptz0(3,:)=[           0,              sin(titaptz),              cos(titaptz), 0];
Tcrptz0(4,:)=[           0,                         0,                         0, 1];
Tcrm=transl(xptz, yptz, zptz)*Tptz0rAA*Tcrptz0; %trama C respecto a 0(Tptz)
Tmrc=inv(Tcrm); %trama 0 respecto a C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pm=P;
Pm(4,:)=1;

pc=Tmrc*Pm; %cambio de coord desde ¨{0=m} --> {C}


SS=size(Pm);
 for n=1:SS(2)


xpix(n)=((fptz*pc(1,n)/(pc(3,n)))/tampix)+Npixptzw/2;    
ypix(n)=((fptz*pc(2,n)/(pc(3,n)))/tampix)+Npixptzh/2;    

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pm1=A;
Pm1(4,:)=1;

pc1=Tmrc*Pm1; %cambio de coord desde ¨{0=m} --> {C}

SS1=size(Pm1);
 for n=1:SS1(2)

xpix1(n)=((fptz*pc1(1,n)/(pc1(3,n)))/tampix)+Npixptzw/2;    
ypix1(n)=((fptz*pc1(2,n)/(pc1(3,n)))/tampix)+Npixptzh/2;    

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pm2=PP;
Pm2(4,:)=1;

pc2=Tmrc*Pm2; %cambio de coord desde ¨{0=m} --> {C}

SS2=size(Pm2);
 for n=1:SS2(2)

xpix2(n)=((fptz*pc2(1,n)/(pc2(3,n)))/tampix)+Npixptzw/2;    
ypix2(n)=((fptz*pc2(2,n)/(pc2(3,n)))/tampix)+Npixptzh/2;    

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pPtz=[xpix;ypix];

aP=[xpix1;ypix1];

ppP=[xpix2;ypix2];

 figure(1),subplot(1,2,2),hold on,plot(pPtz(1,:),pPtz(2,:),'b*'),xlim([0 1280]),ylim([0 960]),daspect([1 1 1])
 figure(1),subplot(1,2,2),hold on,plot(aP(1,:),aP(2,:),'r*'),xlim([0 1280]),ylim([0 960]),daspect([1 1 1])
  figure(1),subplot(1,2,2),hold on,plot(ppP(1,:),ppP(2,:),'k*'),xlim([0 1280]),ylim([0 960]),daspect([1 1 1]),title('Camara plana: Toolbox (O) VS cuentas(*)')
  



end

