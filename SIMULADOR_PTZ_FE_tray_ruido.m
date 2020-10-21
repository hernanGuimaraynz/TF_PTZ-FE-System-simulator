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


save paramFE xfeo yfeo zfeo alfa_fe beta_fe gama_fe kfe

fptz=1454.4;%PTZ camera's focal length (with zoom in 0%)

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
                    'noise', 1.0, ...
                    'k', kfe);

% CAMARA PTZ
global camptz
 camptz = CentralCamera('name', 'PTZ','focal', fptz, ...
'resolution', [Npixptzw Npixptzh], ...
'centre', [Npixptzw/2 Npixptzh/2], ...
'noise', 1.0, ...
'focal', fptz);


% Poses de las camaras
camptz.T=Tptz;
camfe.T=Tfe;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ruido PTZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global parsError;

parsError.powAngulo=sqrt(2)*(pi/180);
parsError.powPosicion=sqrt(1.4);
parsError.powK=sqrt(5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parsError.ruidoa1=parsError.powAngulo*(randn);
parsError.ruidoa2=parsError.powAngulo*(randn);
parsError.ruidoa3=parsError.powAngulo*(randn);
parsError.ruidoa4=parsError.powAngulo*(randn);
parsError.ruidoa5=parsError.powAngulo*(randn);
parsError.ruidopx=parsError.powPosicion*(randn);
parsError.ruidopy=parsError.powPosicion*(randn);
parsError.ruidoz=(parsError.powPosicion/2)*(randn);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ruido FE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parsError.ruidoa1FE=parsError.powAngulo*(randn);
parsError.ruidoa2FE=parsError.powAngulo*(randn);
parsError.ruidoa3FE=parsError.powAngulo*(randn);
parsError.ruidopxFE=parsError.powPosicion*(randn);
parsError.ruidopyFE=parsError.powPosicion*(randn);
parsError.ruidozFE=(parsError.powPosicion/2)*(randn);
parsError.ruidokFE=parsError.powK*(randn);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xptzR= xptz+parsError.ruidopx;
yptzR=yptz+parsError.ruidopy;
zptzR=zptz+parsError.ruidoz;
alfa_ptzR=alfa_ptz+parsError.ruidoa1;
beta_ptzR=beta_ptz+parsError.ruidoa2;
gama_ptzR=gama_ptz+parsError.ruidoa3;
phiptzR=phiptz+parsError.ruidoa4;
titaptzR=titaptz+parsError.ruidoa5;

alfa_feR =alfa_fe+parsError.ruidoa1FE;
beta_feR=beta_fe+parsError.ruidoa2FE ;
gama_feR=gama_fe+parsError.ruidoa3FE;
xfeoR=xfeo+parsError.ruidopxFE;
yfeoR=yfeo+parsError.ruidopyFE;
zfeoR=zfeo+parsError.ruidozFE;
kfeR=kfe+parsError.ruidokFE;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Punto en el mundo, para el apunte inicial de la PTZ.
PuntoMundoInicial=[54.5 54.5];

 %Se devuelve el valor de pan y tilt tal que el punto deseado aparezca en el pp de la ptz
[ a_ptz,b_ptz  ] = apunte_PTZ( PuntoMundoInicial,phiptzR,titaptzR,Tptz );



phiptz=a_ptz; %PAN
titaptz=b_ptz; %TILT

%incerteza
parsError.ruidoa4=parsError.powAngulo*(randn);
parsError.ruidoa5=parsError.powAngulo*(randn);
phiptzR=phiptz+parsError.ruidoa4;
titaptzR=titaptz+parsError.ruidoa5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tptz = transl(xptz, yptz, zptz) * eulZYX2tr_dami_ptz(alfa_ptz,beta_ptz,gama_ptz,phiptz,titaptz);
camptz.T=Tptz;  
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PARAMETROS DE SIMULACIONx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%primerose ubica las coordenadas (x,y) del centro del auto
xa=3;
ya=53;
UbicacionInicialAuto=[xa ya];

%region de donde parte el auto
ROIint=2;
%orientacion del auto respecto al eje x. (sirve para graficar solamente, 0 significa horizontal y 1 vertical respecto al eje x )  
orientacion=0;



PARS(1)=18;%Velocidad del auto en el eje x
PARS(2)=0;%%Velocidad del auto en el eje y
PARS(3)=0;%Aceleracion del auto en el eje x 
PARS(4)=0;%Aceleracion del auto en el eje y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tiempo de simulacion (cuanto tiempo se va a mover el auto)
TF=6.5; %CALCULO EL TIEMPO DE SIMULACION PARA LA VELOCIDAD DADA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
%estimo la trayectoria del vehiculo a traves del fiteo de los FP detectados en la imagen FE
[ypred1,ypred2,xr,yr ,t,troi,ht,VV1,VV2,ex,ey,ex2,ey2] = estTray2( UbicacionInicialAuto,PARS,ROIint,TF );


%%%%%%%%% ESTIMACION DE LA VELOCIDAD  %%%%%%%%%%%%%%%%%%%%%%%%
[ VxEst,VyEst,VxR,VyR ] = estVel( VV1,VV2,xr,yr,ROIint,ht );
  

%dibujo las trayectorias 
dibujarTray2( UbicacionInicialAuto,'FE',4 ,ex,ey,'+m');%FP PROYECTADOS IDEAL
dibujarTray2( UbicacionInicialAuto,'FE',4 ,ypred1,ypred2,'.k');%ideal (sin ruido)
 
dibujarTray2( UbicacionInicialAuto,'FE',4 ,ex2,ey2,'+r');%FP PROYECTADOS REAL
dibujarTray2( UbicacionInicialAuto,'FE',4 ,xr,yr,'.g');%estimada (con incerteza en los parametros)



 dibujarCalle('FE',4);
 

 dibujarAuto( UbicacionInicialAuto,orientacion,'FE',4);

 dibujarROI( 1,'FE',4 );
 dibujarROI( 2,'FE',4 );
 dibujarROI( 3,'FE' ,4);
 dibujarROI( 4,'FE',4 );


 
figure(4),subplot(1,2,1),xlim([0 110]),ylim([0 110]),grid on,hold on,xlabel('X [metros]'),ylabel('Y [metros]','FontSize',12),title('Imagen satelital.Trayectoria Estimada','FontSize',16),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])


