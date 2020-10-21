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
                    'noise', 0.00, ...
                    'k', kfe);

% CAMARA PTZ
global camptz
 camptz = CentralCamera('name', 'PTZ','focal', fptz, ...
'resolution', [Npixptzw Npixptzh], ...
'centre', [Npixptzw/2 Npixptzh/2], ...
'noise', 0.00, ...
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [Uin ,Vin]=ginput;
  
 pixP=[Uin Vin];
 
 [PuntoMundo] = camarafe_a_mundo_vect([alfa_fe beta_fe gama_fe xfeo yfeo zfeo],[Uin Vin]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %CINEMATICA DE APUNTE DE LA PTZ
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 radio=1.2;%radio de vision de la camara ,es un parametro de entrada con el que se define el tamaño ,[en metros], de objetos que entran en la imagen obtenida [en pixeles]. 

 

 
[ ZOOM] = mundo_a_fov( PuntoMundo,radio,[xptz yptz] ) ; %devuelve el nivel de zoom de la ptz para el punto yradio de vision deseado a partir de la posicion de la ptz en {m}.
disp('------------------------------------')
disp('-----------DELAY--------------------')
disp('------------------------------------')
delta_ZOOM=ZOOM-ZOOMinit; 
[ DelayZOOM ] = delayZOOM( delta_ZOOM);
% PuntoMundo=PuntoMundo';

[fptzA] =funcionZoom_PTZ_HERNAN(ZOOM ); %Distancia focal de la ptz medida en [pixels] para cada nivel de zoom de la camara ,de 0 a 100 .   


[ a_ptz,b_ptz  ] = apunte_PTZ( PuntoMundo,phiptz,titaptz,Tptz ); %devuelve el valor de pan y tilt tal que el punto deseado aparezca en el pp de la ptz



   phiptz=a_ptz; %PAN
   titaptz=b_ptz; %TILT
   
delta_PAN=(phiptz-PANinit)*180/pi ;
[ DelayPAN ] = delayPAN( delta_PAN);


delta_TILT=(titaptz-TILTinit)*180/pi ;
[ DelayTILT ] = delayTILT(delta_TILT) ; 


delayTOTAL=(DelayTILT +DelayPAN +DelayZOOM)/1000;
disp('------------------------------------')
disp('------------------------------------')
 Tptz = transl(xptz, yptz, zptz) * eulZYX2tr_dami_ptz(alfa_ptz,beta_ptz,gama_ptz,phiptz,titaptz);%recalcula la trama de {PTZ} respecto de {0}.

camptz.T=Tptz;
camptz.f=fptzA;



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
[A,PP] =dibujarAuto( [xa ya] ,0,'PTZ',5)
dibujarAuto( [xa2 ya2],1,'PTZ',5)
dibujarAuto( [xa3 ya3] ,0,'PTZ',5)
dibujarAuto( [xa4 ya4] ,1,'PTZ',5)
dibujarAuto( [xa5 ya5] ,1,'PTZ',5)



figure(5),subplot(1,2,1),xlim([0 110]),grid on,ylim([0 110]),xlabel('X [metros]','FontSize',12),ylabel('Y [metros]','FontSize',12),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),hold on,hm=plot(PuntoMundo(1),PuntoMundo(2),'c+','LineWidth',10),title('Camara 2: PTZ','FontSize',16),
legend([h11; h33;hm],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz)],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo)],['Punto marcado: Xm= ',num2str(PuntoMundo(1)),' Ym= ',num2str(PuntoMundo(2))])

figure(5),subplot(1,2,2),hold on,title(['Camara 2:Camara PTZ.' ,' Zoom: ' , num2str(ZOOM),'%'],'FontSize',16),
xlabel('u [pixeles]. (Zoom optico de la camara :30X)','FontSize',12),ylabel('v [pixeles]','FontSize',12)







