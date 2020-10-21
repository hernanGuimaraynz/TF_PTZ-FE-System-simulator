function [ PuntoMundo,ti,XROI] = calculo_intercepcion(Pint, ypred1,ypred2,nroROI )



  if nroROI==1
  XROI=Pint;
   [dd,t_intersect]=min(abs(ypred1-XROI));
  end
    if nroROI==2
  XROI=110-Pint;
  [dd,t_intersect]=min(abs(ypred1-XROI));
    end
    if nroROI==3
  XROI=Pint;
   [dd,t_intersect]=min(abs(ypred2-XROI)); 
    end
    if nroROI==4
  XROI=110-Pint;
 [dd,t_intersect]=min(abs(ypred2-XROI));
    end
  
    
    

ti=t_intersect;



PuntoMundo= [ypred1(ti) ypred2(ti) ];



% if nroROI==1 || nroROI==2
% [xx,tINT]=min(abs((xr(ti))-ypred1));
% 
% 
% else 
% [xx,tINT]=min(abs((yr(ti))-ypred2));
% end

end