figure(4),subplot(1,2,2),title('Imagen camara Fisheye.','FontSize',16)


 dibujarCalle('PTZ',5);

dibujarAuto( UbicacionInicialAuto ,orientacion,'PTZ',5);
dibujarTray2( UbicacionInicialAuto,'PTZ',5 ,xr,yr,'.g');%estimada (con incerteza en los parametros)
 dibujarTray2( UbicacionInicialAuto,'PTZ',5 ,ypred1,ypred2,'.k');%ideal (sin ruido)
 dibujarROI( 1,'PTZ',5);
 dibujarROI( 2,'PTZ',5 );
 dibujarROI( 3,'PTZ' ,5);
 dibujarROI( 4,'PTZ',5 );
 


  figure(5),subplot(1,2,1),xlim([0 110]),ylim([0 110]),grid on,hold on,xlabel('X [metros]'),ylabel('Y [metros]','FontSize',12),title('Imagen satelital.','FontSize',16),h11=plot(xptz,yptz,'g+','LineWidth',4)
 ,h33=plot(xfeo,yfeo,'rO','LineWidth',6),legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])
 
figure(5),subplot(1,2,2),title('Imagen Camara PTZ:PTZ en posicion inicial.(t=0 s).','FontSize',16)


 
 %%




%calculo a traves de la trayectoria estimada el punto en coord {m}
%al que tiene que apuntar la PTZ.
PosicionInt=5;%Posicion de intercepcion,en metros antes del fin de la ROI
[ PuntoMundo,ti,XROI] = calculo_intercepcion(PosicionInt, xr,yr,ROIint);


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %CINEMATICA DE APUNTE DE LA PTZ
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 radio=2;%radio de vision de la camara ,es un parametro de entrada con el que se define el tamaño ,[en metros], de objetos que entran en la imagen obtenida [en pixeles]. 

 

 %devuelve el nivel de zoom de la ptz para el punto yradio de vision deseado a partir de la posicion de la ptz en {m}.
