 clear all
 close all
 clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUNTOS VISTO POR UNA CAMARA PTZ MOVIL Y UNA CAMARA PLANA FIJA 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Trama camaras: Estas tramas son las TCr0. O sea, la matriz de cambio de 
% coordenadas de {C} respecto de la base {0} 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%POSE CAMARA FISHEYE
%desplazamientos de las camaras en trama mundo {0}
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

%Finalmente Tvca es la trama de {FE} respecto del mundo {0}

Tfe = transl(xfeo, yfeo, zfeo) * eulZYX2tr_dami(alfa_fe,beta_fe,gama_fe);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PTZ CAMERA POSE SIMULATION

%camera displacement in world frame {0}
xptz=43.5; % coord. X , PTZ in world frame {0} measured in [m]
yptz=43.5; % coord. Y , PTZ in world frame {0} measured in [m]
zptz=-15; % coord. Z , PTZ in world frame {0} measured in [m]

% Euler angles ZYX for the camera's orientation in world frame {0}
alfa_ptz=0.0;
beta_ptz=-0.0;
gama_ptz=+0.0;
%PAN and TILT angles modification.
phiptz=-0*pi/180;  %PAN
titaptz=0*pi/180; %TILT

PANinit=phiptz;
TILTinit=titaptz;

% Pose of {camPTZ} in world frame {0}
Tptz = transl(xptz, yptz, zptz) * eulZYX2tr_dami_ptz(alfa_ptz,beta_ptz,gama_ptz,phiptz,titaptz);


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INTRINSIC PARAMETERS DEFINITION

%FOCAL LENGTH

kfe=952.16;%VCA camera's focal length

fptz=1246.33;%PTZ camera's focal length (with zoom in 0%)

ZOOM=0;
ZOOMinit=ZOOM;
% Cameras resolution.

%camera 1: VCA camera
Npixfew = 1920; %[pixels]
Npixfeh = 1920; %[pixels]

%camera 2:PTZ camera
Npixptzw = 1280; %[pixels]
Npixptzh = 960; %[pixels]

%PRINCIPAL POINT.
ppfe=[Npixfew/2 Npixfeh/2];

ppPTZ=[Npixptzw/2 Npixptzh/2];
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%  CAMARA VCA (FISHEYE)
global camfe
 camfe = FishEyeCamera('name', 'Fisheye',...
                    'projection', 'stereographic',...
                    'resolution', [Npixfew Npixfeh],...
                    'centre', [Npixfew/2 Npixfeh/2], ...
                    'noise', 1.00, ...
                    'k', kfe);

% CAMARA PTZ
global camptz
 camptz = CentralCamera('name', 'PTZ','focal', fptz, ...
'resolution', [Npixptzw Npixptzh], ...
'centre', [Npixptzw/2 Npixptzh/2], ...
'noise', 1.00, ...
'focal', fptz);


% Poses de las camaras
camptz.T=Tptz;
camfe.T=Tfe;



xa=105;
ya=57;

xa2=53;
ya2=105;

xa3=5.5;
ya3=51;

xa4=58;
ya4=10;

xa5=55;
ya5=55;


 dibujarCalle('FE',4);
 
 dibujarAuto( [xa ya] ,0,'FE',4);
 dibujarAuto( [xa2 ya2],1,'FE',4)
 dibujarAuto( [xa3 ya3] ,0,'FE',4)
 dibujarAuto( [xa4 ya4] ,1,'FE',4)
 dibujarAuto( [xa5 ya5] ,1,'FE',4)
 
 dibujarROI( 1,'FE',4 );
 dibujarROI( 2,'FE',4 );
 dibujarROI( 3,'FE',4 );
 dibujarROI( 4,'FE',4 );




figure(4),subplot(1,2,1),xlim([0 110]),ylim([0 110]),grid on,hold on,xlabel('X [metros]'),ylabel('Y [metros]','FontSize',12),title('Camara 1 :Camara Fisheye.','FontSize',16),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])



