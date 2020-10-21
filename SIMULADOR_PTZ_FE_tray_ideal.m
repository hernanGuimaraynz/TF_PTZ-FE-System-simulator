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

parsError.powAngulo=(0*pi/180);
parsError.powPosicion=0;
parsError.powK=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parsError.ruidoa1=parsError.powAngulo*(randn);
parsError.ruidoa2=parsError.powAngulo*(randn);
parsError.ruidoa3=parsError.powAngulo*(randn);
parsError.ruidoa4=parsError.powAngulo*(randn);
parsError.ruidoa5=parsError.powAngulo*(randn);
parsError.ruidopx=parsError.powPosicion*(randn);
parsError.ruidopy=parsError.powPosicion*(randn);
parsError.ruidoz=(parsError.powPosicion/2)*(randn);

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PuntoMundoInicial=[54.5 54.5];


[ a_ptz,b_ptz  ] = apunte_PTZ( PuntoMundoInicial,phiptzR,titaptzR,Tptz ); %devuelve el valor de pan y tilt tal que el punto deseado aparezca en el pp de la ptz



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
   




 xa2=3;
 ya2=52;

xa3=52.5;
ya3=109.5;

xa4=57;
ya4=3;
 
% xa5=55;
% ya5=52;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%parametros de simulacion.

xa1=0;
ya1=51.75+2*randn;
UbicacionInicialAuto=[xa1 ya1];
ROIint=2;
orientacion=0;
TF=15;%tiempo de simulacion
PARS(1)=11.11;%vx
PARS(2)=0;%vy
PARS(3)=0.8;%ax
PARS(4)=0;%ay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  [ypred1,ypred2,xr,yr,t ,troi,ht,VV,Xest2,Yest2] = dibujarTray(UbicacionInicialAuto,TF,PARS,'FE',4 ,ROIint,'.g');
 
% [ypred1,ypred2,xr,yr ,t,troi,ht,VV,Xest2,Yest2] = estTray(UbicacionInicialAuto, PARS,ROIint,TF );

[ypred1,ypred2,xr,yr ,t,troi,ht,VV,XestP1,YestP1] = estTray2( UbicacionInicialAuto,PARS,ROIint,TF );
% 
% yr=YestP1;
% xr=XestP1;
dibujarTray2( UbicacionInicialAuto,'FE',4 ,xr,yr,'.g');
dibujarTray2( UbicacionInicialAuto,'FE',4 ,ypred1,ypred2,'.k');


 dibujarCalle('FE',4);
 
%   dibujarAuto( [xa ya] ,0,'FE');
 dibujarAuto( UbicacionInicialAuto,orientacion,'FE',4);
%  dibujarAuto( [xa3 ya3] ,1,'FE',4);
% dibujarAuto( [xa4 ya4] ,1,'FE',4);
%  dibujarAuto( [xa5 ya5] ,1,'FE',4)
 dibujarROI( 1,'FE',4 );
 dibujarROI( 2,'FE',4 );
 dibujarROI( 3,'FE' ,4);
 dibujarROI( 4,'FE',4 );




     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% ESTIMACION DE LA VELOCIDAD  %%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
   %velocidad estimada  
VxEst=abs((diff(xr)/ht))*3.6;
VyEst=abs((diff(yr)/ht))*3.6;



   %velocidad real
VxR=abs((diff(VV(1,:))/ht))*3.6;
VyR=abs((diff(VV(2,:))/ht))*3.6;

