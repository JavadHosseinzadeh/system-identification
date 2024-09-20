clc
clear all
close all
format long g
%% Defining system
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
System_Transfer=tf(num,den)
%% Defining Parameters:
T = 0.5;
N = 80;
Time= 0:T:(N-1)*T;
Step_Input = ones(N,1);
Impulse_Input = zeros(N,1);Impulse_Input(1)=1;
Discrete_System_Transfer=c2d(System_Transfer,T);
%% Part one finding similar transfer function:
Step_response  = lsim(Discrete_System_Transfer, Step_Input);
K=Step_response(end);
Time_T1=find(Step_response>((1-exp(-1))*K));
one_tau=Time(Time_T1(1))
Time_T2=find(Step_response>((1-exp(-2))*K));
two_tau=Time(Time_T2(1))
Time_T3=find(Step_response>((1-exp(-3))*K));
three_tau=Time(Time_T3(1))
Time_T4=find(Step_response>((1-exp(-4))*K));
four_tau=Time(Time_T4(1))
four_tau/one_tau;
three_tau/two_tau;
two_tau/one_tau;
Part_One_num = K;
Part_One_den = [two_tau-one_tau 1];
Part_one_Plot_with_delay=lsim(tf(Part_One_num,Part_One_den,'InputDelay',3),Step_Input,Time);
Part_one_Plot_without_delay=lsim(tf(Part_One_num,[two_tau-one_tau 1]),Step_Input,Time);
%% ploting part one:
figure,
plot(Time,Step_response,'linewidth',2);
hold on
plot(Time,Part_one_Plot_with_delay,'linewidth',2)
hold on
plot(Time,Part_one_Plot_without_delay,'linewidth',2)
xlabel('Time(s)');ylabel('Value');title('Step response')
legend('System','with delay system approx','without delay system approx')
%% input & output vectors with noise for other methods noise amplitude
%  should be less than 0.426621160252823*0.05=0.0213310580126411
White_Noise = wgn(N , 1 , 0 , [], 0);
Y_real = lsim(Discrete_System_Transfer, White_Noise);
Color_Noise_Dynamic=tf([1/10 1/4],[1 -15/16],T) ;
Colored_Noise = lsim(Color_Noise_Dynamic, (1/100)*wgn(N , 1 , 0 , [], 6));
dx = White_Noise;
dy = Y_real+Colored_Noise;
%ploting noise
figure,
plot(Time,dx,'linewidth',2)
xlabel('Time(s)');ylabel('Value');title('White gaussian noise')
figure,
plot(Time,dy,'linewidth',2)
hold on 
plot(Time,Colored_Noise,'linewidth',2)
xlabel('Time(s)');ylabel('Value');title('Noise response with noise')
legend('with noise output','Colored noise')
%% Part Two
Autocorrelation = Autocorrel(dx)';
Crosscorrelation = Crosscorrel(dx,dy)';
M = length(Autocorrelation);
Rxx = Rxxmatrix(Autocorrelation,M);
Rxy = Crosscorrelation;
H_from_Correlation = pinv(Rxx)*Rxy(1:M);
Real_Impulse_Response=lsim(Discrete_System_Transfer,Impulse_Input);
% Ploting Part Two
figure,
plot(Time,Real_Impulse_Response,'linewidth',2)
hold on
plot(Time,H_from_Correlation,'linewidth',2)
legend('real','Correlation')
xlabel('Time(s)');ylabel('Value');title('Correlation method Impulse Response')
%% Part Three:
U = UMatrixFromX(dx,N);
H_from_Least_Square = (pinv(U'*U))*U'*dy;
%% Part Three Plot
figure,
plot(Time,Real_Impulse_Response,'linewidth',2)
hold on
plot(Time,H_from_Least_Square,'linewidth',2)
legend('Real impulse response','Least Square impulse response')
%% Prony:: we have impulse response so we have to calculate D & Y matrix:     % debug needed:
D = Unbyp(Impulse_Input,H_from_Least_Square);
theta_from_prony = (pinv(D'*D))*D'*(H_from_Least_Square)
prony_numerator = theta_from_prony(5:8)';
prony_denominator = [1 theta_from_prony(1:4)'];
prony_system=tf(prony_numerator,prony_denominator,T)
filt(prony_numerator,prony_denominator)
my_prony_Impulse_response=lsim(prony_system,Impulse_Input);
% Plot:
figure,
plot(Time,Real_Impulse_Response,'linewidth',2)
hold on
plot(Time,my_prony_Impulse_response,'linewidth',2)
legend('real','prony')
xlabel('Time(s)');ylabel('Value');title('comparison between prony and real transfer function')
%% Part 5: finding theta using least square:
Unp = Unbyp(dx,dy);
theta= (pinv(Unp'*Unp))*Unp'*dy
numerator = theta(5:8)';
denominator = [1 theta(1:4)'];
Least_Square_sys = tf(numerator,denominator,T)
Least_Square_Step_response = lsim(Least_Square_sys,Step_Input);
%Part 5 plot
figure,
plot(Time,Least_Square_Step_response)
hold on
plot(Time,Step_response)
legend('Least square','Real')
xlabel('Time(s)');ylabel('Value');title('comparison between Least square and real transfer function')
%% Singular value decomposition:
[Usvd,Ssvd,Vsvd] = svd(Unp);
y_star=Usvd'*dy;
theta_star=pinv(Ssvd(1:8,:))*y_star(1:8);
theta_SVD=Vsvd*theta_star;
numerator_SVD = theta_SVD(5:8)';
denominator_SVD = [1 theta_SVD(1:4)'];
Least_Square_sys_SVD = tf(numerator_SVD,denominator_SVD,T)
Least_Square_SVD_Step_response = lsim(Least_Square_sys_SVD,Step_Input);
%Part 5 plot
figure,
plot(Time,Least_Square_SVD_Step_response)
hold on
plot(Time,Step_response)
legend('Least square SVD','Real')
xlabel('Time(s)');ylabel('Value');title('comparison between Least square and real transfer function')
%% Covariance
Least_Square_SVD_Step_response = lsim(Least_Square_sys_SVD,White_Noise);
error=dy-Least_Square_SVD_Step_response;
figure,
plot(Time,Least_Square_SVD_Step_response,'linewidth',2)
hold on 
plot(Time,dy,'linewidth',2)
legend('my model output','system output (output of white noise + color noise)')
xlabel('Time(s)');ylabel('Value');title('comparison between Least square and real transfer function')
n=4;
m=5;
p=n+m;
sigma_hat=(1/(N-p))*sum(error.^2);
COV_Theta=sigma_hat*inv(Unp'*Unp)
