function [estimated_System_OPA,covariance_OPA] = OPA(dx,dy,N,T,N0)
epsilon=10^-8;
%step 0, estimating Theta_0 using Least Square and set P
U = Unbyp(dx(1:N0),dy(1:N0));
Theta = pinv(U'*U)*U'*dy(1:N0);
P = eye(8);
previous_Theta = zeros(8,1);

while ((N0 < N) && (norm(previous_Theta - Theta)>epsilon))
%Step 1 & 2:
    previous_Theta = Theta;
    u_t = [-dy(N0);-dy(N0-1);-dy(N0-2);-dy(N0-3);dx(N0);dx(N0-1);dx(N0-2);dx(N0-3)]; 
%Step 3 & 4:
    if(u_t'*P*u_t == 0)
        Theta = previous_Theta;
        P=P;
    else
        Theta = previous_Theta + ((P*u_t)/(u_t'*P*u_t))*(dy(N0+1) - u_t'*previous_Theta);
        P = P - (P*(u_t*u_t')*P)/(u_t'*P*u_t);
    end
    N0 = N0 + 1
%Step 3 & 4: Stay in while
end
a_hat = [1 Theta(1) Theta(2) Theta(3) Theta(4)];
b_hat = [Theta(5) Theta(6) Theta(7) Theta(8)];
estimated_System_OPA = tf(b_hat, a_hat, T);
Y_hat = lsim(estimated_System_OPA , dx);
error = dy - Y_hat;
sigma = error' * error / (N-8);
covariance_OPA = sigma * inv(U'*U);
end

