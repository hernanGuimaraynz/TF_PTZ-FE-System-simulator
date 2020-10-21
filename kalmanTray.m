function [vt1,vtrackedLocation]=kalmanTray(vt,vxm,vym)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %Intento KALMAN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%  vt=t;      %en segundos;
% 
% vxm=ex;  %en m/s;
% vym=ey;  %en m/s;

condinc=[vxm(1);vym(1)];

 vt1=vt; 

vtcomp=[1:1:length(vt)];



%estimacion de la trayectoria.
for n=1:length(vt1)
    
    if length(intersect((n),vtcomp))>0, visObjectDetected((n))=1; vdetectedLocation((n),:)=[vxm((n));vym((n))];
    else visObjectDetected((n))=0;vdetectedLocation((n),:)=[NaN;NaN];
    end
    
end

kalmanFilter = []; isTrackInitialized = false;

for n=1:length(vtcomp)
    
   
     isObjectDetected=visObjectDetected(n);
     detectedLocation= vdetectedLocation(n,:);
     
     if ~isTrackInitialized
       if isObjectDetected
         %configureKalmanFilter(MotionModel,InitialLocation,InitialEstimateError,MotionNoise,MeasurementNoise) 

         kalmanFilter = configureKalmanFilter('ConstantAcceleration',condinc, [1 1 1]*0.5, [1, 1, 1]*1e-5, 2);

% %          %kalmanFilter = configureKalmanFilter('ConstantAcceleration',condinc, [1 1 1], [1, 1, 1]*1e-5, 1);
         isTrackInitialized = true;
       end
       
     else 
       if isObjectDetected 
         % Reduce the measurement noise by calling predict, then correct
         predict(kalmanFilter);
         trackedLocation = correct(kalmanFilter, detectedLocation);
         
       else % Object is missing
         trackedLocation = predict(kalmanFilter);
         
       end
      
     end
  
     if n>2;vtrackedLocation(n,:)=trackedLocation;end
     
   end % while
   
end   