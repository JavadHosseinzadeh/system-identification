function U = Unbyp3(x,y)
thetasize=6;
N=length(x);
U=zeros(N,thetasize);
U(:,1)=[zeros(1,1);-y(1:N-1)];
U(:,2)=[zeros(2,1);-y(1:N-2)];
U(:,3)=[zeros(3,1);-y(1:N-3)];
U(:,4)=x(1:N);
U(:,5)=[zeros(1,1);x(1:N-1)];
U(:,6)=[zeros(2,1);x(1:N-2)];
end


