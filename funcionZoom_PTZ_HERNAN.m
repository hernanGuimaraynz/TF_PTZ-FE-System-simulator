function [ df] = funcionZoom_PTZ_HERNAN( vzoom )



vz=[0 10 20 30 40 50 60 70 80 90 100];
vf=[1246.33 3244.96 7119.92 10004.30 13151.33 16478.57 18598.74 21702.63 27223.82 27707.66 26728.01];


paramf=[ 286 1246.3];

RR=nlinfit(vz,vf,@distFocal,paramf);

[ df] = distFocal(  RR,vzoom);





end
%fuente : TPF Lilian Rojas,UNQ, 2018.


%IN: vzoom (entero) =>valor de nivel de zoom de la camara PTZ de 0 a 1 /(0 a 100)
%OUT: fzoom  => distancia focal de la camara para el nivel de zoom vzoom de
% entrada

% zoom[ %] fx[píxel] fy[píxel] fovx[grados] fovy[grados]
% 0        1246.33    1246.33    54.36    42.12
% 10 33244.96 3244.96            22.31    16.82
% 20 7119.92 7119.92             10.27     7.71
% 30 10004.30 10004.30            7.32     5.49
% 40 13151.33 13151.33            5.57     4.18
% 50 16478.57 16478.57            4.45     3.34
% 60 18598.74 18598.74            3.94     2.95
% 70 21702.63 21702.63            3.38     2.53
% 80 27223.82 27223.82            2.69     2.02
% 90 27707.66 27707.66            2.64     1.98
% 100 26728.01 26728.01           2.74     2.05

% vz=[0 10 20 30 40 50 60 70 80 90 100];
% vf=[1246.33 3244.96 7119.92 10004.30 13151.33 16478.57 18598.74 21702.63 27223.82 27707.66 26728.01];

% vfovy=[42.12 16.82 7.71 5.49 4.18 3.34 2.95 2.53 2.02 1.98 2.05];
% vfovx=[54.36 22.31 10.27 7.32  5.57 4.45 3.94  3.38 2.69   2.64 2.74];

%%sin 80 ni 100
% % vz=[0 10 20 30 40 50 60 70 ];
% % vf=[1246.33 3244.96 7119.92 10004.30 13151.33 16478.57 18598.74 21702.63 ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ii=-1;
% ii=find(vz==vzoom);
% 
% if (ii ~= -1)
% 
%   fzoom= vf(ii) ;
%  
% else
%     fzoom=-1;
%   
%    disp(' ERROR: valor de entrada inválido.') 
% end
% 
% jj=-1;
% jj=find(vz==vzoom);
% 
% if (jj ~= -1)
% 
%   
%   fov= vfov(jj) ;
% else
%     
%     fov=-1;
%    disp(' ERROR: valor de entrada inválido.') 



