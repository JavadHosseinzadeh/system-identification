function [estimated_System_SA,covariance_SA,P_t] = SA(dx,dy,N,T,n0)
epsilon=10^-8;
%step 0, estimating Theta_0 using Least Square
U = Unbyp(dx(1:n0),dy(1:n0));
Theta = pinv(U'*U)*U'*dy(1:n0);
%choosing Pt
Time = 0:T:(N-1)*T;
P_t = exp(-Time/8);
previous_Theta = zeros(8,1);
i = 1;
while ((n0 < N) && (norm(previous_Theta - Theta)>epsilon))
%Step 1 & 2:
    previous_Theta = Theta;
    u_t = [-dy(n0);-dy(n0-1);-dy(n0-2);-dy(n0-3);dx(n0);dx(n0-1);dx(n0-2);dx(n0-3)];
%Step 3 & 4:
    Theta = previous_Theta + P_t(i)*u_t*(dy(n0+1) - u_t'*previous_Theta);
    n0 = n0 + 1;
    i = i + 1;
%Step 5: Stay in while
end
a_hat = [1 Theta(1) Theta(2) Theta(3) Theta(4)];
b_hat = [Theta(5) Theta(6) Theta(7) Theta(8)];
estimated_System_SA = tf(b_hat, a_hat, T);
Y_hat = lsim(estimated_System_SA , dx);
error = dy - Y_hat;
sigma_hat = error' * error / (N-8);
covariance_SA = sigma_hat * inv(U'*U);
end

