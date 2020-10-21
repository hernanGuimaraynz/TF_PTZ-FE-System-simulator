function [ DelayCapFE ] = DelayCapturaFE_function(  )

DelayCapturaFEValues=792+ (100*randn(10000,1));

dfe=randi(10000);
DelayCapFE=DelayCapturaFEValues(dfe);
end

