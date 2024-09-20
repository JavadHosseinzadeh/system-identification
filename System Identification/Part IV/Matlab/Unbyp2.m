function U = Unbyp2(x,y)
thetasize=4;
N=length(x);
U=zeros(N,thetasize);
U(:,1)=[zeros(1,1);-y(1:N-1)];
U(:,2)=[zeros(2,1);-y(1:N-2)];
U(:,3)=x(1:N);
U(:,4)=[zeros(1,1);x(1:N-1)];
end
