function [vxm,vym] = vca2map_forjac(param,vxi,vyi)
%mapeo.

Px = param(1);
Py = param(2);
Pz = param(3);
alfa=param(4);
beta=param(5);
gama=param(6);
k=param(7);

T(1,:)=[ cos(alfa)*cos(beta), cos(alfa)*sin(beta)*sin(gama) - cos(gama)*sin(alfa), sin(alfa)*sin(gama) + cos(alfa)*cos(gama)*sin(beta)];
T(2,:)=[ cos(beta)*sin(alfa), cos(alfa)*cos(gama) + sin(alfa)*sin(beta)*sin(gama), cos(gama)*sin(alfa)*sin(beta) - cos(alfa)*sin(gama)];
T(3,:)=[ -sin(beta), cos(beta)*sin(gama), cos(beta)*cos(gama)];

%vxi = xyfe(1:(length(xyfe)/2));
%vyi = xyfe(((length(xyfe)/2+1):end));

L=1920;
vxm=zeros(size(vxi));
vym=zeros(size(vxi));

for n=1:length(vxi)
  
  xI=vxi(n);  
  yI=vyi(n);  

  %calculos auxiliares sobre la imagen panoramica
  xcen=xI-L/2;
  ycen=yI-L/2;
    
  r = sqrt(xcen^2+ycen^2);
  fi = atan2(ycen,xcen);
  
  %ahora a pasar a esfericas en el marco de referencia de la camara
  t = 2*atan(r/k); 
  %t = 2*np.arctan(r/952.16)
  
  Ct = cos(t); % coseno de theta
  St = sin(t); % seno de theta
  
  Cfi = cos(fi);
  Sfi = sin(fi);
  
  
  %% salteandome las cartesianas paso directamente al mapa
  %Rho = -Pz / (St*(T[2,0]*Cfiº+T[2,1]*Sfi)+Ct*T[2,2]);
  %xM = Rho*(St*(T[0,0]*Cfi+T[0,1]*Sfi)+T[0,2]*Ct) + Px;
  %yM = Rho*(St*(T[1,0]*Cfi+T[1,1]*Sfi)+T[1,2]*Ct) + Py;

  Rho = -Pz / (St*(T(3,1)*Cfi+T(3,2)*Sfi)+Ct*T(3,3));
  xM = Rho*(St*(T(1,1)*Cfi+T(1,2)*Sfi)+T(1,3)*Ct) + Px;
  yM = Rho*(St*(T(2,1)*Cfi+T(2,2)*Sfi)+T(2,3)*Ct) + Py;

  vxm(n)=xM;
  vym(n)=yM;
  
end

%xyhat=zeros(size(xyfe));
%xyhat(1:(length(xyfe)/2))=vxm;
%xyhat(((length(xyfe)/2+1):end))=vym;