[ ZOOM] = mundo_a_fov( PuntoMundo,radio,[xptzR yptzR] ) ; 





[fptzA] =funcionZoom_PTZ_HERNAN(ZOOM ); %Distancia focal de la ptz medida en [pixels] para cada nivel de zoom de la camara ,de 0 a 100 .   


[ a_ptz,b_ptz  ] = apunte_PTZ( PuntoMundo,phiptzR,titaptzR,Tptz ); %devuelve el valor de pan y tilt tal que el punto deseado aparezca en el pp de la ptz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   phiptz=a_ptz; %PAN
   titaptz=b_ptz; %TILT
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %CALCULO DEL DELAY MOVIMIENTO + CAPTURA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delta_PAN=(phiptz-PANinit)*180/pi ;
[ DelayPAN ] = delayPAN( delta_PAN);


delta_TILT=(titaptz-TILTinit)*180/pi ;
[ DelayTILT ] = delayTILT(delta_TILT) ; 

delta_ZOOM=ZOOM-ZOOMinit; 
[ DelayZOOM ] = delayZOOM( delta_ZOOM);


[ DelayCapturaFE ] = DelayCapturaFE_function();

[ DelayCapturaPTZ ] = DelayCapturaPTZ_function();

delayTOTAL=(max(DelayTILT,DelayPAN) +DelayZOOM +DelayCapturaPTZ+DelayCapturaFE)/1000;



%recalcula la trama de {PTZ} respecto de {0}.
Tptz = transl(xptz, yptz, zptz) * eulZYX2tr_dami_ptz(alfa_ptz,beta_ptz,gama_ptz,phiptz,titaptz);

camptz.T=Tptz;
camptz.f=fptzA;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%VERIFICO DONDE APUNTA REALMENTE LA PTZ.
param(1)=alfa_ptz;
param(2)=beta_ptz;
param(3)=gama_ptz;
param(4)=xptz;
param(5)=yptz;
param(6)=zptz;
param(7)=titaptz;
param(8)=phiptz;

vpixinput(1,:)=1280/2;
vpixinput(2,:)=960/2;

[vsalR] = camptz_a_mundo_vect(param,vpixinput);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAFICO : FIN DE MOVIMIENTO DE APUNTE DE LA PTZ.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ tA ] = tf_apunte_PTZ( t,delayTOTAL,troi);%calcula el tiempo en el que la camara ya esta apuntada.


%TRAYECTORIA IDEAL
APX =ypred1(tA) ;
APY =ypred2(tA);
dibujarTray2( [APX APY],'PTZ',90 ,ypred1,ypred2,'.k');
dibujarTray2( [APX APY],'PTZ',90 ,xr,yr,'.g');
dibujarROI( 1,'PTZ' ,90);
dibujarROI( 2,'PTZ',90 );
dibujarROI( 3,'PTZ' ,90);
dibujarROI( 4,'PTZ' ,90);
dibujarCalle('PTZ',90);
 %Reubico el automovil en el espacio despues de trasncurrir el tiempo de delay de apunte de la camara. 
 dibujarAutoM( [APX APY] ,orientacion,'PTZ',90,PuntoMundo(1),PuntoMundo(2));


figure(90),subplot(1,2,1),xlim([0 110]),grid on,ylim([0 110]),xlabel('X [metros]','FontSize',12),ylabel('Y [metros]','FontSize',12),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),hold on,plot(PuntoMundo(1),PuntoMundo(2),'g+','LineWidth',10),title('Camara 2: PTZ Apuntada.','FontSize',16),
legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])

