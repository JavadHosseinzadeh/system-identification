function U = U0matirxformx(X,M)
N = length(X);
U=zeros(N,M);
XX=repmat(X,[3,1]);
for i=1:M
    for j=1:N
        if i>=j
        U(i,j) = XX(abs(j-i)+1);
        end
    end
end
end

