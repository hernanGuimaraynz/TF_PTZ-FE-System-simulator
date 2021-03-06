%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULA PUNTOS VISTO POR UNA CAMARA PTZ Y UNA FISHEYE
%
% Y TAMBIEN EL PROCESO DE CALIBRACION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

for nsim=1:10
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUNTOS VISTO POR UNA CAMARA PTZ Y UNA FISHEYE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%P: son las coordenadas (xm,ym,zm) en trama {m}. Notar que supongo zm=0.
%P = mkcube(0.0);

DX=1*7; %m
P(:,1)=[0 0    0];
P(:,2)=[0 0.5 0];
P(:,3)=[0 1.0 0];
P(:,4)=[0.25   0 0];
P(:,5)=[0.25 0.5 0];
P(:,6)=[0.25 1.0 0];

P=DX*P;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUNTOS VISTO POR UNA CAMARA PTZ Y UNA FISHEYE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Trama camaras: Estas tramas son las TCr0. O sea, la matriz de cambio de coordenadas
%de {C} respecto de la base {0} 
amp1rand=0;
amp2rand=0;
%desplazamientos de las camaras en trama {0}
xfeo=43.5+amp1rand*randn; % coord. X de FE en trama {m=0} medida en [m]
yfeo=43.5+amp1rand*randn; % coord. Y de FE en trama {m=0} medida en [m]
zfeo=-15.3+amp1rand*randn; % coord. Z de FE en trama {m=0} medida en [m] 
xptz=43.5+amp2rand*randn; % coord. X de PTZ en trama {m=0} medida en [m]
yptz=43.5+amp2rand*randn; % coord. Y de PTZ en trama {m=0} medida en [m]
zptz=-15.0+amp2rand*randn; % coord. Z de PTZ en trama {m=0} medida en [m]

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
% fptz = 1205/4; %Distancia focal ptz medida en [pixels]
fptz = 1454.4;
% La resoluci�n de nuestra c�mara con lente fisheye es:
Npixfew = 1920; %[pixels]
Npixfeh = 1920; %[pixels]

% La resoluci�n de nuestra c�mara plana*:
Npixptzw = 1280; %[pixels]
Npixptzh = 960; %[pixels]

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creaci�n de la c�mara fisheye usando el toolbox de Corke
% igualmente los calculos que realiza son simples de entender
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

camfe = FishEyeCamera('name', 'Fisheye',...
                    'projection', 'stereographic',...
                    'resolution', [Npixfew Npixfeh],...
                    'centre', [Npixfew/2 Npixfeh/2], ...
                    'noise', 1, ...
                    'k', kfe);
                
% Creaci�n de la c�mara plana
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
figure(1),subplot(1,2,1),plot_sphere(P, 0.05, 'r')
camptz.plot_camera()
title('Camara plana'),grid on
figure(1),set(gca,'ZDir','rev')

%Grafico proyeccion en PTZ
figure(2)
p1 = camptz.plot(P, 'Tcam', camptz.T);
title('Camara plana')
figure(1),subplot(1,2,2),hold on,plot(p1(1,:),p1(2,:),'ro'),xlim([0 1000]),ylim([0 1000]),daspect([1 1 1])

%Grafico proyeccion en FE
figure(3),
p2 = camfe.plot(P, 'Tcam', camfe.T);
title('Camara plana')

disp('---------FE--------------------------')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
ampruido=10*pi/180;
cialfa=0+ampruido*randn; %angulo euler alfa
cibeta=0+ampruido*randn;;
cigama=0+ampruido*randn;;
cixc_m=xfeo+0.5*randn;; %xfe en el plano
ciyc_m=yfeo+0.5*randn;; %yfe en el plano
cizc_m=zfeo+0.5*randn; %zfe en el plano
kfeR=kfe+10*randn; %zfe en el plano
%vector de parametros necesarios para optimizar por cuadrados minimos.
paramfe(1)=cialfa;
paramfe(2)=cibeta;
paramfe(3)=cigama;
paramfe(4)=cixc_m;
paramfe(5)=ciyc_m;
paramfe(6)=cizc_m;
paramfe(7)=kfeR;
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

disp('valores reales de los params')
[alfa_fe,beta_fe,gama_fe,xfeo,yfeo,zfeo]
disp('Cond inicial de los params')
paramfe
disp('convergencia de los params')
paramfe1

errorfeini= [alfa_fe,beta_fe,gama_fe,xfeo,yfeo,zfeo]-paramfe(1:end-1);
errorfefin= [alfa_fe,beta_fe,gama_fe,xfeo,yfeo,zfeo]-paramfe1(1:end-1);

errorfeini(1:3)=errorfeini(1:3)*180/pi;
errorfefin(1:3)=errorfefin(1:3)*180/pi;



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Testeo calibracion de PTZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('-------------------------------------------')
disp('-----------------PTZ-----------------------')

f=camptz.f; %pix
h=zptz;   %m  

%Condiciones iniciales
ampruido=0.5;
cialfa=alfa_ptz+ampruido*randn; %angulo euler alfa
cibeta=beta_ptz+ampruido*randn;
cigama=gama_ptz+ampruido*randn;
cixc_m=xptz+ampruido*randn; %xc en el plano
ciyc_m=yptz+ampruido*randn; %yc en el plano
cizc_m=zptz+ampruido*randn; %zc en el plano

paramptz(1)=cialfa;
paramptz(2)=cibeta;
paramptz(3)=cigama;
paramptz(4)=cixc_m;
paramptz(5)=ciyc_m;
paramptz(6)=cizc_m;
paramptz(7)=(f + (0.05*f)*randn);
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

merrorfeini(nsim,:)=errorfeini;
merrorfefin(nsim,:)=errorfefin;
merrorptzini(nsim,:)=errorptzini;
merrorptzfin(nsim,:)=errorptzfin;


%%%%%%%%%%%%%%% Funciones que utilizo %%%%%%%%%%%%%%% 
%   eulZYX2tr_dami
%   eulZYX2tr_dami_ptz
%   camarafe_a_mundo_vect
%   camptz_a_mundo_vect_270116
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

disp('incerteza en pose FE (inicial/final)')
std(merrorfeini)
std(merrorfefin)

disp('incerteza en pose PTZ (inicial/final)')
std(merrorptzini)
std(merrorptzfin)

% figure(100),
% plot3(P(1,:),P(2,:),P(3,:),'k*')
% grid on
% daspect([1 1 1])
% xlabel('X (m)')
% ylabel('Y (m)')

