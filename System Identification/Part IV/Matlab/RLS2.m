function [estimated_Sysem_RLS,covariance_RLS,error] = RLS4(dx,dy,N,T,N0)
epsilon=10^-8;
%step 0, estimating Theta_0 using Least Square and set P
U = Unbyp2(dx(1:N0),dy(1:N0));
Theta = pinv(U'*U)*U'*dy(1:N0);
a_hat = [1 Theta(1) Theta(2)];
b_hat = [Theta(3) Theta(4)];
P = 1000*eye(4);
previous_Theta = zeros(4,1);

while ((N0 < N)  && (norm(previous_Theta - Theta)>epsilon)) 
%Step 1 & 2: 
    previous_Theta = Theta;
    u_t = [-dy(N0);-dy(N0-1);dx(N0+1);dx(N0)]; 
%Step 3:
    kt = (P*u_t)/(1+u_t'*P*u_t);
%Step 4:
    Theta = previous_Theta + kt*(dy(N0+1) - u_t'*previous_Theta);
%Step 5:
    P = (eye(4) - kt*u_t')*P;
    N0 = N0 + 1;
    Errorr=norm(previous_Theta - Theta);
% Step 6: Stay in while 
end
a_hat = [1 Theta(1) Theta(2)];
b_hat = [Theta(3) Theta(4)];
estimated_Sysem_RLS = tf(b_hat, a_hat, T);
estimated_Sys = tf(b_hat, a_hat, T);
Y_hat = lsim(estimated_Sys , dx);
error = dy - Y_hat;
sigma = error' * error / (N-4);
covariance_RLS = sigma * inv(U'*U);
end


