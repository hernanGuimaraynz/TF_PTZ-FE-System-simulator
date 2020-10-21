function [Xest,Yest,t1,troi ] = dibujarTrayC( Cc,camara,r,nroROI,powAngulo,powPosicion,powK )

global camfe;
global camptz;

load paramFE.mat

ex0=Cc(1);%m
ey0=Cc(2);%m



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

v=16;%m/s

if nroROI ==1 || nroROI ==2
vx0=((-1)^nroROI)*v;%m/s
vy0=((-1)^nroROI)*v*0;%m/s

else
  vx0=((-1)^nroROI)*v*0;%m/s
vy0=((-1)^nroROI)*v;%m/s  
    
end

ax=0;
ay=0;

% t=[0:0.5:3];
% t1=t;
dt=0.001;
t=[0:dt:3-dt];

t1=[0:(dt*2):6-(dt*2)];%tiempo de simulacion de movimiento el auto



ex=ex0+vx0.*t+0.5.*ax.*t.^2;%posicion en x 
ey=ey0+vy0.*t+0.5.*ay.*t.^2;%posicion en y 


  
  
  
  if nroROI==1
  XROI=xmin;
   [qq,tq]=min(abs(XROI-ex)) ;
  end
    if nroROI==2
  XROI=xmax;
   [qq,tq]=min(abs(XROI-ex)) ;
    end
    if nroROI==3
  yROI=ymin;
   [qq,tq]=min(abs(yROI-ey)) ;
    end
    if nroROI==4
  yROI=ymax;
   [qq,tq]=min(abs(yROI-ey)) ;
  end
  
  

 t=t(1:tq);
 troi=t(tq);
 ex=ex(1:tq); 
 ey=ey(1:tq);
   
%%%%%fiteo con polinomios de grado 2 %%%%%%%%%
  [p1,S1,mu1] = polyfit(t,ex,2);
    [ypred1,delta1xx] = polyval(p1,t,S1,mu1);

    [p2,S2,mu2] = polyfit(t,ey,2);
    [ypred2,delta2yy] = polyval(p2,t,S2,mu2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figNum=r;
if strcmp(camara, 'FE')
    
    figNum=4;

end

%con los valores del fiteo ,predigo la posicion del auto.
 Xest=p1(1)*((t1-mu1(1))/mu1(2)).^2+p1(2)*((t1-mu1(1))/mu1(2))+p1(3);

 Yest=p2(1)*((t1-mu2(1))/mu2(2)).^2+p2(2)*((t1-mu2(1))/mu2(2))+p2(3);

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % TRAYECTORIA OBTENIDA DESDE LA FISHEYE 
posicionXY(1,:)=ex;
posicionXY(2,:)=ey;
posicionXY(3,:)=0;

[efe]=camfe.project(posicionXY);
  
exU=efe(1,:);
eyV=efe(2,:);




ruidoa1FE=powAngulo*(randn);
ruidoa2FE=powAngulo*(randn);
ruidoa3FE=powAngulo*(randn);
ruidopxFE=powPosicion*(randn);
ruidopyFE=powPosicion*(randn);
ruidozFE=(powPosicion/2)*(randn);
ruidoKFE=powK*(randn);

alfa_feR =alfa_fe+ruidoa1FE;
beta_feR=beta_fe+ruidoa2FE ;
gama_feR=gama_fe+ruidoa3FE;
xfeoR=xfeo+ruidopxFE;
yfeoR=yfeo+ruidopyFE;
zfeoR=zfeo+ruidozFE;
kfeR=kfe+ruidoKFE;

for n=1:length(exU)
    


 PosicionMundo(n,:) = camarafe_a_mundo_vect([alfa_fe beta_fe gama_fe xfeo yfeo zfeo kfeR],[exU(n) eyV(n)]);
 
 PosicionMundo2(n,:) = camarafe_a_mundo_vect([alfa_feR beta_feR gama_feR xfeoR yfeoR zfeoR kfeR],[exU(n) eyV(n)]);
end

ex1=PosicionMundo(:,1)';
ey1=PosicionMundo(:,2)';

 ex2=PosicionMundo2(:,1)';
 ey2=PosicionMundo2(:,2)';
 
 %%%%%%%%%fiteo de polinomio de grado 2  %%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  [p4,S4,mu4] = polyfit(t,ex2,2);
    [ypred5,delta3] = polyval(p1,t,S1,mu1);

    [p5,S5,mu5] = polyfit(t,ey2,2);
    [ypred6,delta4] = polyval(p2,t,S2,mu2);
    
 XestP=p4(1)*((t1-mu4(1))/mu4(2)).^2+p4(2)*((t1-mu4(1))/mu4(2))+p4(3);

 YestP=p5(1)*((t1-mu5(1))/mu5(2)).^2+p5(2)*((t1-mu5(1))/mu5(2))+p5(3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(figNum),subplot(1,2,1),hold on,plot(Xest,Yest,'k.','LineWidth',1),box on,hold on,plot(ypred1,ypred2,'r.','LineWidth',1),
plot(ypred5,ypred6,'m.','LineWidth',1),plot(XestP,YestP,'c.','LineWidth',1)
grid on,xlim([0 110]),ylim([0 110])



if (strcmp(camara,'FE'))
tray2(1,:)=ypred1;
tray2(2,:)=ypred2; 
tray2(3,:)=0; 
[trayFE2]=camfe.project(tray2);

tray(1,:)=Xest;
tray(2,:)=Yest; 
tray(3,:)=0; 
[trayFE]=camfe.project(tray);

tray3(1,:)=XestP;
tray3(2,:)=YestP; 
tray3(3,:)=0;

[tray3FE]=camfe.project(tray3);

figure(figNum),subplot(1,2,2),hold on,plot(trayFE(1,:),trayFE(2,:),'k.','LineWidth',1),box on,
hold on,plot(trayFE2(1,:),trayFE2(2,:),'r.','LineWidth',2),
% plot(tray3FE(1,:),tray3FE(2,:),'c.','LineWidth',1)
plot(exU,eyV,'m.','LineWidth',2),
grid on,xlim([0 1920]),ylim([0 1920])
xlim([0 1920]),ylim([0 1920])
else
tray2(1,:)=ypred1;
tray2(2,:)=ypred2; 
tray2(3,:)=0; 
[trayptz2]=camptz.project(tray2);

tray(1,:)=Xest;
tray(2,:)=Yest; 
tray(3,:)=0; 
[trayptz]=camptz.project(tray);

figure(figNum),subplot(1,2,2),hold on,plot(trayptz(1,:),trayptz(2,:),'k.','LineWidth',1),box on,
hold on,plot(trayptz2(1,:),trayptz2(2,:),'r.','LineWidth',1),grid on,xlim([0 1920]),ylim([0 1920])
xlim([0 1280]),ylim([0 960])

end


end


