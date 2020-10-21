function [Xest,Yest,xr,yr ,t1,troi,dt1,exQQ,eyQQ,ex,ey,ex2,ey2] = estTray2( Cc,PARS,nroROI,TF )
%a partir de los datos de la trayectoria real,se
%estima latrayectoria del vehiculo que esta en nroROI durante un determinado tiempo de simulacion.

%PARAMETROS DE ENTRADA.
%Cc :  coordenadas (x,y) del centro del vehiculo (detectado con los FP)
%PARS: contiene los datos de la trayectoria real (coeficientes del polinomio de grado 2)
%nroROI: numero de ROI en la que se detecta el centro (esto podria calcularse a partir de Cc )
%TF,tiempo de simulacion de la trayectoria estimada.

%DATOS DE SALIDA.

%Xest,Yest  componentes de la trayectoria extrapolada ideal del vehiculo
%xr yr  componentes de la trayectoria estimada del vehiculo
%t1 vector de tiempo asociado a las trayectorias
%troi tiempo que tarda el vehiculo en cruzar la ROI (tiempo de estimacion)
% dt1 valor de paso del tiempo de la trayectoria estimada.
% exQQ,eyQQ trayectoria real del vehiculo extrapolada
% ex,ey trayectoria real del vehiculo dentro de la ROI.
% ex2,ey2trayectoria real del vehiculo dentro de la ROI mapeada desde la FE al mundo con incerteza en los parametros.

global camfe;
global camptz;
global parsError



load paramFE.mat


ex0=Cc(1);%m
ey0=Cc(2);%m

if nroROI==1 
ex0=110-Cc(1);%m
ey0=Cc(2);%m
end

if nroROI==3 
ex0=Cc(1);%m
ey0=110-Cc(2);%m
end

% if nroROI==1
% ymin=45;
% ymax=65;
% xmin=90;
% xmax=110;
% end

if nroROI==2 || nroROI==1
ymin=45;
ymax=65;
xmin=0;
xmax=20;
end
% if nroROI==3 
% ymin=90;
% ymax=110;
% xmin=45;
% xmax=65;
% end
if nroROI==4 || nroROI==3
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dt=0.2;%5 fps
t=[0:dt:3];
dt1=0.1;
t1=[0:dt1:TF];%tiempo de simulacion de movimiento el auto
t2=t1;

