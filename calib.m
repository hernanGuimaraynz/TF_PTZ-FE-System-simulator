%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULA PUNTOS VISTO POR UNA CAMARA PTZ Y UNA FISHEYE
%
% Y TAMBIEN EL PROCESO DE CALIBRACION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 clear all
 close all
 clc

for n=1:20

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUNTOS VISTO POR UNA CAMARA PTZ Y UNA FISHEYE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%P: son las coordenadas (xm,ym,zm) en trama {m}. Notar que supongo zm=0.
%P = mkcube(0.0);

DX=1; %m
P(:,1)=[60 40 0];
P(:,2)=[60 45 0];
P(:,3)=[60 50 0];
P(:,4)=[65 40 0];
P(:,5)=[65 45 0];
P(:,6)=[65 50 0];
P(:,7)=[70 40 0];
P(:,8)=[70 45 0];
P(:,9)=[70 50 0];
P(:,10)=[75 40 0];
P(:,11)=[75 45 0];
P(:,12)=[75 50 0];
P=DX*P;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUNTOS VISTO POR UNA CAMARA PTZ Y UNA FISHEYE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Trama camaras: Estas tramas son las TCr0. O sea, la matriz de cambio de coordenadas
%de {C} respecto de la base {0} 
amp1rand=0;
amp2rand=0;
%desplazamientos de las camaras en trama {0}
xfeo=43.5+amp1rand*randn; % coord. X de FE en trama {m=0} medida en [m]
yfeo=43.5+amp1rand*randn; % coord. Y de FE en trama {m=0} medida en [m]
zfeo=-15.5+amp1rand*randn; % coord. Z de FE en trama {m=0} medida en [m] 

xptz=43.5+amp2rand*randn; % coord. X de PTZ en trama {m=0} medida en [m]
yptz=43.5+amp2rand*randn; % coord. Y de PTZ en trama {m=0} medida en [m]
zptz=-15+amp2rand*randn; % coord. Z de PTZ en trama {m=0} medida en [m]

%Angulos de Euler ZYX para la orientacion de la camara FE en trama {0}
amp3rand=0*pi/180;
alfa_fe=-0*pi/180+amp3rand*randn;
beta_fe=0*pi/180+amp3rand*randn;
gama_fe=0*pi/180+amp3rand*randn;

%Angulos de Euler ZYX+ZX para la orientacion de la camara PTZ en trama {0}
%Notar que la orientacion descripta por ZYX corresponde a la base de la
%camara PTZ que denomino trama {PTZ0} y luego se le agrega la rotacion ZX
%que corresponde al mecanismo PAN y TILT.

alfa_ptz=0*pi/180+amp3rand*randn;;
beta_ptz=-0*pi/180+amp3rand*randn;;
gama_ptz=0*pi/180+amp3rand*randn;;
phiptz=0*pi/180;  %PAN
titaptz=-0*pi/180; %TILT

%Finalmente Tfe es la Tfe_r_0 es la trama de {FE} respecto de {0}
Tfe = transl(xfeo, yfeo, zfeo) * eulZYX2tr_dami(alfa_fe,beta_fe,gama_fe);
%Finalmente Tptz es la Tptz_r_0 es la trama de {PTZ} respecto de {0}
Tptz = transl(xptz, yptz, zptz) * eulZYX2tr_dami_ptz(alfa_ptz,beta_ptz,gama_ptz,phiptz,titaptz);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definicion de parametros intrinsecos de las camara FE y PTZ

kfe = 952.16; %Distancia focal fe medida en [pixels] 
% fptz = 1250/4; %Distancia focal ptz medida en [pixels]
 fptz = 1454.4; 
% La resolución de nuestra cámara con lente fisheye es:
Npixfew = 1920; %[pixels]
Npixfeh = 1920; %[pixels]

% La resolución de nuestra cámara plana*:
Npixptzw = 1280; %[pixels]
Npixptzh = 960; %[pixels]

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creación de la cámara fisheye usando el toolbox de Corke
% igualmente los calculos que realiza son simples de entender
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global camfe
camfe = FishEyeCamera('name', 'Fisheye',...
                    'projection', 'stereographic',...
                    'resolution', [Npixfew Npixfeh],...
                    'centre', [Npixfew/2 Npixfeh/2], ...
                    'noise', 1, ...
                    'k', kfe);
                
