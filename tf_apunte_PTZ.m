function [ tA ] = tf_apunte_PTZ( t,delayTOTAL,troi )



[xx,tA]=min(abs((delayTOTAL+troi)-t));


end

