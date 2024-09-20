function [Crosscorrelation] = Crosscorrel(x,y)
N=length(x);
XX=repmat(x,[1,2]);
YY=repmat(y,[1,2]);
Crosscorrelation=zeros(1,N);
for k=1:N
    for i=1:N
        Crosscorrelation(k)=Crosscorrelation(k)+XX(i)*YY(i+k-1);
    end
    Crosscorrelation(k)=(1/N)*Crosscorrelation(k);
end
end

