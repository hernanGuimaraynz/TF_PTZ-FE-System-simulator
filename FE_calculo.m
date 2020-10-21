function [  ] = FE_calculo(P,A,PP, xfeo,yfeo,zfeo,alfa_fe,beta_fe,gama_fe,kfe)

tampixfe=1;


Tcrmfe(1,:)=[ cos(alfa_fe)*cos(beta_fe), cos(alfa_fe)*sin(beta_fe)*sin(gama_fe) - cos(gama_fe)*sin(alfa_fe), sin(alfa_fe)*sin(gama_fe) + cos(alfa_fe)*cos(gama_fe)*sin(beta_fe),0];
Tcrmfe(2,:)=[ cos(beta_fe)*sin(alfa_fe), cos(alfa_fe)*cos(gama_fe) + sin(alfa_fe)*sin(beta_fe)*sin(gama_fe), cos(gama_fe)*sin(alfa_fe)*sin(beta_fe) - cos(alfa_fe)*sin(gama_fe),0];
Tcrmfe(3,:)=[          -sin(beta_fe),                                 cos(beta_fe)*sin(gama_fe),                                 cos(beta_fe)*cos(gama_fe),0];
Tcrmfe(4,:)=[ 0, 0, 0, 1];

Tcmfe=transl(xfeo, yfeo, zfeo)*Tcrmfe;%Tfe

Tmrcfe=inv(Tcmfe);

k=kfe;

 Pmfe =P;        
 Pmfe(4,:)=1;          
 PM=Tmrcfe*Pmfe;
 
SS=size(Pmfe);
 for n=1:SS(2)

           R(n) = sqrt(PM(1,n)^2 +PM(2,n)^2+PM(3,n)^2);
           phi(n) = atan2( PM(2,n), PM(1,n) );% arctan (Y/X)
           theta(n) = acos( PM(3,n) / R(n) ); % acos (Z/R)

           
           r(n) = k * tan(theta(n)/2);
           x(n) = r(n) * cos(phi(n));
           y(n) = r(n) * sin(phi(n));

           uv(:,n) = [(x(n)/tampixfe)+(1920/2);( y(n)/tampixfe)+(1920/2)]; 
end


 Pmfe1 =A;        
 Pmfe1(4,:)=1;          
 PM1=Tmrcfe*Pmfe1;
 

 for n=1:length(Pmfe1)

           R1(n) = sqrt(PM1(1,n)^2 +PM1(2,n)^2+PM1(3,n)^2);
           phi1(n) = atan2( PM1(2,n), PM1(1,n) );% arctan (Y/X)
           theta1(n) = acos( PM1(3,n) / R1(n) ); % acos (Z/R)

           
           r1(n) = k * tan(theta1(n)/2);
           x1(n) = r1(n) * cos(phi1(n));
           y1(n) = r1(n) * sin(phi1(n));

           uv1(:,n) = [(x1(n)/tampixfe)+(1920/2);( y1(n)/tampixfe)+(1920/2)]; 
end
 Pmfe2 =PP;        
 Pmfe2(4,:)=1;          
 PM2=Tmrcfe*Pmfe2;
 

 for n=1:length(Pmfe2)

           R2(n) = sqrt(PM2(1,n)^2 +PM2(2,n)^2+PM2(3,n)^2);
           phi2(n) = atan2( PM2(2,n), PM2(1,n) );% arctan (Y/X)
           theta2(n) = acos( PM2(3,n) / R2(n) ); % acos (Z/R)

           
           r2(n) = k * tan(theta2(n)/2);
           x2(n) = r2(n) * cos(phi2(n));
           y2(n) = r2(n) * sin(phi2(n));

           uv2(:,n) = [(x2(n)/tampixfe)+(1920/2);( y2(n)/tampixfe)+(1920/2)]; 
end
 figure(5),subplot(1,2,2),hold on,plot(uv1(1,:),uv1(2,:),'r*'),xlim([0 1920]),ylim([0 1920]),hold on,plot(uv2(1,:),uv2(2,:),'k*'),xlim([0 1920]),ylim([0 1920]),hold on,plot(uv(1,:),uv(2,:),'b*'),
 xlim([0 1920]),ylim([0 1920]),daspect([1 1 1]),title('Camara FE: Toolbox (O) VS cuentas(*)')


end

