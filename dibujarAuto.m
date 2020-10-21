function [Aout,PPout] = dibujarAuto( Cc ,orientacion,camara,figNum)
global camfe 
global camptz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%auto => 4.5m largo x 1.8m ancho x 1.5m alto
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Xc=Cc(1);
Yc=Cc(2);

la=4.8; % largo del auto
ha=-1;%altura del auto
wa=2;%ancho del auto

at=0.85;%altura techo

%%%%%%%%%%%%%%POSICION DEL AUTOMOVIL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xi=Xc-(la/2) ;
Yi=Yc +(wa/2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (orientacion == 0)
% %base 
A(:,1)=[Xi Yi 0];%esquina izq arriba
A(:,2)=[Xi Yi-wa 0];%esquina izq  abajo
A(:,3)=[Xi+la Yi-wa 0];%esquina der abajo
A(:,4)=[Xi+la Yi 0];%esquina der arriba
A(:,5)=[Xi Yi 0];%esquina izq arriba

A(:,6)=[Xi Yi ha/2];%esquina izq arriba

A(:,7)=[Xi Yi-wa ha/2];%esquina izq  abajo
A(:,8)=[Xi Yi-wa 0];%esquina izq  abajo
A(:,9)=[Xi Yi-wa ha/2];%esquina izq  abajo

A(:,10)=[Xi+la Yi-wa ha/2];%esquina der abajo
A(:,11)=[Xi+la Yi-wa 0];%esquina der abajo
A(:,12)=[Xi+la Yi-wa ha/2];%esquina der abajo

A(:,13)=[Xi+la Yi ha/2];%esquina der arriba
A(:,14)=[Xi+la Yi 0];%esquina der arriba
A(:,15)=[Xi+la Yi ha/2];%esquina der arriba

A(:,16)=[Xi Yi ha/2];%esquina izq arriba

%techo
A(:,17)=[Xi+(la/4) Yi ha/2];
A(:,18)=[Xi+(la/4) Yi-wa ha/2];
A(:,19)=[Xi+(3*la/4) Yi-wa ha/2];
A(:,20)=[Xi+(3*la/4) Yi ha/2];
A(:,21)=[Xi+(la/4) Yi ha/2];
A(:,22)=[Xi+(la/4) Yi ha/2];

A(:,23)=[Xi+(la/4) Yi ha*at];

A(:,24)=[Xi+(la/4) Yi-wa ha*at];
A(:,25)=[Xi+(la/4) Yi-wa ha/2];
A(:,26)=[Xi+(la/4) Yi-wa ha*at];

A(:,27)=[Xi+(3*la/4) Yi-wa ha*at];
A(:,28)=[Xi+(3*la/4) Yi-wa ha/2];
A(:,29)=[Xi+(3*la/4) Yi-wa ha*at];


A(:,30)=[Xi+(3*la/4) Yi ha*at];
A(:,31)=[Xi+(3*la/4) Yi ha/2];
A(:,32)=[Xi+(3*la/4) Yi ha*at];

A(:,33)=[Xi+(la/4) Yi ha*at];
A(:,34)=[Xi+(la/4) Yi ha/2];
A(:,35)=[Xi+(la/4) Yi ha*at];

A(:,36)=[Xi+(la/4) Yi ha*at];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%patente
%patentes =>autos => 400 mm de largo por 130 mm de altura, /// motos  145 x 120 mm
 
LargoP=0.44;  %largo de la patente

pl= LargoP/2;
ap=0.25;

PP(:,1)=[Xi+la Yi-wa/2+pl  -0.5+ap];
PP(:,2)=[Xi+la Yi-wa/2+pl   -0.63+ap];
PP(:,3)=[Xi+la Yi-wa/2-pl   -0.63+ap];
PP(:,4)=[Xi+la Yi-wa/2-pl   -0.5+ap];
PP(:,5)=[Xi+la Yi-wa/2+pl  -0.5+ap];

PP(:,6)=[Xi Yi-wa/2+pl   -0.5+ap];
PP(:,7)=[Xi Yi-wa/2+pl   -0.63+ap];
PP(:,8)=[Xi Yi-wa/2-pl   -0.63+ap];
PP(:,9)=[Xi Yi-wa/2-pl  -0.5+ap];
PP(:,10)=[Xi Yi-wa/2+pl   -0.5+ap];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else

Xi=Xc+(wa/2) ;%esq izq arriba  // se pasa a esq derecha de arriba para orientacion 1
Yi=Yc -(la/2)+5;

A(:,1)=[Xi Yi 0];
A(:,2)=[Xi Yi-la 0];%esquina der  abajo
A(:,3)=[Xi-wa Yi-la 0];%esquina izq abajo
A(:,4)=[Xi-wa Yi 0];%esquina izq arriba
A(:,5)=[Xi Yi 0];
A(:,6)=[Xi Yi ha/2];
A(:,7)=[Xi Yi-la ha/2];
A(:,8)=[Xi Yi-la 0];
A(:,9)=[Xi Yi-la ha/2];
A(:,10)=[Xi-wa Yi-la ha/2];
A(:,11)=[Xi-wa Yi-la 0];%
A(:,12)=[Xi-wa Yi-la ha/2];
A(:,13)=[Xi-wa Yi ha/2];
A(:,14)=[Xi-wa Yi 0];
A(:,15)=[Xi-wa Yi ha/2];
A(:,16)=[Xi Yi ha/2];%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%techo

A(:,17)=[Xi Yi-(la/4) ha/2];
A(:,18)=[Xi-wa Yi-(la/4) ha/2];

A(:,19)=[Xi-wa Yi-(3*la/4) ha/2];

A(:,20)=[Xi Yi-(3*la/4) ha/2];
A(:,21)=[Xi Yi-(la/4) ha/2];
A(:,22)=[Xi Yi-(la/4) ha/2];
A(:,23)=[Xi Yi-(la/4) ha*at];
A(:,24)=[Xi-wa Yi-(la/4) ha*at];
A(:,25)=[Xi-wa Yi-(la/4) ha/2];
A(:,26)=[Xi-wa Yi-(la/4) ha*at];
A(:,27)=[Xi-wa Yi-(3*la/4) ha*at];
A(:,28)=[Xi-wa Yi-(3*la/4) ha/2];
A(:,29)=[Xi-wa Yi-(3*la/4) ha*at];
A(:,30)=[Xi Yi-(3*la/4) ha*at];
A(:,31)=[Xi Yi-(3*la/4) ha/2];
A(:,32)=[Xi Yi-(3*la/4) ha*at];
A(:,33)=[Xi Yi-(la/4) ha*at];
A(:,34)=[Xi Yi-(la/4) ha/2];
A(:,35)=[Xi Yi-(la/4) ha*at];
A(:,36)=[Xi Yi-(la/4) ha*at];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%patente
%patentes =>autos => 400 mm de largo por 130 mm de altura, /// motos  145 x 120 mm
LargoP=0.44;  %largo de la patente
pl= LargoP/2;
ap=0.25;

PP(:,1)=[Xi-(wa/2)+pl  Yi  -0.5+ap];
PP(:,2)=[Xi-(wa/2)+pl  Yi    -0.63+ap];
PP(:,3)=[Xi-wa/2-pl  Yi    -0.63+ap];
PP(:,4)=[Xi-wa/2-pl  Yi    -0.5+ap];
PP(:,5)=[Xi-wa/2+pl  Yi   -0.5+ap];

PP(:,6)=[Xi-wa/2+pl  Yi-la  -0.5+ap];
PP(:,7)=[Xi-wa/2+pl  Yi-la   -0.63+ap];
PP(:,8)=[Xi-wa/2-pl  Yi-la  -0.63+ap];
PP(:,9)=[Xi-wa/2-pl  Yi-la  -0.5+ap];
PP(:,10)=[Xi-wa/2+pl Yi-la  -0.5+ap];


end


figure(figNum),subplot(1,2,1),hold on,plot3(PP(1,(1:5)),PP(2,(1:5)),PP(3,(1:5))),hold on,plot3(PP(1,(6:10)),PP(2,(6:10)),PP(3,(6:10))),hold on,
plot3(A(1,:),A(2,:),A(3,:)),box on


Aout=A;
PPout=PP;

if strcmp(camara, 'FE')
    
PP2 = camfe.plot(PP, 'Tcam', camfe.T);

A2= camfe.plot(A, 'Tcam', camfe.T);

xpix=1920;
ypix=1920;

else
    
PP2 = camptz.plot(PP, 'Tcam', camptz.T);

A2= camptz.plot(A, 'Tcam', camptz.T);

xpix=1280;
ypix=960;
end


PuntPr=[xpix/2 ypix/2];


figure(figNum),subplot(1,2,2),hold on,plot(A2(1,:),A2(2,:),'b'),hold on,plot(PP2(1,(1:5)),PP2(2,(1:5)),'m'),plot(PP2(1,(6:10)),PP2(2,(6:10)),'g'),xlim([0 xpix]),ylim([0 ypix]),box on


end

