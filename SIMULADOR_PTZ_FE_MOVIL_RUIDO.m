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

%%
PuntoMundoInicial=[55 55]
[ a_ptz,b_ptz  ] = apunte_PTZ( PuntoMundoInicial,phiptz,titaptz,Tptz ); %devuelve el valor de pan y tilt tal que el punto deseado aparezca en el pp de la ptz



phiptz=a_ptz; %PAN
titaptz=b_ptz; %TILT
Tptz = transl(xptz, yptz, zptz) * eulZYX2tr_dami_ptz(alfa_ptz,beta_ptz,gama_ptz,phiptz,titaptz);
camptz.T=Tptz;  
   
%%

xa=107;
ya=57;

xa2=5;
ya2=52;

xa3=52.5;
ya3=103;

xa4=57;
ya4=3;
 
% xa5=55;
% ya5=52;
%%

PARS(1)=8;
PARS(2)=0;
PARS(3)=0.5;
 PARS(4)=0;

% vx=PARS(1);
% vy=PARS(2);
% ax=PARS(3);
%  ay=PARS(4);
 
ROIint=2;
orientacion=0;
% [Xest,Yest,XestP,YestP ,t1,troi,dt1,QQ,Xest2,Yest2 ] = dibujarTray( Cc,TF,PARS,camara,r,nroROI ,COLOR)
[ypred1,ypred2,xmed,ymed,t ,troi ] = dibujarTray( [xa2 ya2],10,PARS,'FE',4 ,ROIint,'g');

% [ypred3,ypred4,t2 ,troi2 ] = dibujarTray( [xa2 ya2],'FE',4,2 );
% [ypred5,ypred6,t3 ,troi3 ] = dibujarTray( [xa3 ya3],'FE',4,3 );
% [ypred7,ypred8,t4 ,troi4 ] = dibujarTray( [xa4 ya4],'FE',4,4 );
 dibujarCalle('FE',4);
 dibujarAuto( [xa ya] ,0,'FE');
 dibujarAuto( [xa2 ya2],0,'FE',4)
 dibujarAuto( [xa3 ya3] ,1,'FE',4)
dibujarAuto( [xa4 ya4] ,1,'FE',4)
%  dibujarAuto( [xa5 ya5] ,1,'FE',4)
 dibujarROI( 1,'FE',4 );
 dibujarROI( 2,'FE',4 );
 dibujarROI( 3,'FE' ,4);
 dibujarROI( 4,'FE',4 );







figure(4),subplot(1,2,1),xlim([0 110]),ylim([0 110]),grid on,hold on,xlabel('X [metros]'),ylabel('Y [metros]','FontSize',12),title('Imagen satelital: Trayectoria estimada.','FontSize',16),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])


figure(4),subplot(1,2,2),title('Imagen camara Fisheye:Antes de apuntar la PTZ se estima la trayectoria.','FontSize',16)


 dibujarCalle('PTZ',5);
 dibujarAuto( [xa ya] ,0,'PTZ',5);
 dibujarAuto( [xa2 ya2],0,'PTZ',5)
 dibujarAuto( [xa3 ya3] ,1,'PTZ',5)
dibujarAuto( [xa4 ya4] ,1,'PTZ',5)

 dibujarROI( 1,'PTZ',5);
 dibujarROI( 2,'PTZ',5 );
 dibujarROI( 3,'PTZ' ,5);
 dibujarROI( 4,'PTZ',5 );
 
dibujarTray( [xa4 ya4],'PTZ',5 ,ROIint);
 figure(5),subplot(1,2,1),xlim([0 110]),ylim([0 110]),grid on,hold on,xlabel('X [metros]'),ylabel('Y [metros]','FontSize',12),title('Imagen satelital: Trayectoria estimada.','FontSize',16),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])


