clc
clear all
close all
%% creating input and output variable:
Number_of_sample=3000;
Delta_T=0.9;
[Time,Discrete_System_Transfer,Step_Input,Impulse_Input,measured_input,measured_Output,Real_Output] =...
    initialize(Number_of_sample,Delta_T);
figure
plot(measured_Output-Real_Output)
hold on
plot(Real_Output)
%% Neural Network: On with noise data
inputs=Unbyp4(measured_input,measured_Output).';
targets=measured_Output.';
%%
% Choose a Training Function
net.trainFcn = 'trainbr';  % Bayesin regulation backpropagation.
hiddenLayerSize = [6,5];
net = fitnet(hiddenLayerSize);
% Choose Input and Output Pre/Post-Processing Functions
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 90/100;
net.divideParam.valRatio = 5/100;
net.divideParam.testRatio = 5/100;
net.performFcn = 'mse';  % Mean Squared Error
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};
net.trainParam.showWindow=true;
net.trainParam.showCommandLine=false;
net.trainParam.show=1;
net.trainParam.epochs=500;
net.trainParam.goal=1e-30;
net.trainParam.max_fail=20;
% Train the Network
[net,tr] = train(net,inputs,targets);
% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);
%% impulse Response:
NN_Impluse_with_noise = NN_Response(net,Impulse_Input);
figure,
out=impulse(Discrete_System_Transfer);
plot(out,'linewidth',2)
hold on
plot(NN_Impluse_with_noise(1:length(out)),'linewidth',2)
xlabel('Time');ylabel('Amplitude');title('Impulse Response')
%% Step Response:
NN_Step_with_noise = NN_Response(net,Step_Input);
figure,
out=step(Discrete_System_Transfer);
plot(out,'linewidth',2)
hold on
plot(NN_Step_with_noise(1:length(out)),'linewidth',2)
xlabel('Time');ylabel('Amplitude');title('Impulse Response')
%% Theta
Theta=[net([1 0 0 0 0 0 0 0]');
    net([0 1 0 0 0 0 0 0]');
    net([0 0 1 0 0 0 0 0]');
    net([0 0 0 1 0 0 0 0]');
    net([0 0 0 0 1 0 0 0]');
    net([0 0 0 0 0 1 0 0]');
    net([0 0 0 0 0 0 1 0]');
    net([0 0 0 0 0 0 0 1]');]
a_hat = [1 Theta(1) Theta(2) Theta(3) Theta(4)];
b_hat = [Theta(5) Theta(6) Theta(7) Theta(8)];
estimated_Sysem_RLS = tf(b_hat, a_hat, Delta_T)
%% Neural Network: On Real Data without noise
inputs=Unbyp4(measured_input,Real_Output).';
targets=Real_Output.';
% Choose a Training Function
net.trainFcn = 'trainbr';  % Bayesin regulation backpropagation.
hiddenLayerSize = [6,5];
net = fitnet(hiddenLayerSize);
% Choose Input and Output Pre/Post-Processing Functions
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 90/100;
net.divideParam.valRatio = 5/100;
net.divideParam.testRatio = 5/100;
net.performFcn = 'mse';  % Mean Squared Error
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};
net.trainParam.showWindow=true;
net.trainParam.showCommandLine=false;
net.trainParam.show=1;
net.trainParam.epochs=500;
net.trainParam.goal=1e-30;
net.trainParam.max_fail=50;
% Train the Network
[net,tr] = train(net,inputs,targets);
% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);
%% impulse Response:
NN_Impluse_without_noise = NN_Response(net,Impulse_Input);
figure,
out=impulse(Discrete_System_Transfer);
plot(out,'linewidth',2)
hold on
plot(NN_Impluse_without_noise(1:length(out)),'linewidth',2)
xlabel('Time');ylabel('Amplitude');title('Impulse Response')
%% Step Response:
NN_Step_without_noise = NN_Response(net,Step_Input);
figure,
out=step(Discrete_System_Transfer);
plot(out,'linewidth',2)
hold on
plot(NN_Step_without_noise(1:length(out)),'linewidth',2)
xlabel('Time');ylabel('Amplitude');title('Step Response')
%% theta
Theta=[net([1 0 0 0 0 0 0 0]');
    net([0 1 0 0 0 0 0 0]');
    net([0 0 1 0 0 0 0 0]');
    net([0 0 0 1 0 0 0 0]');
    net([0 0 0 0 1 0 0 0]');
    net([0 0 0 0 0 1 0 0]');
    net([0 0 0 0 0 0 1 0]');
    net([0 0 0 0 0 0 0 1]');]
a_hat = [1 Theta(1) Theta(2) Theta(3) Theta(4)];
b_hat = [Theta(5) Theta(6) Theta(7) Theta(8)];
estimated_Sysem_RLS = tf(b_hat, a_hat, Delta_T)
view(net)