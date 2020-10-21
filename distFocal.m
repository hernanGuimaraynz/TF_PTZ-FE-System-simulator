function [ df] = distFocal(param, vzoom )
%  vzoom=[0 10 20 30 40 50 60 70 80 90 100];
%  vf=[1246.33 3244.96 7119.92 10004.30 13151.33 16478.57 18598.74 21702.63 27223.82 27707.66 26728.01];

L=length(vzoom);

p1=param(1);
p2=param(2);


for n=1:L

 df(n)=+(p1*vzoom(n))+p2;

end

end

