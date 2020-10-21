% clear all
%  close all
%  clc

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


[P] =dibujarCalle('FE',4);


Y1=50;
Y2=58;
Ap1(:,1)=[10 Y1 0];
Ap1(:,2)=[20 Y1 0];
Ap1(:,3)=[30 Y1 0];
Ap1(:,4)=[40 Y1 0];
Ap1(:,5)=[70 Y1 0];
Ap1(:,6)=[80 Y1 0];
Ap1(:,7)=[90 Y1 0];
Ap1(:,8)=[100 Y1 0];

Ap1(:,9)=[10 Y2 0];
Ap1(:,10)=[20 Y2 0];
Ap1(:,11)=[30 Y2 0];
Ap1(:,12)=[40 Y2 0];
Ap1(:,13)=[70 Y2 0];
Ap1(:,14)=[80 Y2 0];
Ap1(:,15)=[90 Y2 0];
Ap1(:,16)=[100 Y2 0];

 figure(4),subplot(1,2,1),plot3(Ap1(1,:),Ap1(2,:),Ap1(3,:),'k.'),box on
% [Ap1,PPp1]=dibujarAuto( [xa ya] ,0,'FE',4);
% [Ap2,PPp2]= dibujarAuto( [xa2 ya2],1,'FE',4)
% [Ap3,PPp3]=  dibujarAuto( [xa3 ya3] ,0,'FE',4)
% [Ap4,PPp4]=  dibujarAuto( [xa4 ya4] ,1,'FE',4)
% [Ap5,PPp5]=  dibujarAuto( [xa5 ya5] ,1,'FE',4)
 
 dibujarROI( 1,'FE',4 );
 dibujarROI( 2,'FE',4 );
 dibujarROI( 3,'FE',4 );
 dibujarROI( 4,'FE' ,4);

figure(4),subplot(1,2,1),xlim([0 110]),ylim([0 110]),grid on,hold on,xlabel('X [metros]'),ylabel('Y [metros]','FontSize',12),title('Imagen satelital.','FontSize',16),h11=plot(xptz,yptz,'g+','LineWidth',4)
,h33=plot(xfeo,yfeo,'rO','LineWidth',6),legend([h11; h33],['Camara PTZ:  ','X: ',num2str(xptz),' Y: ',num2str(yptz) ,' Altura: ',num2str(-zptz),'m'],['Camara FE:  ','X: ',num2str(xfeo),' Y: ',num2str(yfeo) ,' Altura: ',num2str(-zfeo),'m'])

A2= camfe.plot(Ap1, 'Tcam', camfe.T);

xpix=1920;
ypix=1920;


figure(4),subplot(1,2,2),hold on,plot(A2(1,:),A2(2,:),'k.'),xlim([0 xpix]),ylim([0 ypix]),box on
figure(4),subplot(1,2,2),title('Imagen Camara 	Fisheye:Escena de transito.','FontSize',16),grid on
PuntPr=[xpix/2 ypix/2];

ya1=Y1;
xa1=100;

ya2=Y2;
xa2=10;

  [ypred1,ypred2,xmed,ymed,t ,troi ] = dibujarTray( [xa1 ya1],'FE',4 ,1);


  [ypred1,ypred2,xmed,ymed,t ,troi ] = dibujarTray( [xa2 ya2],'FE',4 ,2);


