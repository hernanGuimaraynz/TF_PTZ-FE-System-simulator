function [ tii,tff] = t_Grabacion(ROIint,xr,yr,VxEst,VyEst,ht,tA )



if ROIint==1 || ROIint==2
    
pI=60*(ROIint-1)+25;

[xx,tii]=min(abs(pI-xr));

else 
    
pI=60*(ROIint-3)+25;

[xx,tii]=min(abs(pI-yr));
end


if tii<tA
    
    tii=tA+1;
end  

if ROIint==1 || ROIint==2

tff=tii+round(((115-pI)/(mean(VxEst)/3.6))/ht);
else
tff=tii+round(((115-pI)/(mean(VyEst)/3.6))/ht);
end


if tff > length(xr)
    
  tff = length(xr) ;
end
end

