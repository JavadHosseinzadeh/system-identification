function D = DMatrix(y,numparam)
N= length(y);
D=zeros(N-numparam,numparam);
for i = numparam : -1 : 1
    D(:,i)=y((numparam-i+1):(N-i));
end
end

