clc
clear all
close all
format long g
%%
syms x1 x2 x3 x4 u
F=...
[x2;
x3;
x4;
-2.344*x1-15.03*x2-26.19*x3-14.50*x4+x1*x3+x4^2+x2^2*(1+x2^2)^(1/2)+u]
Fp(x1,x2,x3,x4)=jacobian(F,[x1;x2;x3;x4]);
A=double(Fp(0,0,0,0))
eig(A)
B=double(jacobian(F,u))
C=[1 0 0 0]
D=0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Transfer function 
[num,den]=ss2tf(A,B,C,D)
System_Transfer=tf(num,den)
%% Impulse
syms x
fraction = partfrac(1/((x+12.499)*(x+1)*(x+0.748)*(x+0.25)), x, 'FactorMode','full')
vpa(fraction)
figure,
impulse(System_Transfer)
figure,
step(System_Transfer)
% figure,
% [output] = nonlinear(0.1,20,0.01);
% plot(output)
%% bode
bode(System_Transfer)
pole(System_Transfer)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%descrete%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% bilinear
descrete_Transfer = c2d(System_Transfer,.1,'tustin')
%%
descrete_Transfer = c2d(System_Transfer,.1,'zoh')
%% 
[Num,Den,t]=tfdata(descrete_Transfer)
S = ss(tf(Num,Den,t),'minimal')
%%
diffrence=filt(Num,Den)
%% impulse response
figure,
subplot(2,1,1)
impulse(descrete_Transfer)
subplot(2,1,2)
[y,tOut] = impulse(descrete_Transfer);
stem(tOut,y)
xlabel('Time(seconds)')
ylabel('Amplitude')
%% frequency response
figure,
bode(descrete_Transfer)
%% compare
figure,
bode(System_Transfer,descrete_Transfer)
legend('Cotinious','discrete')