vx=PARS(1);
vy=PARS(2);
ax=PARS(3);
 ay=PARS(4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vx0=vx;
vy0=vy;

% vx0=((-1)^nroROI)*vx;%m/s
% vy0=((-1)^nroROI)*vy;%m/s


    




                                  



ex=ex0+vx0.*t+0.5.*ax.*t.^2;%posicion en x 
ey=ey0+vy0.*t+0.5.*ay.*t.^2;%posicion en y 



exQQ=ex0+vx0.*t1+0.5.*ax.*t1.^2;%posicion en x 
eyQQ=ey0+vy0.*t1+0.5.*ay.*t1.^2;%posicion en y 




% 
%   if nroROI==1 
%   XROI=xmin;
%    [qq,tq]=min(abs(XROI-ex)) ;
%   end
    if nroROI==2 || nroROI==1 
  XROI=xmax;
   [qq,tq]=min(abs(XROI-ex)) ;
    end
%     if nroROI==3
%   yROI=ymin;
%    [qq,tq]=min(abs(yROI-ey)) ;
%     end
    if nroROI==4 || nroROI==3
  yROI=ymax;
   [qq,tq]=min(abs(yROI-ey)) ;
    end
%   
%     if nroROI==1 
%   XROI=xmin;
%    [qq,tq]=min(abs(XROI-ex)) ;
%   end
%     if nroROI==2
%   XROI=xmax;
%    [qq,tq]=min(abs(XROI-ex)) ;
%     end
%     if nroROI==3
%   yROI=ymin;
%    [qq,tq]=min(abs(yROI-ey)) ;
%     end
%     if nroROI==4
%   yROI=ymax;
%    [qq,tq]=min(abs(yROI-ey)) ;
%   end
  
  
% tq=tq-1;

 t=t(1:tq);
 troi=t(tq);
 ex=ex(1:tq); 
 ey=ey(1:tq);
   
%%%%%fiteo con polinomios de grado 2  ideal%%%%%%%%%
  [p1,S1,mu1] = polyfit(t,ex,2);
    [ypred1,delta1xx] = polyval(p1,t,S1,mu1);

    [p2,S2,mu2] = polyfit(t,ey,2);
    [ypred2,delta2yy] = polyval(p2,t,S2,mu2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



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



alfa_feR =alfa_fe+parsError.ruidoa1FE;
beta_feR=beta_fe+parsError.ruidoa2FE ;
gama_feR=gama_fe+parsError.ruidoa3FE;
xfeoR=xfeo+parsError.ruidopxFE;
yfeoR=yfeo+parsError.ruidopyFE;
zfeoR=zfeo+parsError.ruidozFE;
kfeR=kfe+parsError.ruidokFE;

for n=1:length(exU)
    


%   PosicionMundo(n,:) = camarafe_a_mundo_vect([alfa_fe beta_fe gama_fe xfeo yfeo zfeo kfe],[exU(n) eyV(n)]);
 
 PosicionMundo2(n,:) = camarafe_a_mundo_vect([alfa_feR beta_feR gama_feR xfeoR yfeoR zfeoR kfeR],[exU(n) eyV(n)]);
end
% 
%  ex1=PosicionMundo(:,1)';
%  ey1=PosicionMundo(:,2)';

 ex2=PosicionMundo2(:,1)';
 ey2=PosicionMundo2(:,2)';

  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%kalman%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tk=[1:1:length(ypred1)];

% [vt1,vtrackedLocation]=kalmanTray(t1,XestP,YestP);
% [vt1,vtrackedLocation]=kalmanTray(t,ex2,ey2);
% ekx=vtrackedLocation(3:end,1);
% eky=vtrackedLocation(3:end,2);
% 
% KK(1,:)=vtrackedLocation(3:end,1);
% KK(2,:)=vtrackedLocation(3:end,2);
% KK(3,:)=0;
% [kalmanUV]=camfe.project(KK);
% xfek=kalmanUV(1,:);
% yfek=kalmanUV(2,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %%%%%%%%%fiteo de polinomio de grado 2  con error de retroproyeccion de la FE  %%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  [p8,S8,mu8] = polyfit(t,ex2,2);
    [ypred8,delta8] = polyval(p1,t,S8,mu8);

    [p9,S9,mu9] = polyfit(t,ey2,2);
    [ypred9,delta9] = polyval(p9,t,S9,mu9);
    
    
 Xest2=p8(1)*((t2-mu8(1))/mu8(2)).^2+p8(2)*((t2-mu8(1))/mu8(2))+p8(3);
 
if abs(p8(1)/mu8(2)) < 0.5
    
    Xest2=p8(2)*((t2-mu8(1))/mu8(2))+p8(3);
end


 Yest2=p9(1)*((t2-mu9(1))/mu9(2)).^2+p9(2)*((t2-mu9(1))/mu9(2))+p9(3);

if abs(p9(1)/mu9(2)) < 0.5
    
 Yest2=p9(2)*((t2-mu9(1))/mu9(2))+p9(3);
end
 

  [p4,S4,mu4] = polyfit(t,ex2,1);
    [ypred5,delta3] = polyval(p1,t,S1,mu1);

    [p5,S5,mu5] = polyfit(t,ey2,1);
    [ypred6,delta4] = polyval(p2,t,S2,mu2);
    
 if nroROI ==1 || nroROI ==2

 XestP=p4(1)*((t2-mu4(1))/mu4(2))+p4(2);

 YestP=p5(2)*ones(1,length( t2));
 else
 
 YestP=p5(1)*((t2-mu5(1))/mu5(2))+p5(2);
 
 XestP=p4(2)*ones(1,length( t2));
 end

 
if nroROI==1 ||nroROI==2

xr= Xest2 ;
yr= YestP; 

 else 
 xr= XestP ;
 yr= Yest2 ; 
end 

if nroROI==1
 
    Crx= xr(end)-Cc(1);
     xr=flip(xr)-Crx  ;
     
     CEx= Xest(end)-Cc(1); 
     
    Xest=flip(Xest)-CEx ;
    
    Yest=flip(Yest);


end

if nroROI==3
    
 Cry= yr(end)-Cc(1);
 yr=flip(yr)-Cry;
    
 CEy= Yest(end)-Cc(2);
 Yest=flip(Yest)-CEy;
   
   Xest=flip(Xest);
   
   

end
    

end

