function [ ] = proyPTZ(param,  figNum )

global camptz

% param(1)=alfa_ptz;
% param(2)=beta_ptz;
% param(3)=gama_ptz;
% param(4)=xptz;
% param(5)=yptz;
% param(6)=zptz;
% param(7)=titaptz;
% param(8)=phiptz;

h=zeros(1,961)';
w=zeros(1,1281)';

h1=ones(1,961)';
w1=ones(1,1281)';

WW1(1:3,:)=[(0:1280)' w w]';
WW2(1:3,:)=[(1280:-1:0)' 960*w1 w]';

HH1(1:3,:)=[1280*h1 (0:960)' h]';
HH2(1:3,:)=[h (960:-1:0)' h]';



[H1] = camptz_a_mundo_vect(param,HH1);
[H2] = camptz_a_mundo_vect(param,HH2);
[W1] = camptz_a_mundo_vect(param,WW1);
[W2] = camptz_a_mundo_vect(param,WW2);
figure(figNum),subplot(1,2,1),hold on,
plot(H1(1,:),H1(2,:),'b.'),
 plot(W1(1,:),W1(2,:),'b.'),
 plot(H2(1,:),H2(2,:),'b.'),
 plot(W2(1,:),W2(2,:),'b.'),
xlim([0 110]),grid on,ylim([0 110]),xlabel('X [metros]','FontSize',12),ylabel('Y [metros]','FontSize',12)

end

