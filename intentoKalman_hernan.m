


close all
clear all
clc

run calib.m
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
kfe=952.16;%VCA camera's focal length
%camera 1: VCA camera
Npixfew = 1920; %[pixels]
Npixfeh = 1920; %[pixels]

%PRINCIPAL POINT.
ppfe=[Npixfew/2 Npixfeh/2];
%  CAMARA VCA (FISHEYE)
% global camfe
 camfe = FishEyeCamera('name', 'Fisheye',...
                    'projection', 'stereographic',...
                    'resolution', [Npixfew Npixfeh],...
                    'centre', [Npixfew/2 Npixfeh/2], ...
                    'noise', 0.00, ...
                    'k', kfe);
camfe.T=Tfe;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%valores iniciales

%velocidad inicial:
%80 km/h =>  22.2 m/s
%60 km/h =>  16.6 m/s
%40 km/h =>  11.1 m/s

% ex0=107;%m
% ey0=55;%m

dt=0.01;
t=[0:dt:7-dt];

% ex0=107;%m
% ey0=55;%m
% vy0=0
% vx0=-16.66
% 
% ax=-0.35;
% ay=0;


ex0=3;%m
ey0=53;%m
rr=0;
vx0=9+rr*(2*rand-1);
vy0=18+rr*(2*rand-1);

ay=-rr*(2*rand-1);
ax=-rr*(2*rand-1);


 ex=ex0+vx0.*t+0.5*ax.*t.^2;%posicion en x 
 ey=ey0+vy0.*t+0.5*ay.*t.^2;%posicion en y 
 
posicionXY(1,:)=ex;
posicionXY(2,:)=ey;
posicionXY(3,:)=0;
[efe]=camfe.project(posicionXY);
  
exU=efe(1,:);
eyV=efe(2,:);

 figure(101),subplot(2,2,1),hold on,
 plot(exU,eyV,'b.-','LineWidth',1),xlim([0 1920]),ylim([0 1920])
 xlabel('u [pix]','FontSize',13),ylabel('v [pix]','FontSize',13),
title('Cámara FE:Trayectoria.','FontSize',16)
 
  
  %%%%%%%%retroproyeccion de FE al mundo%%%%%%%%%%%%%%%%%%%%%%%%%%%
for n=1:length(exU)
    
%ruido de +- 1 pixel
ruidoU=(2*rand-1);
ruidoV=(2*rand-1);

 PosicionMundo(n,:) = camarafe_a_mundo_vect([alfa_fe beta_fe gama_fe xfeo yfeo zfeo],[exU(n)+ruidoU eyV(n)+ruidoV]);
 
 PosicionMundo2(n,:) = camarafe_a_mundo_vect(paramfe1,[exU(n)+ruidoU eyV(n)+ruidoV]);
end

ex=PosicionMundo(:,1)';
ey=PosicionMundo(:,2)';

 ex2=PosicionMundo2(:,1)';
 ey2=PosicionMundo2(:,2)';

 
  
  [p1,S1,mu1] = polyfit(t,ex,2);
    [ypred1,delta1] = polyval(p1,t,S1,mu1);

    [p2,S2,mu2] = polyfit(t,ey,2);
    [ypred2,delta2] = polyval(p2,t,S2,mu2);
    
     [p3,S3,mu3] = polyfit(t,ex,3);
    [ypred3,delta3] = polyval(p3,t,S3,mu3);

    [p4,S4,mu4] = polyfit(t,ey,3);
    [ypred4,delta4] = polyval(p4,t,S4,mu4);
    
    t1=t;
  
 Yest3=p4(1)*((t1-mu4(1))/mu4(2)).^3+p4(2)*((t1-mu4(1))/mu4(2)).^2+p4(3)*((t1-mu4(1))/mu4(2))+p4(4);

 Xest3=p3(1)*((t1-mu3(1))/mu3(2)).^3+p3(2)*((t1-mu3(1))/mu3(2)).^2+p3(3)*((t1-mu3(1))/mu3(2))+p3(4);
   

 Xest2=p1(1)*((t1-mu1(1))/mu1(2)).^2+p1(2)*((t1-mu1(1))/mu1(2))+p1(3);

 Yest2=p2(1)*((t1-mu2(1))/mu2(2)).^2+p2(2)*((t1-mu2(1))/mu2(2))+p2(3);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %Intento KALMAN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 vt=t;      %en segundos;

