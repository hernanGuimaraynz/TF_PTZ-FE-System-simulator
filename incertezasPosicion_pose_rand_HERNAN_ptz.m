clear all
close all
clc

% run simFE2.m


%desplazamientos de las camaras en trama mundo {0}
xptz=43.5; % coord. X , PTZ in world frame {0} measured in [m]
yptz=43.5; % coord. Y , PTZ in world frame {0} measured in [m]
zptz=-15; % coord. Z , PTZ in world frame {0} measured in [m]
alfa_ptz=0.0;
beta_ptz=-0.0;
gama_ptz=+0.0;
phiptz=-0*pi/180;  %PAN
titaptz=0*pi/180; %TILT
%Finalmente Tvca es la trama de {FE} respecto del mundo {0}
Tptz = transl(xptz, yptz, zptz) * eulZYX2tr_dami_ptz(alfa_ptz,beta_ptz,gama_ptz,phiptz,titaptz);

fptz=1454.4;


Npixptzw=1280;
Npixptzh=960;

global camptz
 camptz = CentralCamera('name', 'PTZ','focal', fptz, ...
'resolution', [Npixptzw Npixptzh], ...
'centre', [Npixptzw/2 Npixptzh/2], ...
'noise', 1.0, ...
'focal', fptz);

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
param(1)=xptz;
param(2)=yptz;
param(3)=zptz;
param(4)=alfa_ptz;
param(5)=beta_ptz;
param(6)=gama_ptz;
param(7)=titaptz; 
param(8)=phiptz;
             

%incertezas
epsilon(1)=3;   %x
epsilon(2)=3;   %y
epsilon(3)=1.5; %z
epsilon(4)=2*pi/180; %alfa
epsilon(5)=2*pi/180; %beta
epsilon(6)=2*pi/180; %gama
epsilon(7)=2*pi/180;
epsilon(8)=2*pi/180;
epsilon(9)=0.707; %xpix
epsilon(10)=0.707; %ypix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%incertezas de la posicion real en el mundo para el auto.
np=1;
[P] =dibujarCalle('PTZ',5);
dibujarROI( 1,'PTZ',5 );
dibujarROI( 2,'PTZ',5 );
dibujarROI( 3,'PTZ',5 );
dibujarROI( 4,'PTZ',5);
 %%
for nmx=5:2:15
    for nmy=5:2:15
              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ap8=[70 52 0]';

Ap8(:,1)=[55 55 0];
% Ap8(:,1)=[15 55 0];
% Ap8(:,1)=[90 55 0];
% Ap8(:,1)=[55 15 0];
% Ap8(:,1)=[55 95 0];


A2=[];
A2(1,:)=Ap8(1,:);
A2(2,:)=Ap8(2,:);
A2(3,:)=Ap8(3,:);
[UV2]=camptz.project(A2);%proyecto los puntos del mundo a puntos en la base de la camara 
xfe2=UV2(1,:);
yfe2=UV2(2,:);                     
%coord imag del centro elipse
% xfe2=100*nmx;
% yfe2=100*nmy;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%puntos de la interseccion en las coord. del mundo
P2(1,:)=P(1,:);
P2(2,:)=P(2,:);
P2(3,:)=P(3,:);
[UV]=camptz.project(P2);%proyecto los puntos del mundo a puntos en la base de la camara 
%puntos de la interseccion en las coord. de la camara FE
xfe=UV(1,:);
yfe=UV(2,:);
xm=P2(1,:);
ym=P2(2,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(5),hold on,subplot(1,2,2),hold on,plot(xfe2,yfe2,'r*'),xlim([0 1920]),ylim([0 1920])

%coord mundo del centro elipse
% [xm2,ym2] = vca2map_forjac(param,xfe2,yfe2);
[vsal] = camptz_a_mundo_vect_e(param,[xfe2 ;yfe2]);
xm2=vsal(1,:);
ym2=vsal(2,:);
P=[xm2,ym2,0]';



%Calculo el Jacobiano de F(imag->mundo)
[Cm,Jac] = cov_jac_ptz(param,epsilon,xfe2,yfe2);

%%

for nsim=1:100
    
xptzr=xptz+(3*randn);
yptzr=yptz+(3*randn);
zptzr=zptz+(1.5*randn);

alfa_ptzr=alfa_ptz+(2*pi/180)*randn;%0*pi/180;
beta_ptzr=beta_ptz+(2*pi/180)*randn;
gama_ptzr=gama_ptz+(2*pi/180)*randn;
phiptzr=phiptz+(2*pi/180)*randn;
titaptzr=titaptz+(2*pi/180)*randn;


%simulo un punto observado en la FE [xfe2 yfe2] y sampleo en los parametros
%perturbados al azar segun la incerteza

% [PuntoMundoV] = camarafe_a_mundo_vect([alfa_fer beta_fer gama_fer xfeor yfeor zfeor],[xfe2 yfe2]);
[PuntoMundoV] = camptz_a_mundo_vect_e([alfa_ptzr beta_ptzr gama_ptzr xptzr yptzr zptzr  titaptzr phiptzr ],[xfe2 ;yfe2]);
% xm2=PuntoMundoV(1,:);
% ym2=PuntoMundoV(2,:);

xm4=PuntoMundoV(1);
ym4=PuntoMundoV(2);

vxm4(nsim)=xm4;
vym4(nsim)=ym4;

VV=[];
VV(1,:)=vxm4;
VV(2,:)=vym4;
VV(3,:)=0;

[UVQ]=camptz.project(VV);

xfeQ=UVQ(1,:);
yfeQ=UVQ(2,:); 
 
end

%dibujo elipse tal que caigan en promedio el 90% de los puntos
s = chi2inv(0.90, 2);
  figure(5),hold on,subplot(1,2,1),hold on,plot(vxm4,vym4,'b*','MarkerSize',1),xlim([0 110]),ylim([0 110])
 figure(5),hold on,subplot(1,2,1),hold on,plot(xm2,ym2,'r*'),xlim([0 110]),ylim([0 110])
 figure(5),hold on,subplot(1,2,1),hold on,plot(xm2(np),ym2(np),'ko'),xlim([0 110]),ylim([0 110])
 figure(5),hold on,subplot(1,2,1),plot_ellipse(s*(Cm),[xm2(np),ym2(np)],'r-'),xlim([0 110]),ylim([0 110]),xlabel('X [metros]','FontSize',12),ylabel('Y [metros]','FontSize',12)
figure(5),hold on,subplot(1,2,2),hold on,plot(xfeQ,yfeQ,'b*','MarkerSize',1),xlim([0 1280]),ylim([0 960]),xlabel('u [pixeles]','FontSize',12),ylabel('v [pixeles]','FontSize',12)


    end
    
    end
    