% Creación de la cámara plana
global camptz
camptz = CentralCamera('name', 'Pan-Tilt-Zoom (PTZ)','focal', fptz, ...
'resolution', [Npixptzw Npixptzh], ...
'centre', [Npixptzw/2 Npixptzh/2], ...
'noise', 1, ...
'focal', fptz);

% Poses de las camaras
camptz.T=Tptz;
camfe.T=Tfe;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graficos asociados a la simulacion de la observacion de los puntos P
% con las camaras FE y PTZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%p = camp.project(P, 'Tobj', camp.T);

%Grafico los puntos P y la camara PTZ en 3D
% figure(1),subplot(1,2,1),plot_sphere(P, 0.5, 'r'),xlim([50 80]),ylim([30 60])
% camptz.plot_camera()
% title('Camara plana','FontSize',16),grid on,figure(1),set(gca,'ZDir','rev')
% ,xlabel('X[m]','FontSize',12),ylabel('Y[m]','FontSize',12),box on
% 
% figure(2),subplot(1,2,1),plot_sphere(P, 0.5, 'r'),xlim([50 80]),ylim([30 60])
% camfe.plot_camera(),title('Camara FE','FontSize',16),grid on,set(gca,'ZDir','rev')
% ,xlabel('X[m]','FontSize',12),ylabel('Y[m]','FontSize',12),box on
% 



%Grafico proyeccion en PTZ

p1 = camptz.plot(P, 'Tcam', camptz.T);

% figure(1),subplot(1,2,2),hold on,plot(p1(1,:),p1(2,:),'ro'),xlim([0 Npixptzw]),ylim([0 Npixptzh]),daspect([1 1 1])
% title('Camara plana','FontSize',16),xlabel('u[pix]','FontSize',12),ylabel('v[pix]','FontSize',12),box on


%Grafico proyeccion en FE
 
p2 = camfe.plot(P, 'Tcam', camfe.T);

% figure(2),subplot(1,2,2),hold on,plot(p2(1,:),p2(2,:),'ro'),xlim([0 Npixfew]),ylim([0 Npixfeh]),daspect([1 1 1])
% title('Camara FE','FontSize',16),xlabel('u[pix]','FontSize',12),ylabel('v[pix]','FontSize',12),box on
%%
disp('---------FE--------------------------')

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulo calibracion de FE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kfe=camfe.k; %pix

%Estructura 'parfe' es el conjunto de parametros de la FE que considero
%que conozco perfectamente (no necesitan ajustarse por optimizacion).

global parfe 
parfe.u0=Npixfew/2;
parfe.v0=Npixfeh/2;
parfe.k=kfe;

%Condiciones iniciales supuestas previo a la optimizacion
ampruidoa=sqrt(10)*pi/180;
ampruidop=sqrt(0.5);
ampruidok=sqrt(10);
cialfa=0+ampruidoa*randn; %angulo euler alfa
cibeta=0+ampruidoa*randn;
cigama=0+ampruidoa*randn;
cixc_m=xfeo+ampruidop*randn; %xfe en el plano
ciyc_m=yfeo+ampruidop*randn; %yfe en el plano
cizc_m=zfeo+(ampruidop)*randn; %zfe en el plano
cikfe=kfe+(ampruidok*randn);

%vector de parametros necesarios para optimizar por cuadrados minimos.
paramfe(1)=cialfa;
paramfe(2)=cibeta;
paramfe(3)=cigama;
paramfe(4)=cixc_m;
paramfe(5)=ciyc_m;
paramfe(6)=cizc_m;
paramfe(7)=cikfe;
%Ahora simulo que mis mediciones son la matriz p2 que provienen de la
%proyeccion de los puntos P en la camara FE

vxi_fe=p2(1,:);
vyi_fe=p2(2,:);
vpixinput_fe=[vxi_fe,vyi_fe];
vmapa=[P(1,:),P(2,:)];

%Aca optimizo los parametros param con el modelo de la funcion
%'camarafe_a_mundo_vect.m'. El algoritmo parte de la CI en los parametros
%(param) y me devuelve los parametros optimizados (param1)
paramfe1 = nlinfit(vpixinput_fe,vmapa,@camarafe_a_mundo_vect,paramfe);


