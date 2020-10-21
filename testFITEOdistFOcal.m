clear all
close all
clc



vz=[0 10 20 30 40 50 60 70 80 90 100];
vf=[1246.33 3244.96 7119.92 10004.30 13151.33 16478.57 18598.74 21702.63 27223.82 27707.66 26728.01];

% paramf=[ 0.1 290 1246.3];

paramf=[  286 1246.3];

RR=nlinfit(vz,vf,@distFocal,paramf)

[ df2] = distFocal(  RR,vz)