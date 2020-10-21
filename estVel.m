function [ VxEst,VyEst,VxR,VyR ] = estVel( VV1,VV2,xr,yr ,nroROI,ht)

if nroROI==1
    xr= flip(xr);
end

if nroROI==3
    yr=flip(yr);
end


%velocidad estimada
VxEst=abs((diff(xr)/ht))*3.6;
VyEst=abs((diff(yr)/ht))*3.6;

   %velocidad real
VxR=abs((diff(VV1)/ht))*3.6;
VyR=abs((diff(VV2)/ht))*3.6;



end

