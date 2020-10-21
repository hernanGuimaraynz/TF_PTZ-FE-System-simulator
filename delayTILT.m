function [ DelayTime ] = delayTILT( delta)

%A partir de datos experimentales para la camara HECKER PTZ
%Hernan Guimaraynz,2019,UNQ.
%entrada => delta : Movimiento de TILT [grados](0 A 90°)
%salida  => DelayTime: delay [milisegundos ]


% Coefficients:
%   p1 = 0.0013388;
%   p2 = -0.22392;
%   p3 = 15.875;
%   p4 = 1.3857;
p1=0.0054321;
p2=4.14;
p3=172.25;


delta=abs(delta);

%   if (delta > 90 )
%        
%      delta=90;%asume que se mueve primero el pan y luego hace el movimiento de tilt .
%      
% DelayTime = p1*delta^2 + p2*delta + p3 ;
% 
% 
%   end



  if (delta > 90 && delta <= 180)
       
      delta=delta-90;
DelayTime = p1*delta^2 + p2*delta + p3 ;


  end



  if (delta >= 0 && delta <= 90)
% DelayTime = p1*delta^3 + p2*delta^2 + p3*delta + p4 ;
DelayTime = p1*delta^2 + p2*delta + p3 ;
  end
  
%   
%   if (delta <= 0 && delta >= -90 )
%   
%   [ DelayPAN ] = delayPAN( 180);%rotacion del pan.
%         
%         delta =-delta;
%   DelayTime = p1*delta^2 + p2*delta + p3 ; 
% % DelayTime = p1*delta^3 + p2*delta^2 + p3*delta + p4 ;
% 
% DelayTime=DelayTime+DelayPAN;
% 
%   end

    
%       if (delta <= -91 )
%   
%   [ DelayPAN ] = delayPAN( 180);%rotacion del pan.
%         
%         delta =delta+180;
%   DelayTime = p1*delta^2 + p2*delta + p3 ; 
% % DelayTime = p1*delta^3 + p2*delta^2 + p3*delta + p4 ;
% 
% DelayTime=DelayTime+DelayPAN;
%   end

  

end