figure(4),subplot(1,2,2),title('Imagen camara 1:Haga click para apuntar la PTZ.','FontSize',16)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%RETROPROYECCION DE camfe AL MUNDO. 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
powAngulo=(1*pi/180);
powPosicion=1.5;

ruidoa1=powAngulo*(randn);
ruidoa2=powAngulo*(randn);
ruidoa3=powAngulo*(randn);
ruidoa4=powAngulo*(randn);
ruidoa5=powAngulo*(randn);
ruidopx=powPosicion*(randn);
ruidopy=powPosicion*(randn);
ruidoz=(powPosicion/2)*(randn);


xptzR= xptz+ruidopx;
yptzR=yptz+ruidopy;
zptzR=zptz+ruidoz;
alfa_ptzR=alfa_ptz+ruidoa1;
beta_ptzR=beta_ptz+ruidoa2;
gama_ptzR=gama_ptz+ruidoa3;
phiptzR=phiptz+ruidoa4;
titaptzR=titaptz+ruidoa5;

ruidoa1FE=powAngulo*(randn);
ruidoa2FE=powAngulo*(randn);
ruidoa3FE=powAngulo*(randn);
ruidopxFE=powPosicion*(randn);
ruidopyFE=powPosicion*(randn);
ruidozFE=(powPosicion/2)*(randn);



alfa_feR =alfa_fe+ruidoa1FE;
beta_feR=beta_fe+ruidoa2FE ;
gama_feR=gama_fe+ruidoa3FE;
xfeoR=xfeo+ruidopxFE;
yfeoR=yfeo+ruidopyFE;
zfeoR=zfeo+ruidozFE;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [Uin ,Vin]=ginput;
%   Uin =960;
%   Vin=960;
 pixP=[Uin Vin];
 
 [PuntoMundo] = camarafe_a_mundo_vect([alfa_feR beta_feR gama_feR xfeoR yfeoR zfeoR],[Uin Vin]);
 
  [PuntoMundoB] = camarafe_a_mundo_vect([alfa_fe beta_fe gama_fe xfeo yfeo zfeo],[Uin Vin]);
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %CINEMATICA DE APUNTE DE LA PTZ
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 radio=2.0;%radio de vision de la camara ,es un parametro de entrada con el que se define el tamaño ,[en metros], de objetos que entran en la imagen obtenida [en pixeles]. 

 

 
[ ZOOM] = mundo_a_fov( PuntoMundo,radio,[xptzR yptzR] ) ; %devuelve el nivel de zoom de la ptz para el punto yradio de vision deseado a partir de la posicion de la ptz en {m}.
disp('------------------------------------')
disp('-----------DELAY--------------------')
disp('------------------------------------')
delta_ZOOM=ZOOM-ZOOMinit; 
[ DelayZOOM ] = delayZOOM( delta_ZOOM);
% PuntoMundo=PuntoMundo';

[fptzA] =funcionZoom_PTZ_HERNAN(ZOOM ); %Distancia focal de la ptz medida en [pixels] para cada nivel de zoom de la camara ,de 0 a 100 .

%%%%%%%%%%%%%% APUNTE SIN RUIDO %%%%%%%%%%%%%%%%%%%%%%%%%%
[ a_ptzB,b_ptzB  ] = apunte_PTZ( PuntoMundo,phiptz,titaptz,Tptz );
 phiptzB=a_ptzB	; %PAN
 titaptzB=b_ptzB; %TILT
 
%  Tptz3 = transl(xptz, yptz, zptz) * eulZYX2tr_dami_ptz(alfa_ptz,beta_ptz,gama_ptz,phiptzB,titaptzB);%recalcula la trama de {PTZ} respecto de {0}.


vpixinput1(1,:)=1280/2;
vpixinput1(2,:)=960/2;

param1(1)=alfa_ptz;
param1(2)=beta_ptz;
param1(3)=gama_ptz;
param1(4)=xptz;
param1(5)=yptz;
param1(6)=zptz;
param1(7)=titaptzB;
param1(8)=phiptzB;