%La funcion "camarafe_a_mundo_vect.m" toma los puntos vpixinput_fe de la 
%imagen y devuelve sus coordenadas en el mapa (o sea trama {m}) 

% Si quiero puedo simular en que lugar del mapa estan los puntos
% vpixinput_fe:
%[vsal_fe_mundo] = camarafe_a_mundo_vect(vpixinput_fe,param)

%informo los parametros reales, la condicion inicial y los parametros
%optimizados:

disp('FE: valores reales de los params')
[alfa_fe,beta_fe,gama_fe,xfeo,yfeo,zfeo,kfe]
disp('FE:Cond inicial de los params')
paramfe
disp('FE:convergencia de los params')
paramfe1



errorfeini= [alfa_fe,beta_fe,gama_fe,xfeo,yfeo,zfeo]-paramfe(1:end-1);

errorfefin= [alfa_fe,beta_fe,gama_fe,xfeo,yfeo,zfeo]-paramfe1(1:end-1);

 errorfeini(1:3)=errorfeini(1:3)*180/pi;
 errorfefin(1:3)=errorfefin(1:3)*180/pi;
  
 errorfeini
errorfefin



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Testeo calibracion de PTZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('-------------------------------------------')
disp('-----------------PTZ-----------------------')

f=camptz.f; %pix
h=zptz;   %m  

%Condiciones iniciales
ampruido1=10*pi/180; %10
ampruido2=0.5; %0.5
cialfa=alfa_ptz+(ampruido1*randn); %angulo euler alfa
cibeta=beta_ptz+(ampruido1*randn);
cigama=gama_ptz+(ampruido1*randn);
cixc_m=xptz+(ampruido2*randn); %xc en el plano
ciyc_m=yptz+(ampruido2*randn); %yc en el plano
cizc_m=zptz+(ampruido2)*randn; %zc en el plano

paramptz(1)=cialfa;
paramptz(2)=cibeta;
paramptz(3)=cigama;
paramptz(4)=cixc_m;
paramptz(5)=ciyc_m;
paramptz(6)=cizc_m;
paramptz(7)=1454.4 + sqrt((0.05*1454.4))*randn;

vxi_ptz=p1(1,:);
vyi_ptz=p1(2,:);
vpix_ptz=[vxi_ptz,vyi_ptz];

%vector de entrada: son los puntos de calibracion en trama {0} 
vmapa=[P(1,:),P(2,:)];




global parptz

parptz.x0=Npixptzw/2;
parptz.y0=Npixptzh/2;
parptz.f=fptz;
parptz.tita_tilt=titaptz;
parptz.phi_pan=phiptz;

param1ptz = nlinfit(vpix_ptz,vmapa,@camptz_a_mundo_vect_270116,paramptz);
disp('valores reales de los params')
[alfa_ptz,beta_ptz,gama_ptz,xptz,yptz,zptz]
disp('Cond inicial de los params')
paramptz
disp('convergencia de los params')
param1ptz

errorptzini= [alfa_ptz,beta_ptz,gama_ptz,xptz,yptz,zptz]-paramptz(1:end-1);
errorptzfin= [alfa_ptz,beta_ptz,gama_ptz,xptz,yptz,zptz]-param1ptz(1:end-1);

errorptzini(1:3)=errorptzini(1:3)*180/pi;
errorptzfin(1:3)=errorptzfin(1:3)*180/pi;

% errorptzini
%   errorptzfin




 merrorfeini(n,:)=errorfeini;
 merrorfefin(n,:)=errorfefin;
 merrorptzini(n,:)=errorptzini;
 merrorptzfin(n,:)=errorptzfin;


%%%%%%%%%%%%%%% Funciones que utilizo %%%%%%%%%%%%%%% 
%   eulZYX2tr_dami
%   eulZYX2tr_dami_ptz
%   camarafe_a_mundo_vect
%   camptz_a_mundo_vect_270116
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 end
%%
 disp('incerteza en pose FE (inicial/final)')
 INITFE=std(merrorfeini)
 FINFE=std(merrorfefin)
 
 disp('incerteza en pose PTZ (inicial/final)')
INITPTZ= std(merrorptzini)
 FINPTZ= std(merrorptzfin)
%