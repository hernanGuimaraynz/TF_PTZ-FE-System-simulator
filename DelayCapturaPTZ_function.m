function [ DelayCapturaPTZ ] = DelayCapturaPTZ_function( )


DelayCapturaPTZValues=534+ (100*randn(10000,1));

di=randi(10000);
DelayCapturaPTZ=DelayCapturaPTZValues(di);
end