figure(90),subplot(1,2,2),hold on,title(['Camara PTZ en posicion de intercepción(tiempo= ',num2str(t(tA)),' s)' ,' Zoom: ' , num2str(ZOOM),'%'],'FontSize',16),
xlabel('u [pixeles]. (Zoom optico de la camara :30X)','FontSize',12),ylabel('v [pixeles]','FontSize',12)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GRAFICO: MOMENTO INICIAL DE INTERCEPCION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figII=95;
%calcula el timepo inicial y final de grabacion en funcion de la velocidad estimada del automóvil.
[ tii,tff] = t_Grabacion(ROIint,xr,yr,VxEst,VyEst,ht,tA );


%TRAYECTORIA real del auto.
APX2 =ypred1(tii) ;
APY2 =ypred2(tii);

paramP(1)=alfa_ptz;
paramP(2)=beta_ptz;
paramP(3)=gama_ptz;
paramP(4)=xptz;
paramP(5)=yptz;
paramP(6)=zptz;
paramP(7)=titaptz;
paramP(8)=phiptz;
proyPTZ(paramP,figII );


 dibujarROI( 1,'PTZ' ,figII);
 dibujarROI( 2,'PTZ',figII );
 dibujarROI( 3,'PTZ' ,figII);
 dibujarROI( 4,'PTZ' ,figII);
 dibujarCalle('PTZ',figII);
 dibujarTray2( [APX2 APY2],'PTZ',figII ,ypred1,ypred2,'.k');
dibujarTray2( [APX2 APY2],'PTZ',figII ,xr,yr,'.g');
 %Reubico el automovil en el espacio despues de trasncurrir el tiempo de delay de apunte de la camara. 
 dibujarAutoM( [APX2 APY2] ,orientacion,'PTZ',figII,PuntoMundo(1),PuntoMundo(2));


figure(figII),subplot(1,2,1),hold on,xlim([0 110]),grid on,ylim([0 110]),xlabel('X [metros]','FontSize',12),ylabel('Y [metros]','FontSize',12),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),hold on,plot(PuntoMundo(1),PuntoMundo(2),'g+','LineWidth',10),title('Camara 2: PTZ Apuntada.','FontSize',16),
legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])

figure(figII),subplot(1,2,2),hold on,title(['Imagen en alta resolución.Inicia grabación.(tiempo= ',num2str(t(tii)),' s)' ,' Zoom: ' , num2str(ZOOM),'%'],'FontSize',16),
xlabel('u [pixeles]. (Zoom optico de la camara :30X)','FontSize',12),ylabel('v [pixeles]','FontSize',12)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAFICO LA DINAMICA DEL AUTOMOVIL.INTERCEPCION.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n=tii:1:tff   
    
    figure(100)
   clf


%TRAYECTORIA REAL DEL AUTO. 
AX =ypred1(n) ;
AY =ypred2(n);

 dibujarCalle('PTZ',100);
 proyPTZ(paramP,100);%proyecto el campo de vision de la PTZ en el mundo.
 dibujarROI( 1,'PTZ' ,100);
 dibujarROI( 2,'PTZ',100 );
 dibujarROI( 3,'PTZ' ,100);
 dibujarROI( 4,'PTZ' ,100);
  dibujarTray2( [AX AY],'PTZ',100 ,xr,yr,'.g');
 dibujarTray2( [AX AY],'PTZ',100 ,ypred1,ypred2,'.k');
 dibujarAutoM( [AX AY] ,orientacion,'PTZ',100,PuntoMundo(1),PuntoMundo(2));
 

