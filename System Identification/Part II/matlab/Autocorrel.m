function [Autocorrelation] = Autocorrel(x)
N=length(x);
XX=repmat(x,[1,2]);
Autocorrelation=zeros(1,N);
for k=1:N
    for i=1:N
        Autocorrelation(k)=Autocorrelation(k)+XX(i)*XX(i+k-1);
    end
    Autocorrelation(k)=(1/N)*Autocorrelation(k);
end
end