%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%% GRAFICOS DE TRAYECTORIA VELOCIDAD Y ERRORES DE ESTIMACION  %%%%%%%%%%
%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


   figure(101),subplot(2,2,1:2),hold on,
   plot(xr,yr,'g+-'),
   plot(VV(1,:),VV(2,:),'k.-'),
 xlabel('X [m]','FontSize',13),ylabel('Y [m]','FontSize',13),
 title('Estimacion de la posicion en XY.','FontSize',16),
  legend('Posicion estimada ','Posicion real')
 
    figure(101),subplot(2,2,3),hold on,
  plot(t,yr,'g+-'),
  
    plot(t,VV(2,:),'k.-'),
 xlabel('tiempo [s]','FontSize',13),ylabel('Y [m]','FontSize',13),
 title('Estimacion de la posicion en Y.','FontSize',16),
  legend('Posicion estimada ','Posicion real')
 
    figure(101),subplot(2,2,4),hold on,
   plot(t,xr,'g+-'),
    plot(t,VV(1,:),'k.-'),
 xlabel('tiempo [s]','FontSize',13),ylabel('X [m]','FontSize',13),
 title('Estimacion de la posicion en X.','FontSize',16),
 legend('Posicion estimada ','Posicion real')
 

 
  figure(102),subplot(2,1,1),hold on,
   plot((t(1:end-1)),VyEst,'g*-','LineWidth',3),
    plot((t(1:end-1)),VyR,'k.-'),
 xlabel('tiempo [s]','FontSize',13),ylabel('Vy [km/h]','FontSize',13),
 title(['Estimacion de la velocidad en Y.'],'FontSize',16),
 legend('Velocidad estimada ','Velocidad real')

 figure(102),subplot(2,1,2),hold on,
 plot(t(1:end-1),VxEst,'g*-','LineWidth',3),
  plot(t(1:end-1),VxR,'k.-','LineWidth',1),
 xlabel('tiempo [s]','FontSize',13),ylabel('Vx [km/h]','FontSize',13),
  title(['Estimacion de la velocidad en X.'],'FontSize',16),
    legend('Velocidad estimada ','Velocidad real')

    
   
%%



figure(4),subplot(1,2,1),xlim([0 110]),ylim([0 110]),grid on,hold on,xlabel('X [metros]'),ylabel('Y [metros]','FontSize',12),title('Imagen satelital.Trayectoria Estimada','FontSize',16),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])


figure(4),subplot(1,2,2),title('Imagen camara Fisheye.','FontSize',16)

%%
 dibujarCalle('PTZ',5);
%  dibujarAuto( [xa ya] ,0,'PTZ',5);
%  dibujarAuto( [xa2 ya2],0,'PTZ',5);
%  dibujarAuto( [xa3 ya3] ,1,'PTZ',5);
dibujarAuto( UbicacionInicialAuto ,orientacion,'PTZ',5);

 dibujarROI( 1,'PTZ',5);
 dibujarROI( 2,'PTZ',5 );
 dibujarROI( 3,'PTZ' ,5);
 dibujarROI( 4,'PTZ',5 );
 
% dibujarTray( [xa2 ya2],PARS,'PTZ',5 ,ROIint,'.g');
 figure(5),subplot(1,2,1),xlim([0 110]),ylim([0 110]),grid on,hold on,xlabel('X [metros]'),ylabel('Y [metros]','FontSize',12),title('Imagen satelital.','FontSize',16),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])


figure(5),subplot(1,2,2),title('Imagen Camara PTZ:PTZ en posicion inicial.(t=0 s).','FontSize',16)





%calculo a traves de la trayectoria estimada el punto en coord {m}
%al que tiene que apuntar la PTZ.

PosicionInt=3;%Posicion de intercepcion,en metros antes del fin de la ROI

% [ PuntoMundo,ti,XROI] = calculo_intercepcion(PosicionInt, xr,yr,ROIint);
[ PuntoMundo,ti,XROI] = calculo_intercepcion(PosicionInt, xr,yr,ROIint);


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %CINEMATICA DE APUNTE DE LA PTZ
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 radio=2;%radio de vision de la camara ,es un parametro de entrada con el que se define el tamaño ,[en metros], de objetos que entran en la imagen obtenida [en pixeles]. 

 

 
[ ZOOM] = mundo_a_fov( PuntoMundo,radio,[xptzR yptzR] ) ; %devuelve el nivel de zoom de la ptz para el punto yradio de vision deseado a partir de la posicion de la ptz en {m}.
disp('------------------------------------')
disp('-----------DELAY--------------------')
disp('------------------------------------')
delta_ZOOM=ZOOM-ZOOMinit; 
[ DelayZOOM ] = delayZOOM( delta_ZOOM);


[fptzA] =funcionZoom_PTZ_HERNAN(ZOOM ); %Distancia focal de la ptz medida en [pixels] para cada nivel de zoom de la camara ,de 0 a 100 .   


[ a_ptz,b_ptz  ] = apunte_PTZ( PuntoMundo,phiptzR,titaptzR,Tptz ); %devuelve el valor de pan y tilt tal que el punto deseado aparezca en el pp de la ptz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   phiptz=a_ptz; %PAN
   titaptz=b_ptz; %TILT
   
   
