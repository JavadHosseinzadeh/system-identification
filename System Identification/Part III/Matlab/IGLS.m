function [estimated_System_IGLS,covariance,Noise_Dynamic] = IGLS(dx,dy,N,T)
epsilon=10^-6;
%step 0, estimating Theta_0 using Least Square
U0 = Unbyp(dx,dy);
Theta = pinv(U0'*U0)*U0'*dy;
% we have to stop condition:
% one is implemented by error which is covariance
% two is convergence of estimated theta
a_hat = [1 Theta(1) Theta(2) Theta(3) Theta(4)];
b_hat = [Theta(5) Theta(6) Theta(7) Theta(8)];
previous_a_hat = rand(1,4);
prevoius_b_hat = rand(1,4);
Error = 10;
% while loop for other steps:
while ( (Error > 0.015) || (norm(a_hat-previous_a_hat)> epsilon) || (norm(b_hat-prevoius_b_hat)> epsilon))
    previous_a_hat = a_hat;
    prevoius_b_hat = b_hat;
%Step 2: estimating noise dynamic: 2 order
    error = dy - U0*Theta;
    et = zeros(N , 2);
    et(:,1) = [0 ; -error(1 : N-1 , 1)];
    et(:,2) = [0 ; 0 ; -error(1:N-2 , 1)];
    d_hat = pinv(et'*et)*et'*error;
    Noise_Dynamic = tf([1 d_hat'] , 1 , T , 'variable' , 'z^-1');
%Step 3: filtering vectors
    x_filt = lsim(Noise_Dynamic , dx);
    y_filt = lsim(Noise_Dynamic , dy);
% calculating new theta:
    U = Unbyp(x_filt,y_filt);
    Theta = pinv(U'*U)*U'*y_filt;
    a_hat = [1 Theta(1) Theta(2) Theta(3) Theta(4)];
    b_hat = [Theta(5) Theta(6) Theta(7) Theta(8)];
% Step 4: checking Updating Condition variable and check them:
    sigma_hat = error' * error / (N-8);
    covariance = sigma_hat * inv(U0'*U0);
    Error = trace(covariance)/8;
end
estimated_System_IGLS = tf(b_hat, a_hat, T);
end

