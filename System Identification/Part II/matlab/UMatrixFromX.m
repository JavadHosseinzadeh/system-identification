function U = UMatrixFromX(X,M)
XX=repmat(X,[3,1]);
N = length(X);
for i=1:M
    U(:,i) = XX(N+1+1-i:2*N+1-i);
end
end

