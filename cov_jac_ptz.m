function [Cm,Jac] = cov_jac(param,epsilon,xfe2,yfe2)

%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
np=1;
varianza=epsilon.*epsilon;

for nparam=1:8
delta=zeros(size(param));
delta(nparam)=epsilon(nparam);
param1=param-delta;
param2=param+delta;

[xmpred1,ympred1] = vca2map_forjac(param1,xfe2,yfe2);
[xmpred2,ympred2] = vca2map_forjac(param2,xfe2,yfe2);

Jac(1,nparam)=(xmpred2-xmpred1)/(2*delta(nparam));
Jac(2,nparam)=(ympred2-ympred1)/(2*delta(nparam));

end
%Jac_xpix
[xmpred1,ympred1] = vca2map_forjac(param,xfe2(np)-epsilon(8),yfe2(np));
[xmpred2,ympred2] = vca2map_forjac(param,xfe2(np)+epsilon(8),yfe2(np));
Jac(1,9)=xmpred2-xmpred1;
Jac(2,9)=ympred2-ympred1;
%Jac_ypix
[xmpred1,ympred1] = vca2map_forjac(param,xfe2(np),yfe2(np)-epsilon(9));
[xmpred2,ympred2] = vca2map_forjac(param,xfe2(np),yfe2(np)+epsilon(9));
Jac(1,10)=xmpred2-xmpred1;
Jac(2,10)=ympred2-ympred1;

Cparam=zeros(9);
for n=1:10
Cparam(n,n)=varianza(n);
end
Cm=Jac*Cparam*Jac';


end

