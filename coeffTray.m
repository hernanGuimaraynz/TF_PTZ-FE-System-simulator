function [ coeff ] = coeffTray(param, x)


L=length(x);

p1=param(1);
p2=param(2);
p3=param(3);

for n=1:L

 coeff(n)=  (p3*x(n)^2)  +(p2*x(n))+p3;

end


end

