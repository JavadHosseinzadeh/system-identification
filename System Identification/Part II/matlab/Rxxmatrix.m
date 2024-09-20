function Rxx = Rxxmatrix(x,M)
Rxx=zeros(M,M);
for i=1:M
    for j=1:M
        Rxx(i,j)=x(abs(i-j)+1);
    end 
end
end