figure(5),subplot(1,2,2),title('Imagen Camara PTZ:PTZ en posicion inicial.(t=0 s).','FontSize',16)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%RETROPROYECCION DE camfe AL MUNDO. 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
% [PuntoMundo] = camarafe_a_mundo_vect([alfa_fe beta_fe gama_fe xfeo yfeo zfeo],[Uin Vin]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Se simula una velocidad inicial y acelereacion tal del auto que a 
%este le toma alrededor de 3 segundos cruzar la ROI.

%intercepto el auto xi segundos despues de que este deje la ROI

% [dd,exi]=min(abs(ypred1-1)); 
% ti=exi;

% PuntoMundo= [ypred1(ti) ypred2(ti) ];
 
[ PuntoMundo] = calculo_intercepcion( ypred1,ypred2,ROIint )


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %CINEMATICA DE APUNTE DE LA PTZ
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 radio=1.2;%radio de vision de la camara ,es un parametro de entrada con el que se define el tama�o ,[en metros], de objetos que entran en la imagen obtenida [en pixeles]. 

 

 
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
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %DELAY MOVIMIENTO + CAPTURA.
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delta_PAN=(phiptz-PANinit)*180/pi ;
[ DelayPAN ] = delayPAN( delta_PAN);


delta_TILT=(titaptz-TILTinit)*180/pi ;
[ DelayTILT ] = delayTILT(delta_TILT) ; 

DelayCapturaPTZ=0;
delayTOTAL=(DelayTILT +DelayPAN +DelayZOOM +DelayCapturaPTZ)/1000;
disp('------------------------------------')
disp('------------------------------------')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 Tptz = transl(xptz, yptz, zptz) * eulZYX2tr_dami_ptz(alfa_ptz,beta_ptz,gama_ptz,phiptz,titaptz);%recalcula la trama de {PTZ} respecto de {0}.

camptz.T=Tptz;
camptz.f=fptzA;



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graficos asociados a la simulacion de la observacion de los puntos P
% con las camaras FE y PTZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Reubico el automovil en el espacio despues de trasncurrir el tiempo de delay de apunte de la camara. 

[xx,tA]=min(abs((delayTOTAL+troi)-t));
APX =ypred1(tA) ;
APY =ypred2(tA);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




  dibujarAuto( [xa2 ya2],0,'PTZ',90)
 dibujarAuto( [xa3 ya3] ,1,'PTZ',90)
%  dibujarAuto( [xa4 ya4] ,1,'PTZ',90)
%  dibujarAuto( [xa5 ya5] ,1,'PTZ',90)
  dibujarROI( 1,'PTZ' ,90);
 dibujarROI( 2,'PTZ',90 );
 dibujarROI( 3,'PTZ' ,90);
 dibujarROI( 4,'PTZ' ,90);
 dibujarCalle('PTZ',90);
 dibujarAutoM( [APX APY] ,orientacion,'PTZ',90,PuntoMundo(1),PuntoMundo(2));
%  dibujarTray( [APX APY],'PTZ' ,90);
 dibujarTray2( [APX APY],'PTZ',90 ,ypred1,ypred2);
figure(90),subplot(1,2,1),xlim([0 110]),grid on,ylim([0 110]),xlabel('X [metros]','FontSize',12),ylabel('Y [metros]','FontSize',12),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),hold on,plot(PuntoMundo(1),PuntoMundo(2),'g+','LineWidth',10),title('Camara 2: PTZ Apuntada.','FontSize',16),
legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])

figure(90),subplot(1,2,2),hold on,title(['Camara PTZ en posicion de intercepci�n(tiempo= ',num2str(delayTOTAL),' s)' ,' Zoom: ' , num2str(ZOOM),'%'],'FontSize',16),
xlabel('u [pixeles]. (Zoom optico de la camara :30X)','FontSize',12),ylabel('v [pixeles]','FontSize',12)


for n=tA+1:1:length(t)
    figure(100)
   clf
 

    
  AX =ypred1(n) ;
AY =ypred2(n);
 dibujarCalle('PTZ',100);
 dibujarAuto( [xa2 ya2],0,'PTZ',100)
 dibujarAuto( [xa3 ya3] ,1,'PTZ',100)
%  dibujarAuto( [xa4 ya4] ,1,'PTZ',100)
%  dibujarAuto( [xa5 ya5] ,1,'PTZ',100)
 dibujarROI( 1,'PTZ' ,100);
 dibujarROI( 2,'PTZ',100 );
 dibujarROI( 3,'PTZ' ,100);
 dibujarROI( 4,'PTZ' ,100);
 dibujarAutoM( [AX AY] ,orientacion,'PTZ',100,PuntoMundo(1),PuntoMundo(2));

 dibujarTray2( [AX AY],'PTZ',100 ,ypred1,ypred2)
figure(100),subplot(1,2,1),xlim([0 110]),grid on,ylim([0 110]),
xlabel('X [metros]','FontSize',12),ylabel('Y [metros]','FontSize',12),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),hold on,plot(PuntoMundo(1),PuntoMundo(2),'g+','LineWidth',10),title('Camara 2: PTZ Intercepcion.','FontSize',16),
legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])

figure(100),subplot(1,2,2),hold on,title(['Camara PTZ:Imagen en alta resoluci�n.(t= ',num2str(t(n)),' s).' ,' Zoom: ' , num2str(ZOOM),'%'],'FontSize',16),
xlabel('u [pixeles]. (Zoom optico de la camara :30X)','FontSize',12),ylabel('v [pixeles]','FontSize',12)


% if AX < -0.5
%     break
% end
end
 