figure(100),subplot(1,2,1),hold on,xlim([0 110]),grid on,ylim([0 110]),
xlabel('X [metros]','FontSize',12),ylabel('Y [metros]','FontSize',12),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6);hold on,pI=plot(PuntoMundo(1),PuntoMundo(2),'bh','LineWidth',3),pR=plot(vsalR(1),vsalR(2),'rh','LineWidth',3),title('Camara 2: PTZ Intercepcion.','FontSize',16),
legend([h11; h33;pI;pR],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'],['Punto marcado(ideal):  ','X: ',num2str(PuntoMundo(1)),' Y: ',num2str(PuntoMundo(2))],['Punto marcado (real):  ','X: ',num2str(vsalR(1)),' Y: ',num2str(vsalR(2))])

figure(100),subplot(1,2,2),hold on,title(['Imagen en alta resolución.Fin de grabación.(t= ',num2str(t(n)),' s).' ,' Zoom: ' , num2str(ZOOM),'%'],'FontSize',16),
xlabel('u [pixeles]. (Zoom optico de la camara :30X)','FontSize',12),ylabel('v [pixeles]','FontSize',12)


end


%%
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%% GRAFICOS DE TRAYECTORIA Y VELOCIDAD  %%%%%%%%%%
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


   figure(101),subplot(2,2,1:2),hold on,
  plot(xr,yr,'b.-'),
   plot(ypred1,ypred2,'r+-'),
 xlabel('X [m]','FontSize',13),ylabel('Y [m]','FontSize',13),
 title('Estimacion de la posicion en XY.','FontSize',16),
  legend('Posicion estimada ','Posicion real')
 
    figure(101),subplot(2,2,3),hold on,
  plot(t,yr,'b.-'),
    plot(t,ypred2,'r+-'),
 xlabel('tiempo [s]','FontSize',13),ylabel('Y [m]','FontSize',13),
 title('Estimacion de la posicion en Y.','FontSize',16),
  legend('Posicion estimada ','Posicion real')
 
    figure(101),subplot(2,2,4),hold on,
  plot(t,xr,'b.-'),
    plot(t,ypred1,'r+-'),
 xlabel('tiempo [s]','FontSize',13),ylabel('X [m]','FontSize',13),
 title('Estimacion de la posicion en X.','FontSize',16),
 legend('Posicion estimada ','Posicion real')
 

 
  figure(102),subplot(2,1,1),hold on,
  plot((t(1:end-1)),VyEst,'b*-','LineWidth',2),
    plot((t(1:end-1)),VyR,'r.-'),
%     plot((t(1:end-1)),vmeanY,'go-'),
 xlabel('tiempo [s]','FontSize',13),ylabel('Vy [km/h]','FontSize',13),
 title(['Estimacion de la velocidad en Y.'],'FontSize',16),
 legend('Velocidad estimada ','Velocidad real')

 figure(102),subplot(2,1,2),hold on,
 plot(t(1:end-1),VxEst,'b*-','LineWidth',2),
  plot(t(1:end-1),VxR,'r.-','LineWidth',1),
%  plot((t(1:end-1)),vmeanX,'go-','LineWidth',1),
 xlabel('tiempo [s]','FontSize',13),ylabel('Vx [km/h]','FontSize',13),
  title(['Estimacion de la velocidad en X.'],'FontSize',16),
    legend('Velocidad estimada ','Velocidad real')

    
   



  %%
  
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% GRAFICOS DE ERROR DE ESTIMACION %%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 errVX=(abs(VxR-VxEst));
    errVY=(abs(VyR-VyEst));
    errY=(abs(ypred2-yr));
    errX=(abs(ypred1-xr));
   
 figure(103),subplot(2,2,1),hold on,
plot(errY,'-k','LineWidth',2),grid on,ylabel('Posicion [m]','FontSize',14)
 title('Error en la estimacion de la posicion en Y.','FontSize',16)
 
figure(103),subplot(2,2,2),hold on,
plot(errX,'-k','LineWidth',2),grid on,ylabel('Posicion [m]','FontSize',14)
 title('Error en la estimacion de la posicion en X.','FontSize',16)  
   
 figure(103),subplot(2,2,3),hold on,
plot((1:1:length(errVY)),errVY,'-b','LineWidth',2),grid on,ylabel('Velocidad [m/s]','FontSize',14)
 title('Error en la estimacion de la velocidad en Y.','FontSize',16)

figure(103),subplot(2,2,4),hold on,
plot(errVX,'-b','LineWidth',2),grid on,ylabel('Velocidad [m/s]','FontSize',14)
 title('Error en la estimacion de la velocidad en X.','FontSize',16)