%incerteza
% parsError.ruidoa4=parsError.powAngulo*(randn);
% parsError.ruidoa5=parsError.powAngulo*(randn);
% phiptzR=phiptz+parsError.ruidoa4;
% titaptzR=titaptz+parsError.ruidoa5;
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %DELAY MOVIMIENTO + CAPTURA.
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delta_PAN=(phiptz-PANinit)*180/pi ;
[ DelayPAN ] = delayPAN( delta_PAN);


delta_TILT=(titaptz-TILTinit)*180/pi ;
[ DelayTILT ] = delayTILT(delta_TILT) ; 




[ DelayCapturaFE ] = DelayCapturaFE_function();

[ DelayCapturaPTZ ] = DelayCapturaPTZ_function();



delayTOTAL1=(DelayTILT +DelayPAN +DelayZOOM +DelayCapturaPTZ+DelayCapturaFE)/1000;
delayTOTAL=(max(DelayTILT,DelayPAN) +DelayZOOM +DelayCapturaPTZ+DelayCapturaFE)/1000;

disp('------------------------------------')
disp('------------------------------------')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 Tptz = transl(xptz, yptz, zptz) * eulZYX2tr_dami_ptz(alfa_ptz,beta_ptz,gama_ptz,phiptz,titaptz);%recalcula la trama de {PTZ} respecto de {0}.

camptz.T=Tptz;
camptz.f=fptzA;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%verifico donde apunta realmente la PTZ
[vsalR] = camptz_a_mundo_vect(param,vpixinput);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAFICO POSICION DE INTERSECCION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[xx,tA]=min(abs((delayTOTAL+troi)-t));

%TRAYECTORIA IDEAL
APX =ypred1(tA) ;
APY =ypred2(tA);

dibujarROI( 1,'PTZ' ,90);
dibujarROI( 2,'PTZ',90 );
dibujarROI( 3,'PTZ' ,90);
dibujarROI( 4,'PTZ' ,90);
dibujarCalle('PTZ',90);
 %Reubico el automovil en el espacio despues de trasncurrir el tiempo de delay de apunte de la camara. 
 dibujarAutoM( [APX APY] ,orientacion,'PTZ',90,PuntoMundo(1),PuntoMundo(2));

  dibujarTray2( [APX APY],'PTZ',90 ,ypred1,ypred2,'.k');
%  dibujarTray2( [APX APY],'PTZ',90 ,xr,yr,'.g');
    dibujarTray2([APX APY],'PTZ',90 ,xr,yr,'.g'); 
figure(90),subplot(1,2,1),xlim([0 110]),grid on,ylim([0 110]),xlabel('X [metros]','FontSize',12),ylabel('Y [metros]','FontSize',12),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),hold on,plot(PuntoMundo(1),PuntoMundo(2),'g+','LineWidth',10),title('Camara 2: PTZ Apuntada.','FontSize',16),
legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])

figure(90),subplot(1,2,2),hold on,title(['Camara PTZ en posicion de intercepción(tiempo= ',num2str(delayTOTAL),' s)' ,' Zoom: ' , num2str(ZOOM),'%'],'FontSize',16),
xlabel('u [pixeles]. (Zoom optico de la camara :30X)','FontSize',12),ylabel('v [pixeles]','FontSize',12)

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Momento inicial de grabacion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figII=95;
[xx,tii]=min(abs(85-xr));

if ROIint==1 || ROIint==2

tff=tii+round((35/(mean(VxEst)/3.6))/ht);
else
tff=tii+(30/(mean(VyEst)/ht));   
end


if tii<tA
    
    tii=tA;
end   

%TRAYECTORIA IDEAL
APX =ypred1(tii) ;
APY =ypred2(tii);

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
 %Reubico el automovil en el espacio despues de trasncurrir el tiempo de delay de apunte de la camara. 
 dibujarAutoM( [APX APY] ,orientacion,'PTZ',figII,PuntoMundo(1),PuntoMundo(2));

  dibujarTray2( [APX APY],'PTZ',figII ,ypred1,ypred2,'.k');
 dibujarTray2( [APX APY],'PTZ',figII ,xr,yr,'.g');
figure(figII),subplot(1,2,1),hold on,xlim([0 110]),grid on,ylim([0 110]),xlabel('X [metros]','FontSize',12),ylabel('Y [metros]','FontSize',12),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),hold on,plot(PuntoMundo(1),PuntoMundo(2),'g+','LineWidth',10),title('Camara 2: PTZ Apuntada.','FontSize',16),
legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])