vxm=ex;  %en m/s;
vym=ey;  %en m/s;

condinc=[vxm(1);vym(1)];

 vt1=vt; 

vtcomp=[1:1:length(vt)];



%estimacion de la trayectoria.
for n=1:length(vt1)
    
    if length(intersect((n),vtcomp))>0, visObjectDetected((n))=1; vdetectedLocation((n),:)=[vxm((n));vym((n))];
    else visObjectDetected((n))=0;vdetectedLocation((n),:)=[NaN;NaN];
    end
    
end

kalmanFilter = []; isTrackInitialized = false;

for n=1:length(vtcomp)
    
   
     isObjectDetected=visObjectDetected(n);
     detectedLocation= vdetectedLocation(n,:);
     
     if ~isTrackInitialized
       if isObjectDetected
         %configureKalmanFilter(MotionModel,InitialLocation,InitialEstimateError,MotionNoise,MeasurementNoise) 

         kalmanFilter = configureKalmanFilter('ConstantAcceleration',condinc, [1 1 1]*0.5, [1, 1, 1]*1e-5, 2);

% %          %kalmanFilter = configureKalmanFilter('ConstantAcceleration',condinc, [1 1 1], [1, 1, 1]*1e-5, 1);
         isTrackInitialized = true;
       end
       
     else 
       if isObjectDetected 
         % Reduce the measurement noise by calling predict, then correct
         predict(kalmanFilter);
         trackedLocation = correct(kalmanFilter, detectedLocation);
         
       else % Object is missing
         trackedLocation = predict(kalmanFilter);
         
       end
      
     end
  
     if n>2;vtrackedLocation(n,:)=trackedLocation;end
     
   end % while   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
 


 %Calculo la velocidad a partir de la 1er derivada de la trayectoria estimada.
 factorv=1/(dt);
  
Vx= (diff(ex)*factorv);
Vy= (diff(ey)*factorv);
 
Vyk=(diff(vtrackedLocation(6:end,2))*factorv);
Vxk=(diff(vtrackedLocation(6:end,1))*factorv);
 
VxEst2= (diff(Xest2)*factorv);
VyEst2= (diff(Yest2)*factorv);

VxEst3=(diff(Xest3)*factorv);
VyEst3=(diff(Yest3)*factorv);
 
vxKALMANmean=mean(Vxk);
vyKALMANmean=mean(Vyk);

if vx0 <0 || vy0 <0 
    
Vx= -(diff(ex)*factorv);
Vy= -(diff(ey)*factorv);
 
Vyk=-(diff(vtrackedLocation(6:end,2))*factorv);
Vxk=-(diff(vtrackedLocation(6:end,1))*factorv);
 
VxEst2=-(diff(Xest2)*factorv);
VyEst2=-(diff(Yest2)*factorv);

VxEst3=-(diff(Xest3)*factorv);
VyEst3=-(diff(Yest3)*factorv);

