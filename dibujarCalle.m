function [ P ] = dibujarCalle(camara ,r )

global camfe
global camptz

DX=1; %m
ac=11;
%interseccion.%%%%%%%%%%%%%%%%%%%%%%%%%%
% P(:,1)=[ac*4 0 0];
% P(:,2)=[ac*4 ac*4 0];
% P(:,3)=[ac*4 ac*5 0];
% P(:,4)=[ac*4 ac*10 0];
% P(:,5)=[ ac*0  ac*5 0];
% P(:,6)=[ ac*4 ac*5 0];
% P(:,7)=[ ac*5 ac*5 0];
% P(:,8)=[ ac*10 ac*5 0];
% P(:,9)=[ ac*5 ac*4 0];
% P(:,10)=[ ac*10 ac*4 0];
% P(:,11)=[ ac*0 ac*4 0];
% P(:,12)=[ ac*4 ac*4 0];
% P(:,13)=[ac*5 0 0];
% P(:,14)=[ac*5 ac*4 0];
% P(:,15)=[ac*5 ac*5 0];
% P(:,16)=[ac*5 ac*10 0];



P(:,1)=[ac*4 -5 0];
P(:,2)=[ac*4 ac*2 0];
P(:,3)=[ac*4 ac*4 0];

P(:,4)=[ac*4 ac*5 0];
P(:,5)=[ac*4 ac*7 0];
P(:,6)=[ac*4 ac*10 0];

P(:,7)=[ -5  ac*5 0];
P(:,8)=[ ac*2  ac*5 0];
P(:,9)=[ ac*4 ac*5 0];

P(:,10)=[ ac*5 ac*5 0];
P(:,11)=[ ac*7 ac*5 0];
P(:,12)=[ ac*10 ac*5 0];

P(:,13)=[ ac*5 ac*4 0];
P(:,14)=[ ac*7 ac*4 0];
P(:,15)=[ ac*10 ac*4 0];

P(:,16)=[ -5 ac*4 0];
P(:,17)=[ ac*2 ac*4 0];
P(:,18)=[ ac*4 ac*4 0];

P(:,19)=[ac*5 -5 0];
P(:,20)=[ac*5 ac*2 0];
P(:,21)=[ac*5 ac*4 0];

P(:,22)=[ac*5 ac*5 0];
P(:,23)=[ac*5 ac*7 0];
P(:,24)=[ac*5 ac*10 0];

P(1,:)=P(1,:)+5;
P(2,:)=P(2,:)+5;
% figure(figNum),subplot(1,2,1),hold on, plot3(P(1,(1:2)),P(2,(1:2)),P(3,(1:2))), plot3(P(1,(3:4)),P(2,(3:4)),P(3,(3:4))),hold on,plot3(P(1,(5:6)),P(2,(5:6)),P(3,(5:6))),plot3(P(1,(7:8)),P(2,(7:8)),P(3,(7:8))),hold on,
% plot3(P(1,(9:10)),P(2,(9:10)),P(3,(9:10))),hold on,plot3(P(1,(11:12)),P(2,(11:12)),P(3,(11:12))),hold on
% ,plot3(P(1,(13:14)),P(2,(13:14)),P(3,(13:14))),hold on,plot3(P(1,(15:16)),P(2,(15:16)),P(3,(15:16)))
% 

figNum=r;



figure(figNum),subplot(1,2,1),hold on, plot3(P(1,(1:2)),P(2,(1:2)),P(3,(1:2))),hold on, plot3(P(1,(2:3)),P(2,(2:3)),P(3,(2:3))),hold on,plot3(P(1,(4:5)),P(2,(4:5)),P(3,(4:5))),
hold on,plot3(P(1,(5:6)),P(2,(5:6)),P(3,(5:6))),hold on,plot3(P(1,(7:8)),P(2,(7:8)),P(3,(7:8))),hold on,
plot3(P(1,(8:9)),P(2,(8:9)),P(3,(8:9))),hold on, plot3(P(1,(10:11)),P(2,(10:11)),P(3,(10:11))),hold on,plot3(P(1,(11:12)),P(2,(11:12)),P(3,(11:12))),hold on,plot3(P(1,(13:14)),P(2,(13:14)),P(3,(13:14))),
hold on, plot3(P(1,(14:15)),P(2,(14:15)),P(3,(14:15))),hold on, 
plot3(P(1,(16:17)),P(2,(16:17)),P(3,(16:17))),hold on,plot3(P(1,(17:18)),P(2,(17:18)),P(3,(17:18))),hold on,plot3(P(1,(19:20)),P(2,(19:20)),P(3,(19:20))),hold on, plot3(P(1,(20:21)),P(2,(20:21)),P(3,(20:21))),
hold on, plot3(P(1,(22:23)),P(2,(22:23)),P(3,(22:23))),hold on,plot3(P(1,(23:24)),P(2,(23:24)),P(3,(23:24))),box on,xlim([0 110]),grid on,ylim([0 110]),xlim([0 110])



if strcmp(camara,'FE')
    
p2 = (camfe.plot(P, 'Tcam', camfe.T));

xpix=1920;
ypix=1920;


else
    
p2 = (camptz.plot(P, 'Tcam', camptz.T));

xpix=1280;
ypix=960;


end

PuntPr=[xpix/2 ypix/2];

figure(figNum),subplot(1,2,2),hold on, plot(p2(1,(1:2)),p2(2,(1:2)),'r'), plot(p2(1,(2:3)),p2(2,(2:3)),'r'),hold on,plot(p2(1,(4:5)),p2(2,(4:5)),'r'),hold on,plot(p2(1,(5:6)),p2(2,(5:6)),'r'),hold on,
plot(p2(1,(7:8)),p2(2,(7:8)),'r'),hold on,plot(p2(1,(8:9)),p2(2,(8:9)),'r'),hold on,plot(p2(1,(10:11)),p2(2,(10:11)),'r'),hold on,plot(p2(1,(11:12)),p2(2,(11:12)),'r'),
hold on,plot(p2(1,(13:14)),p2(2,(13:14)),'r'),hold on,plot(p2(1,(14:15)),p2(2,(14:15)),'r'),hold on,plot(p2(1,(16:17)),p2(2,(16:17)),'r'),hold on,plot(p2(1,(17:18)),p2(2,(17:18)),'r'),
hold on,plot(p2(1,(19:20)),p2(2,(19:20)),'r'),hold on,plot(p2(1,(20:21)),p2(2,(20:21)),'r'),hold on,plot(p2(1,(22:23)),p2(2,(22:23)),'r'),hold on,plot(p2(1,(23:24)),p2(2,(23:24)),'r'),hold on,
plot(PuntPr(1),PuntPr(2),'rh','LineWidth',4),xlim([0 xpix]),ylim([0 ypix]),box on

end