figure(figII),subplot(1,2,2),hold on,title(['Camara PTZ:Imagen en alta resolución.Inicia grabación.(tiempo= ',num2str(t(tii)),' s)' ,' Zoom: ' , num2str(ZOOM),'%'],'FontSize',16),
xlabel('u [pixeles]. (Zoom optico de la camara :30X)','FontSize',12),ylabel('v [pixeles]','FontSize',12)





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAFICO LA DINAMICA DEL AUTOMOVIL.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for n=tA+1:5:(tINT)



% if ROIint==1 || ROIint==2
% [xx,tINT]=min(abs((xr(ti))-ypred1));
% 
% 
% else 
% [xx,tINT]=min(abs((yr(ti))-ypred2));
% end


%  for n=tA+1:5:(ti) 
 
for n=tii:10:tff   
    
    figure(100)
   clf


%TRAYECTORIA IDEAL 
AX =ypred1(n) ;
AY =ypred2(n);

 dibujarCalle('PTZ',100);
 proyPTZ(paramP,100);
% dibujarAuto( [xa ya] ,0,'PTZ',100);
%  dibujarAuto( [xa3 ya3] ,1,'PTZ',100);

 dibujarROI( 1,'PTZ' ,100);
 dibujarROI( 2,'PTZ',100 );
 dibujarROI( 3,'PTZ' ,100);
 dibujarROI( 4,'PTZ' ,100);
 dibujarAutoM( [AX AY] ,orientacion,'PTZ',100,PuntoMundo(1),PuntoMundo(2));
 
 dibujarTray2( [AX AY],'PTZ',100 ,xr,yr,'.g');
  dibujarTray2( [AX AY],'PTZ',100 ,ypred1,ypred2,'.k');

figure(100),subplot(1,2,1),hold on,xlim([0 110]),grid on,ylim([0 110]),
xlabel('X [metros]','FontSize',12),ylabel('Y [metros]','FontSize',12),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),hold on,pI=plot(PuntoMundo(1),PuntoMundo(2),'bh','LineWidth',3),pR=plot(vsalR(1),vsalR(2),'rh','LineWidth',3),title('Camara 2: PTZ Intercepcion.','FontSize',16),
legend([h11; h33;pI;pR],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'],['Punto marcado(ideal):  ','X: ',num2str(PuntoMundo(1)),' Y: ',num2str(PuntoMundo(2))],['Punto marcado (real):  ','X: ',num2str(vsalR(1)),' Y: ',num2str(vsalR(2))])

figure(100),subplot(1,2,2),hold on,title(['Camara PTZ:Imagen en alta resolución.Fin de grabación.(t= ',num2str(t(n)),' s).' ,' Zoom: ' , num2str(ZOOM),'%'],'FontSize',16),
xlabel('u [pixeles]. (Zoom optico de la camara :30X)','FontSize',12),ylabel('v [pixeles]','FontSize',12)


end


%si el tiempo de delay es mas grande que el de interseccion,el sistema no
%alzanza a ver el automovil.
% if  (tA+1)>=(ti)
%     
%     disp('ADVERTENCIA:Vehiculo no alcanzado por la camara PTZ')
% end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


%%




  %%
%  errVX=(abs(VxR-VxEst));
%     errVY=(abs(VyR-VyEst));
%     errY=(abs(ypred2-yr));
%     errX=(abs(ypred1-xr));
%    
%  figure(103),subplot(2,2,1),hold on,
% plot(errY,'-k','LineWidth',2),grid on,ylabel('Posicion [m]','FontSize',14)
%  title('Error en la estimacion de la posicion en Y.','FontSize',16)
%  
% figure(103),subplot(2,2,2),hold on,
% plot(errX,'-k','LineWidth',2),grid on,ylabel('Posicion [m]','FontSize',14)
%  title('Error en la estimacion de la posicion en X.','FontSize',16)  
%    
%  figure(103),subplot(2,2,3),hold on,
% plot((1:1:length(errVY)),errVY,'-b','LineWidth',2),grid on,ylabel('Velocidad [m/s]','FontSize',14)
%  title('Error en la estimacion de la velocidad en Y.','FontSize',16)
% 
% figure(103),subplot(2,2,4),hold on,
% plot(errVX,'-b','LineWidth',2),grid on,ylabel('Velocidad [m/s]','FontSize',14)
%  title('Error en la estimacion de la velocidad en X.','FontSize',16)