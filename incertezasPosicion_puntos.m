 clear all
 close all
clc

% run simFE.m
xfeo=43.5; % coord. X de FE en trama {m=0} medida en [m]
yfeo=43.5; % coord. Y de FE en trama {m=0} medida en [m]
zfeo=-15.3; % coord. Z de FE en trama {m=0} medida en [m]

%Angulos de Euler ZYX para la orientacion de la camara FE en trama mundo {0}

% alfa_vca=0.15*pi/180;
% beta_vca=0.2;
% gama_vca=-0.9;

alfa_fe=0*pi/180;
beta_fe=0;
gama_fe=-0;

Tfe = transl(xfeo, yfeo, zfeo) * eulZYX2tr_dami(alfa_fe,beta_fe,gama_fe);
kfe=952.16;%VCA camera's focal length


save paramFE alfa_fe beta_fe gama_fe xfeo yfeo zfeo kfe
%camera 1: VCA camera
Npixfew = 1920; %[pixels]
Npixfeh = 1920; %[pixels]
global camfe
 camfe = FishEyeCamera('name', 'Fisheye',...
                    'projection', 'stereographic',...
                    'resolution', [Npixfew Npixfeh],...
                    'centre', [Npixfew/2 Npixfeh/2], ...
                    'noise',1.0, ...
                    'k', kfe);
camfe.T=Tfe;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y1=52;
Y2=58;
% Ap1(:,1)=[10 Y1 0];
% Ap1(:,2)=[20 Y1 0];
% Ap1(:,3)=[30 Y1 0];
% Ap1(:,4)=[40 Y1 0];
% Ap1(:,5)=[70 Y1 0];
% Ap1(:,6)=[80 Y1 0];
% Ap1(:,7)=[90 Y1 0];
% Ap1(:,8)=[100 Y1 0];
% 
% Ap1(:,9)=[10 Y2 0];
% Ap1(:,10)=[20 Y2 0];
% Ap1(:,11)=[30 Y2 0];
% Ap1(:,12)=[40 Y2 0];
% Ap1(:,13)=[70 Y2 0];
% Ap1(:,14)=[80 Y2 0];
% Ap1(:,15)=[90 Y2 0];
% Ap1(:,16)=[100 Y2 0];



ya1=Y1;
xa1=100;

ya2=Y2;
xa2=10;
[P] =dibujarCalle('FE',4);
[ypred1,ypred2,xmed,ymed,t ,troi ] = dibujarTray( [xa1 ya1],'FE',4 ,1);


[ypred12,ypred22,xmed2,ymed2,t2 ,troi2 ] = dibujarTrayC( [xa2 ya2],'FE',4 ,2);

%PUNTOS SOBRE LOS QUE PONGO LAS ELIPSES
% Ap1(:,1)=[10 Y1 0];
% Ap1(:,2)=[20 Y1 0];
% Ap1(:,3)=[30 Y1 0];
% Ap1(:,4)=[40 Y1 0];
% Ap1(:,5)=[70 Y1 0];
% Ap1(:,6)=[80 Y1 0];
% Ap1(:,7)=[90 Y1 0];
% Ap1(:,8)=[100 Y1 0];

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
A2(1,:)=Ap1(1,:);
A2(2,:)=Ap1(2,:);
A2(3,:)=Ap1(3,:);

[UV2]=camfe.project(A2);%proyecto los puntos del mundo a puntos en la base de la camara 

%puntos del auto en las coord. de la camara FE
xfe2=UV2(1,:);
yfe2=UV2(2,:);
xm2=A2(1,:);
ym2=A2(2,:);

figure(4),subplot(1,2,2),hold on,plot(abs(xfe),abs(yfe),'.r'),hold on,plot(xfe2,yfe2,'.b'),
% plot(xfek,yfek,'g*','LineWidth',2),
grid on,xlim([0 1920]),ylim([0 1920]),

figure(4),subplot(1,2,1),grid on,hold on,plot(xm,ym,'.r'),hold on,plot(xm2,ym2,'.b'),
grid on,xlim([0 110]),ylim([0 110])

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

%%
param(1)=Px;
param(2)=Py;
param(3)=Pz;
param(4)=alfa;
param(5)=beta;
param(6)=gama;
param(7)=camfe.k;

%incertezas
epsilon(1)=3;   %x
epsilon(2)=3;   %y
epsilon(3)=1.5; %z
epsilon(4)=2*pi/180; %alfa
epsilon(5)=2*pi/180; %beta
epsilon(6)=2*pi/180; %gama
epsilon(7)=10; %k
epsilon(8)=1; %xpix
epsilon(9)=1; %ypix

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

 figure(4),hold on,subplot(1,2,1),hold on,plot(xm2,ym2,'r.'),xlim([0 110]),ylim([0 110])
 figure(4),hold on,subplot(1,2,1),hold on,plot(xm2(np),ym2(np),'ko'),xlim([0 110]),ylim([0 110])
 figure(4),hold on,plot_ellipse((Cm),[xm2(np),ym2(np)],'b-'),xlim([0 110]),ylim([0 110])
end