function [estimated_System_RELS,covariance_RELS] = RELS(dx,dy,N,T,N0)
epsilon=10^-8;
%step 0, estimating Theta_0 using Least Square and set P
U = Unbyp(dx(1:N0),dy(1:N0));
Theta = pinv(U'*U)*U'*dy(1:N0);
a_hat = [1 Theta(1) Theta(2) Theta(3) Theta(4)];
b_hat = [Theta(5) Theta(6) Theta(7) Theta(8)];
P = 1000*eye(9);
previous_Theta = zeros(9,1);
Theta = [Theta;0];
estimated_System = tf(b_hat, a_hat, T);
Y_est = lsim(estimated_System , dx);
err = dy - Y_est;
v_hat = err(N0);

while ((N0 < N) && (norm(previous_Theta - Theta)>epsilon))
%Step 1 & 2:
    previous_Theta = Theta;
    u_t = [-dy(N0);-dy(N0-1);-dy(N0-2);-dy(N0-3);dx(N0);dx(N0-1);dx(N0-2);dx(N0-3);v_hat]; 
%Step 3:
    P = P - (P*(u_t*u_t.')*P)/(1+u_t.'*P*u_t);
%Step 4:
    Theta = previous_Theta + P*u_t*(dy(N0 + 1) - u_t'*previous_Theta);
%Step 5:
    v_hat = dy(N0+1) - u_t'*Theta;
    N0 = N0 + 1;
% Step 6: Stay in while 
end
a_hat = [1 Theta(1) Theta(2) Theta(3) Theta(4)];
b_hat = [Theta(5) Theta(6) Theta(7) Theta(8)];
estimated_System_RELS = tf(b_hat, a_hat, T);
Y_hat = lsim(estimated_System_RELS , dx);
error = dy - Y_hat;
sigma = error' * error / (N-9);
covariance_RELS = sigma * inv(U'*U);
end

