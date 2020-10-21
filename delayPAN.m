function [ DelayTime ] = delayPAN( delta)

%A partir de datos experimentales para la camara HECKER PTZ
%Hernan Guimaraynz,2019,UNQ.
%entrada => delta : Movimiento de PAN [grados](0 A 180°)
%salida  => DelayTime: delay [milisegundos ]

% Coefficients:
%   p1 = 0.00019845;
p1=-0.0075309;
p2=4.8744;
p3=192.75;
%   p2 = -0.074709;
%   p3 = 11.635;
%   p4 = 0.32857;

delta=abs(delta);

  if (delta >= 0 && delta <= 180)

DelayTime = p1*delta^2 + p2*delta + p3 ;
  end
      
%    if  delta < 0   
%        
%        delta=  delta+180;
%     
%        DelayTime = p1*delta^2 + p2*delta + p3 ;
%       
%    end

     if  delta > 180   
       
       delta=  360-delta;
    
      DelayTime = p1*delta^2 + p2*delta + p3 ;
     end
  
end

