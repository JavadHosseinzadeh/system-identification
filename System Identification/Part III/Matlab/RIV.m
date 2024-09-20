function [estimated_Sysem_RIV,covariance_RIV] = RIV(dx,dy,N,T,N0)
epsilon=10^-8;
%step 0, estimating Theta_0 using Least Square and set P
U = Unbyp(dx(1:N0),dy(1:N0));
Theta = pinv(U'*U)*U'*dy(1:N0);
a_hat = [1 Theta(1) Theta(2) Theta(3) Theta(4)];
b_hat = [Theta(5) Theta(6) Theta(7) Theta(8)];
P = 100*eye(8);
previous_Theta = zeros(8,1);
estimated_System = tf(b_hat, a_hat, T);
Y_est = lsim(estimated_System , dx);
Y_hat = [Y_est(N0-1);Y_est(N0-2);Y_est(N0-3);Y_est(N0-4)];
previouse_Theta = zeros(8,1);

while ((N0 < N) && (norm(previouse_Theta - Theta)>epsilon))
%Step 1 & 2:
    previouse_Theta = Theta;
    u_t = [-dy(N0-1);-dy(N0-2);-dy(N0-3);-dy(N0-4);dx(N0);dx(N0-1);dx(N0-2);dx(N0-3)];
    z_t = [-Y_hat(1);-Y_hat(2);-Y_hat(3);-Y_hat(4);dx(N0);dx(N0-1);dx(N0-2);dx(N0-3)];
%Step 3:
    P = P - P*(z_t*u_t')*P/(1+u_t.'*P*z_t);
%Step 4:
    Theta = previouse_Theta + P*z_t*(dy(N0) - u_t'*previouse_Theta);
    N0 = N0 + 1;
%Step 5:
    Y_hat(4) = Y_hat(3);
    Y_hat(3) = Y_hat(2);
    Y_hat(2) = Y_hat(1);
    Y_hat(1) = u_t'*Theta;
% Step 6: Stay in while 
end
a_hat = [1 Theta(1) Theta(2) Theta(3) Theta(4)];
b_hat = [Theta(5) Theta(6) Theta(7) Theta(8)];
estimated_Sysem_RIV = tf(b_hat, a_hat, T);
Y_hat = lsim(estimated_Sysem_RIV , dx);
error = dy - Y_hat;
sigma = error' * error / (N-8);
covariance_RIV = sigma * inv(U'*U);
end

