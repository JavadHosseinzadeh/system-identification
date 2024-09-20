clc
clear all
close all
disp('Press any key to initialize Input Output Vector')
pause
%% creating input and output variable:
Number_of_sample=3000;
Delta_T=0.9;
[Time,Discrete_System_Transfer,Step_Input,Impulse_Input,measured_input,measured_Output,Real_Output] =...
    initialize(Number_of_sample,Delta_T);
Discrete_System_Transfer
pole(Discrete_System_Transfer)'
zero(Discrete_System_Transfer)'
figure
plot(measured_Output-Real_Output)
hold on
plot(Real_Output)
disp('Press any key to see result of IGLS method')
pause
%%%%%%%%%%%%%%%%%%%%%%% one of iterative methods %%%%%%%%%%%%%%%%%%%%%%%%%%
%% I decided to implement IGLS:
tic
[estimated_System_IGLS_method,covarince_IGLS] = IGLS(measured_input,measured_Output,Number_of_sample,Delta_T);
toc
estimated_System_IGLS_method
pole(estimated_System_IGLS_method)'
zero(estimated_System_IGLS_method)'
figure,
impulse(Discrete_System_Transfer);
hold on;
impulse(estimated_System_IGLS_method);
set(findall(gcf,'type','line'),'linewidth',2);
figure,
step(Discrete_System_Transfer);
hold on;
step(estimated_System_IGLS_method);
set(findall(gcf,'type','line'),'linewidth',2);
disp('Press any key to see result of RLS method')
pause
%%%%%%%%%%%%%%%%%%%%%%%% Recursive methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RLS (Recursive Least Square):
tic
[estimated_System_RLS,covariance_RLS] = RLS(measured_input,measured_Output,Number_of_sample,Delta_T,20);
toc
estimated_System_RLS
pole(estimated_System_RLS)'
zero(estimated_System_RLS)'
figure,
impulse(Discrete_System_Transfer);
hold on;
impulse(estimated_System_RLS);
set(findall(gcf,'type','line'),'linewidth',2);
figure,
step(Discrete_System_Transfer);
hold on;
step(estimated_System_RLS);
set(findall(gcf,'type','line'),'linewidth',2);
disp('Press any key to see result of RELS method')
pause
%% RELS (Recursive Extended Least Square):
tic
[estimated_System_RELS,covariance_RELS] = RELS(measured_input,measured_Output,Number_of_sample,Delta_T,20);
toc
estimated_System_RELS
pole(estimated_System_RELS)'
zero(estimated_System_RELS)'
figure,
impulse(Discrete_System_Transfer);
hold on;
impulse(estimated_System_RELS);
set(findall(gcf,'type','line'),'linewidth',2);
figure,
step(Discrete_System_Transfer);
hold on;
step(estimated_System_RELS);
set(findall(gcf,'type','line'),'linewidth',2);
disp('Press any key to see result of RIV method')
pause
%% RIV (Recursive Instrumental Variable):
tic
[estimated_Sysem_RIV,covariance_RIV] = RIV(measured_input,measured_Output,Number_of_sample,Delta_T,20);
toc
estimated_Sysem_RIV
pole(estimated_Sysem_RIV)'
zero(estimated_Sysem_RIV)'
figure,
impulse(Discrete_System_Transfer);
hold on;
impulse(estimated_Sysem_RIV);
set(findall(gcf,'type','line'),'linewidth',2);
figure,
step(Discrete_System_Transfer);
hold on;
step(estimated_Sysem_RIV);
set(findall(gcf,'type','line'),'linewidth',2);
disp('Press any key to see result of RML method')
pause
%% RML (Recursive Maximum Likelihood):
tic
[estimated_System_RML,covariance_RML] = RML(measured_input,measured_Output,Number_of_sample,Delta_T,20);
toc
estimated_System_RML
pole(estimated_System_RML)'
zero(estimated_System_RML)'
figure,
impulse(Discrete_System_Transfer);
hold on;
impulse(estimated_System_RML);
set(findall(gcf,'type','line'),'linewidth',2);
figure,
step(Discrete_System_Transfer);
hold on;
step(estimated_System_RML);
set(findall(gcf,'type','line'),'linewidth',2);
disp('Press any key to see result of EMM method')
pause
%% EMM (Extended Matrix Method):
tic
[estimated_System_EMM,covariance_EMM] = EMM(measured_input,measured_Output,Number_of_sample,Delta_T,20);
toc
estimated_System_EMM
pole(estimated_System_EMM)'
zero(estimated_System_EMM)'
figure,
impulse(Discrete_System_Transfer);
hold on;
impulse(estimated_System_EMM);
set(findall(gcf,'type','line'),'linewidth',2);
figure,
step(Discrete_System_Transfer);
hold on;
step(estimated_System_EMM);
set(findall(gcf,'type','line'),'linewidth',2);
disp('Press any key to see result of SA method')
pause
%% SA (Stochastic Approximation): Debug Needed:
tic
[estimated_System_SA,covariance_SA,P_t_SA] = SA(measured_input,measured_Output,Number_of_sample,Delta_T,20);
toc
estimated_System_SA
pole(estimated_System_SA)'
zero(estimated_System_SA)'
figure,
impulse(Discrete_System_Transfer);
hold on;
impulse(estimated_System_SA);
set(findall(gcf,'type','line'),'linewidth',2);
figure,
step(Discrete_System_Transfer);
hold on;
step(estimated_System_SA);
set(findall(gcf,'type','line'),'linewidth',2);
figure,
plot(Time,P_t_SA);
set(findall(gcf,'type','line'),'linewidth',2);
disp('Press any key to see result of OPA method')
pause
%% OPA (Orthogonal Projection Matrix):
tic
[estimated_System_OPA,covariance_OPA] = OPA(measured_input,Real_Output,Number_of_sample,Delta_T,20);
toc
estimated_System_OPA
pole(estimated_System_OPA)'
zero(estimated_System_OPA)'
figure,
impulse(Discrete_System_Transfer);
hold on;
impulse(estimated_System_OPA);
set(findall(gcf,'type','line'),'linewidth',2);
figure,
step(Discrete_System_Transfer);
hold on;
step(estimated_System_OPA);
set(findall(gcf,'type','line'),'linewidth',2);
