function [ ZOOM ] = mundo_a_fov( PuntoMundo,radio,PmPTZ )

%IN 1:PuntoMund : un punto en coord del mundo {m} al que se quiera apuntarcon la ptz
%IN 2:radio: radio del campo de vision deseado en la imagen de la ptz.
%IN 3:PmPTZ : la posicion de la ptz en el mundo{m}.

%OUT:nivel de zoom de la ptz
%calculo los posibles valores de  angulos de fov en funcion de los
%valores de distancia focal para [0 10 20 30 40 50 60 70 80 90 100].

vz=[0 10 20 30 40 50 60 70 80 90 100];
vdf=(285.83.*vz)+1454.4;
%uso el angulo para el eje y ya que el sensor es mas chico en ese eje.
roy=1;

vfovy=180/pi* 2*atan((960/(2*roy))./(vdf));

vfovx=180/pi* 2*atan((1280/(2*roy))./(vdf));

%  vfovl=[42.12 16.82 7.71 5.49 4.18 3.34 2.95 2.53 2.02 1.98 1.96];


% 
% PuntoMundo=[PuntoMundo(1) PuntoMundo(2)];

% xn=sqrt((PuntoMundo(1)-PmPTZ(1))^2 +(PuntoMundo(2)-PmPTZ(2))^2  ) ;

xn=norm (PuntoMundo-PmPTZ) ;

fovT=2*(atan(radio/xn));

 fovT=fovT*180/pi ;


[xx,ii]=min(abs(vfovy-fovT));

FOV=vfovy(ii)
ZOOM=vz(ii);

end

