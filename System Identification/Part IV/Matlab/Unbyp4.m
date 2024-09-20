function U = Unbyp4(x,y)
thetasize=8;
N=length(x);
U=zeros(N,thetasize);
U(:,1)=[zeros(1,1);-y(1:N-1)];
U(:,2)=[zeros(2,1);-y(1:N-2)];
U(:,3)=[zeros(3,1);-y(1:N-3)];
U(:,4)=[zeros(4,1);-y(1:N-4)];
U(:,5)=x(1:N);
U(:,6)=[zeros(1,1);x(1:N-1)];
U(:,7)=[zeros(2,1);x(1:N-2)];
U(:,8)=[zeros(3,1);x(1:N-3)];
end
