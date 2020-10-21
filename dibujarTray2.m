function [ ] = dibujarTray2( Cc,camara,r ,Xest,Yest,COLOR)

%grafica la trayectoria Xest,Yest dada como parametro a partir de 
% un punto inicial Cc( el centro del auto)

global camfe;
global camptz;



ex0=Cc(1);% coord X del centro del auto [m]
ey0=Cc(2);%coord Y del centro del auto [m]




figNum=r;




figure(figNum),subplot(1,2,1),hold on,plot(Xest,Yest,COLOR,'LineWidth',1),box on,xlim([0 110]),grid on,ylim([0 110])

if strcmp (camara,'PTZ')
    
 p=( camptz.project([Xest; Yest; zeros(1,length(Xest))]));
   
figure(figNum),subplot(1,2,2),hold on,plot(p(1,:),p(2,:),COLOR,'LineWidth',1),box on,xlim([0 110]),ylim([0 110]) 
end


end