[vsal,T1] = camptz_a_mundo_vect_270116(param1,vpixinput1);
figure(5),subplot(1,2,1),hold on,hpcB=plot(PuntoMundoB(1),PuntoMundoB(2),'K+','LineWidth',5),hpc=plot(vsal(1),vsal(2),'m+','LineWidth',5)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%RUIDO EN LOS PARAMETROS DE LA PTZ%%%%%%%%%%%%%%%%%%%%%%%

[ a_ptzR,b_ptzR  ] = apunte_PTZ( PuntoMundo,phiptzR,titaptzR,Tptz ); %devuelve el valor de pan y tilt tal que el punto deseado aparezca en el pp de la ptz


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   phiptz=a_ptzR; %PAN
   titaptz=b_ptzR; %TILT
   
delta_PAN=(phiptz-PANinit)*180/pi ;
[ DelayPAN ] = delayPAN( delta_PAN);


delta_TILT=(titaptz-TILTinit)*180/pi ;
[ DelayTILT ] = delayTILT(delta_TILT) ; 


delayTOTAL=(DelayTILT +DelayPAN +DelayZOOM)/1000;
disp('------------------------------------')
disp('------------------------------------')

Tptz = transl(xptzR, yptzR, zptzR) * eulZYX2tr_dami_ptz(alfa_ptzR,beta_ptzR,gama_ptzR,phiptz,titaptz);%recalcula la trama de {PTZ} respecto de {0}.
camptz.T=Tptz;

camptz.f=fptzA;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
param(1)=alfa_ptzR;
param(2)=beta_ptzR;
param(3)=gama_ptzR;
param(4)=xptzR;
param(5)=yptzR;
param(6)=zptzR;
param(7)=titaptz;
param(8)=phiptz;
vpixinput(1,:)=1280/2;
vpixinput(2,:)=960/2;
[vsalR] = camptz_a_mundo_vect(param,vpixinput)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graficos asociados a la simulacion de la observacion de los puntos P
% con las camaras FE y PTZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ P ]=dibujarCalle('PTZ',5);
dibujarROI( 1,'PTZ' ,5);
dibujarROI( 2,'PTZ' ,5);
dibujarROI( 3,'PTZ',5 );
dibujarROI( 4,'PTZ' ,5);
[A,PP] =dibujarAuto( [xa ya] ,0,'PTZ',5);
dibujarAuto( [xa2 ya2],1,'PTZ',5)
dibujarAuto( [xa3 ya3] ,0,'PTZ',5)
dibujarAuto( [xa4 ya4] ,1,'PTZ',5)
dibujarAuto( [xa5 ya5] ,1,'PTZ',5)



figure(5),subplot(1,2,1),xlim([0 110]),grid on,ylim([0 110]),xlabel('X [metros]','FontSize',12),ylabel('Y [metros]','FontSize',12),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),hold on,hm=plot(vsalR(1),vsalR(2),'co','LineWidth',3),title('Camara 2: PTZ','FontSize',16),
legend([h11; h33;hpcB;hpc;hm],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz)],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo)],['Punto marcado (deseado):  ','Xm: ',num2str(PuntoMundoB(1)),' Ym: ',num2str(PuntoMundoB(2))],['Punto marcado(retroproyectado por FE) :  ','Xm: ',num2str(vsal(1)),' Ym: ',num2str(vsal(2))],['Punto señalado por la PTZ: ','Xm: ',num2str(vsalR(1)),' Ym: ',num2str(vsalR(2))])

figure(5),subplot(1,2,2),hold on,title(['Camara 2:Camara PTZ.' ,' Zoom: ' , num2str(ZOOM),'%'],'FontSize',16),
xlabel('u [pixeles]. (Zoom optico de la camara :30X)','FontSize',12),ylabel('v [pixeles]','FontSize',12)







