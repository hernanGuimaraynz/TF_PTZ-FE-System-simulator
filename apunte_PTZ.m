function [ a_ptz ,b_ptz  ] = apunte_PTZ( PmA,phiptz,titaptz,Tptz )




Tcrptz0A(1,:)=[ cos(phiptz), -cos(titaptz)*sin(phiptz),  sin(phiptz)*sin(titaptz), 0];
Tcrptz0A(2,:)=[ sin(phiptz),  cos(phiptz)*cos(titaptz), -cos(phiptz)*sin(titaptz), 0];
Tcrptz0A(3,:)=[           0,              sin(titaptz),              cos(titaptz), 0];
Tcrptz0A(4,:)=[           0,                         0,                         0, 1];

%punto señalado en la FE en coord. del mundo {0}.


 PmA(3)=0; 
 PmA(4)=1;
%%%%%%%%%%%%%%%%%%%
  Pc= (Tptz) \PmA';  
  
  Pb=(Tcrptz0A)*Pc;
  

 xbx=Pb(1);
 xby=Pb(2);
 xbz=Pb(3);
 
 a_ptz=atan2(-xbx,xby);%phi (pan)
 b_ptz=atan2(-sqrt((xbx^2)+(xby^2)),xbz);%ptita (tilt)



end

