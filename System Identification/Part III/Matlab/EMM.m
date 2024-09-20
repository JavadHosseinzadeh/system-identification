function [estimated_System_EMM,covariance_EMM] = EMM(dx,dy,N,T,N0)
epsilon=10^-8;
%step 0, estimating Theta_0 using Least Square and set P
U = Unbyp(dx(1:N0),dy(1:N0));
Theta = pinv(U'*U)*U'*dy(1:N0);
a_hat = [1 Theta(1) Theta(2) Theta(3) Theta(4)];
b_hat = [Theta(5) Theta(6) Theta(7) Theta(8)];
P = 1000*eye(10);
previous_Theta = zeros(10,1);
Theta = [Theta;0;0];
estimated_System = tf(b_hat, a_hat, T);
Y_est = lsim(estimated_System , dx);
error = dy - Y_est;
e_hat = error(N0);
v_hat = 1;

while ((N0 < N) && (norm(previous_Theta - Theta)>epsilon))
%Step 1 & 2:    
    previous_Theta = Theta;
    u_t = [-dy(N0);-dy(N0-1);-dy(N0-2);-dy(N0-3);dx(N0);dx(N0-1);dx(N0-2);dx(N0-3);e_hat;v_hat];
%Step 3:
    P = P - (P*(u_t*u_t')*P)/(1+u_t'*P*u_t);
%Step 4:
    kt = (P*u_t/(1+u_t'*P*u_t));
    Theta = previous_Theta + kt*(dy(N0 + 1) - u_t'*previous_Theta);
%Step 5:
    e_hat = dy(N0+1) - u_t(1:end-2)'*Theta(1:end-2);
    v_hat = dy(N0+1) - u_t'*Theta;
    N0 = N0 + 1;
%Step 6: Stay in while
end
a_hat = [1 Theta(1) Theta(2) Theta(3) Theta(4)];
b_hat = [Theta(5) Theta(6) Theta(7) Theta(8)];
estimated_System_EMM = tf(b_hat, a_hat, T);
Y_hat = lsim(estimated_System_EMM , dx);
error = dy - Y_hat;
sigma = error' * error / (N-10);
covariance_EMM = sigma * inv(U'*U);
end

