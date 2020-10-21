 clear all
 close all
clc

run simFE2.m


%desplazamientos de las camaras en trama mundo {0}
xfeo=43.5;
yfeo=43.5;
zfeo=-15.3;

alfa_fe=(0*pi/180);%0*pi/180;
beta_fe=(0*pi/180);
gama_fe=(0*pi/180);


%Finalmente Tvca es la trama de {FE} respecto del mundo {0}

Tfe = transl(xfeo, yfeo, zfeo) * eulZYX2tr_dami(alfa_fe,beta_fe,gama_fe);


camfe.T=Tfe;


% [alfa_feR beta_feR gama_feR xfeoR yfeoR zfeoR]

%puntos de la interseccion en las coord. del mundo
P2(1,:)=P(1,:);
P2(2,:)=P(2,:);
P2(3,:)=P(3,:);

[UV]=camfe.project(P2);%proyecto los puntos del mundo a puntos en la base de la camara 

%puntos de la interseccion en las coord. de la camara FE
xfe=UV(1,:);
yfe=UV(2,:);
xm=P2(1,:);
ym=P2(2,:);

%puntos del auto en las coord. del mundo
Ap8=[70 52 0]';

A2=[];
A2(1,:)=Ap8(1,:);
A2(2,:)=Ap8(2,:);
A2(3,:)=Ap8(3,:);

[UV2]=camfe.project(A2);%proyecto los puntos del mundo a puntos en la base de la camara 

%puntos del auto en las coord. de la camara FE
xfe2=UV2(1,:);
yfe2=UV2(2,:);
xm2=A2(1,:);
ym2=A2(2,:);

% figure(4),subplot(1,2,2),hold on,plot(abs(xfe),abs(yfe),'.r'),hold on,plot(xfe2,yfe2,'.b'),grid on,xlim([0 1920]),ylim([0 1920])
% hold on,
subplot(1,2,1),grid on,hold on,plot(xm,ym,'.r'),hold on,plot(xm2,ym2,'.b'),grid on,xlim([0 110]),ylim([0 110])

%utilizando el modelo,hago la retroproyeccion de los puntos de la imagen de
%vuelta al mundo.(para la interseccion)
[PuntoMundoA] = camarafe_a_mundo_vect([alfa_fe beta_fe gama_fe xfeo yfeo zfeo],[xfe yfe]);


N1=length(PuntoMundoA);
xmpredA=PuntoMundoA(1:(N1/2));
ympredA=PuntoMundoA((N1/2+1):end);


%utilizando el modelo,hago la retroproyeccion de los puntos de la imagen de
%vuelta al mundo.(para el auto)
[PuntoMundoC] = camarafe_a_mundo_vect([alfa_fe beta_fe gama_fe xfeo yfeo zfeo],[xfe2 yfe2]);


N1=length(PuntoMundoC);
xmpredC=PuntoMundoC(1:(N1/2));
ympredC=PuntoMundoC((N1/2+1):end);


subplot(1,2,2),hold on,plot(xfe2,yfe2,'go','LineWidth',1)
%posicion y orientacion de la camara FE en el mundo.
Px = xfeo;
Py = yfeo;
Pz = -zfeo;
alfa=0*pi/180;
beta=0*pi/180;
gama=0*pi/180;
k=952.16;


param(1)=Px;
param(2)=Py;
param(3)=Pz;
param(4)=alfa;
param(5)=beta;
param(6)=gama;
param(7)=k;
                %incertezas
epsilon(1)=3;   %x
epsilon(2)=3;   %y
epsilon(3)=1.5; %z
epsilon(4)=2*pi/180; %alfa
epsilon(5)=2*pi/180; %beta
epsilon(6)=2*pi/180; %gama
epsilon(7)=10; %k
epsilon(8)=0.707; %xpix
epsilon(9)=0.707; %ypix

varianza=epsilon.*epsilon;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%incertezas de la posicion real en el mundo para el auto.


 

for np=1:length(xfe2)

for nparam=1:7
delta=zeros(size(param));
delta(nparam)=epsilon(nparam);
param1=param-delta;
param2=param+delta;

[xmpred1,ympred1] = vca2map_forjac(param1,xfe2(np),yfe2(np));
[xmpred2,ympred2] = vca2map_forjac(param2,xfe2(np),yfe2(np));

Jac(1,nparam)=(xmpred2-xmpred1)/(2*delta(nparam));
Jac(2,nparam)=(ympred2-ympred1)/(2*delta(nparam));

end

%Jac_xpix
[xmpred1,ympred1] = vca2map_forjac(param,xfe2(np)-epsilon(8),yfe2(np));
[xmpred2,ympred2] = vca2map_forjac(param,xfe2(np)+epsilon(8),yfe2(np));
Jac(1,8)=xmpred2-xmpred1;
Jac(2,8)=ympred2-ympred1;
%Jac_ypix
[xmpred1,ympred1] = vca2map_forjac(param,xfe2(np),yfe2(np)-epsilon(9));
[xmpred2,ympred2] = vca2map_forjac(param,xfe2(np),yfe2(np)+epsilon(9));
Jac(1,9)=xmpred2-xmpred1;
Jac(2,9)=ympred2-ympred1;

Cparam=zeros(9);
for n=1:9
Cparam(n,n)=varianza(n);
end

Cm=Jac*Cparam*Jac';

 figure(4),hold on,subplot(1,2,1),hold on,plot(xm2,ym2,'r*'),xlim([0 110]),ylim([0 110])
 figure(4),hold on,subplot(1,2,1),hold on,plot(xm2(np),ym2(np),'ko'),xlim([0 110]),ylim([0 110])
 figure(4),hold on,plot_ellipse((Cm),[xm2(np),ym2(np)],'b-'),xlim([0 110]),ylim([0 110])
end

%%

for nsim=1:100
    


xfeo=43.5+(3*randn);
yfeo=43.5+(3*randn);
zfeo=-15.3+(1.5*randn);

alfa_fe=(0*pi/180)+(2*pi/180)*randn;%0*pi/180;
beta_fe=(0*pi/180)+(2*pi/180)*randn;
gama_fe=(0*pi/180)+(2*pi/180)*randn;

camfe.k=952.16+(10*(randn));
%Finalmente Tvca es la trama de {FE} respecto del mundo {0}

Tfe = transl(xfeo, yfeo, zfeo) * eulZYX2tr_dami(alfa_fe,beta_fe,gama_fe);

camfe.T=Tfe;


A4=[];
A4(1,:)=Ap8(1,:);
A4(2,:)=Ap8(2,:);
A4(3,:)=Ap8(3,:);

[UV4]=camfe.project(A4);%proyecto los puntos del mundo a puntos en la base de la camara 

%puntos del auto en las coord. de la camara FE
xfe4=UV4(1,:);
yfe4=UV4(2,:);

[PuntoMundoV] = camarafe_a_mundo_vect([alfa_fe beta_fe gama_fe xfeo yfeo zfeo],[xfe4 yfe4]);

xm4=PuntoMundoV(1);
ym4=PuntoMundoV(2);


 figure(4),hold on,subplot(1,2,1),hold on,plot(xm4,ym4,'b*'),xlim([0 110]),ylim([0 110])
 
%  figure(4),subplot(1,2,2),plot(xfe4,yfe4,'.b'),
%  grid on,xlim([0 1920]),ylim([0 1920])
end