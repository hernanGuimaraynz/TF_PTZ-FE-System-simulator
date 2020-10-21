function [  ] = dibujarROI(nroROI, camara,figNum )
%grafica las areas de interes,dentro de las cuales se estima la velocidad y
%trayectoria futura del automovil.
global camptz
global camfe
if nroROI==1
ymin=45;
ymax=65;
xmin=90;
xmax=110;
end

if nroROI==2
ymin=45;
ymax=65;
xmin=0;
xmax=20;
end
if nroROI==3
ymin=90;
ymax=110;
xmin=45;
xmax=65;
end
if nroROI==4
ymin=0;
ymax=20;
xmin=45;
xmax=65;
end


% if nroROI==1
% ymin=45;
% ymax=65;
% xmin=90;
% xmax=110;
% end
% 
% if nroROI==2
% ymin=45;
% ymax=65;
% xmin=0;
% xmax=20;
% end
% if nroROI==3
% ymin=90;
% ymax=110;
% xmin=45;
% xmax=65;
% end
% if nroROI==4
% ymin=0;
% ymax=20;
% xmin=45;
% xmax=65;
% end


P(:,1)=[xmin ymin 0];
P(:,2)=[xmax ymin 0];
P(:,3)=[xmax ymax 0];
P(:,4)=[xmin ymax 0];
P(:,5)=[xmin ymin 0];




if strcmp(camara,'FE')
    
       
   p2=(camfe.plot(P,'Tcam',camfe.T));
   xpix=1920;
   ypix=1920;
    
else
    
   p2=(camptz.plot(P,'Tcam',camptz.T));
   xpix=1280;
   ypix=960;

end
color1='k*-';
figure(figNum),subplot(1,2,1),hold on,plot3(P(1,(1:2)),P(2,(1:2)),P(3,(1:2)),color1),
hold on,plot3(P(1,(2:3)),P(2,(2:3)),P(3,(2:3)),color1),
hold on,plot3(P(1,(3:4)),P(2,(3:4)),P(3,(3:4)),color1),
hold on,plot3(P(1,(4:5)),P(2,(4:5)),P(3,(4:5)),color1)



 
   


PuntPr=[xpix/2 ypix/2];

color='k*-';

figure(figNum),subplot(1,2,2),hold on,plot(p2(1,(1:2)),p2(2,(1:2)),color),
plot(p2(1,(2:3)),p2(2,(2:3)),color),hold on,plot(p2(1,(3:4)),p2(2,(3:4)),color),
plot(p2(1,(4:5)),p2(2,(4:5)),color),xlim([0 xpix]),ylim([0 ypix]),box on

