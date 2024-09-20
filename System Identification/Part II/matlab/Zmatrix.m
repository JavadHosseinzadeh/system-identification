function Z = Zmatrix(Zs,M)
N=length(Zs);
Z=zeros(M,N);
for i=1:M
    Z(i,:)=(Zs').^(M-1);
end

