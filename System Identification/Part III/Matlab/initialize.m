function [Time,Discrete_System_Transfer,Step_Input,Impulse_Input,dx,dy,Y_real] = initialize(N,T)
% Defining system
syms x1 x2 x3 x4 u
F=...
[x2;
x3;
x4;
-2.344*x1-15.03*x2-26.19*x3-14.50*x4+x1*x3+x4^2+x2^2*(1+x2^2)^(1/2)+u];
Fp(x1,x2,x3,x4)=jacobian(F,[x1;x2;x3;x4]);
A=double(Fp(0,0,0,0));
eig(A);
B=double(jacobian(F,u));
C=[1 0 0 0];
D=0;
[num,den]=ss2tf(A,B,C,D);
System_Transfer=tf(num,den);
% Defining vectors:
Time= 0:T:(N-1)*T;
Step_Input = ones(N,1);
Impulse_Input = zeros(N,1);Impulse_Input(1)=1;
Discrete_System_Transfer=c2d(System_Transfer,T);
White_Noise = wgn(N , 1 , 0 , [], 0);
Y_real = lsim(Discrete_System_Transfer, White_Noise);
Color_Noise_Dynamic=tf([1/10 1/4],[1 -15/16],T) ;
Colored_Noise = lsim(Color_Noise_Dynamic, (1/100)*wgn(N , 1 , 0 , [], 6));
dx = White_Noise;
dy = Y_real+Colored_Noise;
end

