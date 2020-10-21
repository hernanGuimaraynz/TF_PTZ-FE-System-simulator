 close all
 clear all
 clc



%valores iniciales

ex0=105;%m
ey0=55;%m


%supongo velocidad inicial:
%80 km/h =>  22.2 m/s
%60 km/h =>  16.6 m/s
%40 km/h =>  11.1 m/s

vy0=-0+0.1*(2*rand-1);%m/s
vx0=-6.3+0.1*(2*rand-1)/8;%m/s


 ax=-1.2+0.1*(2*rand-1);
 ay=-0;

t=[0:0.01:6];

t1=[0:0.3:9];

global ypred1
global ypred2

ex=ex0+vx0.*t+0.5.*ax.*t.^2;%posicion en x 
ey=ey0+vy0.*t+0.5.*ay.*t.^2;%posicion en y 



  for n=1:length(ex)
      
    ruido=0.1*(2*rand-1);
    
  %agrego ruido a la estimacion de la posicion.
    ex(n)= ex(n)+ruido;
    ey(n)= ey(n)+ruido;  
    
  end
  [qq,tq]=min(abs(90-ex)) %estimo hasta que el auto deja la ROI. 

%   [p1,S1,mu1] = polyfit(t,ex,3);
%     [ypred1,delta1] = polyval(p1,t,S1,mu1);
% 
%     [p2,S2,mu2] = polyfit(t,ey,3);
%     [ypred2,delta2] = polyval(p2,t,S2,mu2);
 t=t(1:tq);
 troi=t(tq)
 ex=ex(1:tq); 
 ey=ey(1:tq);
   

  [p1,S1,mu1] = polyfit(t,ex,2);
    [ypred1,delta1] = polyval(p1,t,S1,mu1);

    [p2,S2,mu2] = polyfit(t,ey,2);
    [ypred2,delta2] = polyval(p2,t,S2,mu2);
   
%  Xest=p1(1)*((t1-mu1(1))/mu1(2)).^3+p1(2)*((t1-mu1(1))/mu1(2)).^2+p1(3)*((t1-mu1(1))/mu1(2))+p1(4);
% 
%  Yest=p2(1)*((t1-mu2(1))/mu2(2)).^3+p2(2)*((t1-mu2(1))/mu2(2)).^2+p2(3)*((t1-mu2(1))/mu2(2))+p2(4);
%   
 Xest=p1(1)*((t1-mu1(1))/mu1(2)).^2+p1(2)*((t1-mu1(1))/mu1(2))+p1(3);

 Yest=p2(1)*((t1-mu2(1))/mu2(2)).^2+p2(2)*((t1-mu2(1))/mu2(2))+p2(3);
 
    figure(100),subplot(2,2,3),plot(t,ex,'b.-'),hold on,plot(t,ypred1,'rx-','LineWidth',2),title('Posicion x '),grid on, hold on ,plot(t1,Xest,'kx-','LineWidth',1)
    figure(100),subplot(2,2,4),plot(t,ey,'b.-'),hold on,plot(t,ypred2,'rx-','LineWidth',2),title('Posicion y'),grid on, hold on ,plot(t1,Yest,'kx-','LineWidth',1)
    figure(100),subplot(2,2,1:2),plot(ex,ey,'b.-'),hold on,plot(ypred1,ypred2,'rx-','LineWidth',2),title('trayectoria xy'),grid on,
    hold on ,plot(Xest,Yest,'kx-','LineWidth',1)
