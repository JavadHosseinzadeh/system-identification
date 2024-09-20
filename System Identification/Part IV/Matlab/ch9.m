clc
clear all
close all
format long g
%% creating input and output variable:
Number_of_sample=3000;
Delta_T=0.9;
[Time,Discrete_System_Transfer,Step_Input,Impulse_Input,measured_input,measured_Output,Real_Output] =...
    initialize(Number_of_sample,Delta_T);
%% order 1:
% RLS (Recursive Least Square):
[estimated_System_RLS1,covariance_RLS1,error1] = RLS1(measured_input,measured_Output,Number_of_sample,Delta_T,20);
estimated_System_RLS1
pole(estimated_System_RLS1)'
zero(estimated_System_RLS1)'
S_hat1=sum(error1.^2)
%% order 2:
% RLS (Recursive Least Square):
[estimated_System_RLS2,covariance_RLS2,error2] = RLS2(measured_input,measured_Output,Number_of_sample,Delta_T,20);
estimated_System_RLS2
pole(estimated_System_RLS2)'
zero(estimated_System_RLS2)'
S_hat2=sum(error2.^2)
%% order 3:
% RLS (Recursive Least Square):
[estimated_System_RLS3,covariance_RLS3,error3] = RLS3(measured_input,measured_Output,Number_of_sample,Delta_T,20);
estimated_System_RLS3
pole(estimated_System_RLS3)'
zero(estimated_System_RLS3)'
S_hat3=sum(error3.^2)
%% order 4:
% RLS (Recursive Least Square):
[estimated_System_RLS4,covariance_RLS4,error4] = RLS4(measured_input,measured_Output,Number_of_sample,Delta_T,20);
estimated_System_RLS4
pole(estimated_System_RLS4)'
zero(estimated_System_RLS4)'
S_hat4=sum(error4.^2)

%% order 5:
% RLS (Recursive Least Square):
[estimated_System_RLS5,covariance_RLS5,error5] = RLS5(measured_input,measured_Output,Number_of_sample,Delta_T,20);
estimated_System_RLS5
pole(estimated_System_RLS5)'
zero(estimated_System_RLS5)'
S_hat5=sum(error5.^2)
%% Evaluation: Fit method
Fit=[S_hat1 S_hat2 S_hat3 S_hat4 S_hat5]
%% Evaluation: Variance method
variance=[S_hat1/(Number_of_sample-2) S_hat2/(Number_of_sample-4) S_hat3/(Number_of_sample-6)...
    S_hat4/(Number_of_sample-8) S_hat5/(Number_of_sample-10)]
%% AIC
k=1;
AIC1=Number_of_sample*log10(Fit)+k*(2:2:10)
k=100;
AIC100=Number_of_sample*log10(Fit)+k*(2:2:10)
%% R square:
SSE=(1/Number_of_sample)*sum((measured_Output-mean(measured_Output)).^2)
R_Square=1-(Fit./SSE)