vxKALMANmean=abs(mean(Vxk))
vyKALMANmean=abs(mean(Vyk))
 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [p1,S1,mu1] = polyfit(t,ex2,2);
    [ypred5,delta1] = polyval(p1,t,S1,mu1);

    [p2,S2,mu2] = polyfit(t,ey2,2);
    [ypred6,delta2] = polyval(p2,t,S2,mu2);
    
     [p3,S3,mu3] = polyfit(t,ex2,3);
    [ypred7,delta3] = polyval(p3,t,S3,mu3);

    [p4,S4,mu4] = polyfit(t,ey2,3);
    [ypred8,delta4] = polyval(p4,t,S4,mu4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure(101),subplot(2,2,2),hold on,
 plot(ex,ey,'b.-','LineWidth',1),
   plot(ex2,ey2,'g*-','LineWidth',1),
 plot(ypred5,ypred6,'k+-','LineWidth',1),
  plot(vtrackedLocation(3:end,1),vtrackedLocation(3:end,2),'r.-','LineWidth',1),hold on,
 plot(Xest2,Yest2,'k.-','LineWidth',2), 
 plot(Xest3,Yest3,'y.-','LineWidth',1),

%  legend('posicion','kalman','pol gr 2','pol gr 3'),
 xlabel('X [m]','FontSize',13),ylabel('Y [m]','FontSize',13),
 title('Estimacion de la trayectoria en el mundo. ','FontSize',16)
 
 
  figure(101),subplot(2,2,4),hold on,
  plot(t,ey,'b.-','LineWidth',1),
  plot(t,ey2,'g*-','LineWidth',1)
  plot(t,ypred6,'k+-','LineWidth',1),
  plot(vt1(3:end),vtrackedLocation(3:end,2),'r-','LineWidth',2),hold on,
  plot(t1,Yest2,'k.-','LineWidth',1), 
  plot(t1,Yest3,'y.-','LineWidth',1),
%   legend('posicion','kalman','pol gr 2','pol gr 3'),
  xlabel('tiempo [s]','FontSize',13),ylabel('Y [m]','FontSize',13),
  title('Estimacion de la trayectoria en Y ','FontSize',16)
  
  
  figure(101),subplot(2,2,3),hold on,
  plot(t,ex,'b*-','LineWidth',1),
  plot(t,ex2,'g.-','LineWidth',1),
  plot(t,ypred5,'k.-','LineWidth',1),
  plot(vt1(6:end),vtrackedLocation(6:end,1),'r.-','LineWidth',1),hold on,
  plot(t1,Xest2,'g.-','LineWidth',1), 
  plot(t1,Xest3,'y.-','LineWidth',1),
%   legend({'posicion','kalman','pol gr 2','pol gr 3'}),
  xlabel('tiempo [s]','FontSize',13),ylabel('X [m]','FontSize',13),
  title('Estimacion de la trayectoria en X','FontSize',16)



  figure(102),subplot(2,1,2),hold on,
  plot(t(1:end-1),Vy,'k.-','LineWidth',1),
     plot(t(1:end-1),diff(ey2)*factorv,'g*-','LineWidth',1),
 plot(t(1:end-1),diff(ypred6)*factorv,'c.-','LineWidth',1),
   plot((vt1(6:end-1)),Vyk,'r.-','LineWidth',1),hold on,
  plot((t1(1:end-1)),VyEst2,'b+-','LineWidth',1), 
  plot(t1(1:end-1),VyEst3,'y.-','LineWidth',1),
%  legend('velocidad','kalman','pol gr 2','pol gr 3'),
 xlabel('tiempo [s]','FontSize',13),ylabel('Vy [m/s]','FontSize',13),
 title('Estimacion de la velocidad en Y.','FontSize',16)

 figure(102),subplot(2,1,1),hold on,
 plot(t(1:end-1),Vx,'k.-','LineWidth',1),
 plot(t(1:end-1),diff(ex2)*factorv,'g*-','LineWidth',1),
 plot(t(1:end-1),diff(ypred5)*factorv,'c.-','LineWidth',1),
  plot((vt1(6:end-1)),Vxk,'r.-','LineWidth',1),hold on,
 plot(t(1:end-1),VxEst2,'b+-','LineWidth',1), 
 plot(t(1:end-1),VxEst3,'y.-','LineWidth',0.5),
%  legend('velocidad','kalman','pol gr 2','pol gr 3'),
 xlabel('tiempo [s]','FontSize',13),ylabel('Vx [m/s]','FontSize',13),
  title('Estimacion de la velocidad en X.','FontSize',16)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure(103),subplot(2,2,1),hold on,
plot(abs(ey-ey2)),grid on,
 title('Error en la estimacion de la posicion en X.','FontSize',16)
figure(103),subplot(2,2,2),hold on,
plot(abs(ex-ex2)),grid on,
 title('Error en la estimacion de la posicion en Y.','FontSize',16)

figure(103),subplot(2,2,3),hold on,
plot(abs(Vx-(diff(ex2)*factorv))),grid on,
 title('Error en la estimacion de la velocidad en X.','FontSize',16)

figure(103),subplot(2,2,4),hold on,
plot(abs(Vy-(diff(ey2)*factorv))),grid on,
 title('Error en la estimacion de la velocidad en Y.','FontSize',16)



