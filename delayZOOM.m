function [ DelayTime ] = delayZOOM( delta)

%A partir de datos experimentales para la camara HECKER PTZ.
%Hernan Guimaraynz,2019,UNQ.
%entrada => delta : Movimiento de ZOOM [%](0 A 100).
%salida  => DelayTime: delay [milisegundos ].


% Coefficients:
%   p1 = 9.7917e-05;
%   p2 = -0.16349;
%   p3 = 46.56;
%   p4 = 33.462;
p1=-0.098596;
p2=39.43;
p3=214.58;

delta=abs(delta);
  if (delta >= 0 && delta <= 100)
% DelayTime = p1*delta^3 + p2*delta^2 + p3*delta + p4 ;
DelayTime = p1*delta^2 + p2*delta + p3 ;
  else 
      disp('ERROR:Parametro de entrada delta_ZOOM fuera de rango')
  end
end
