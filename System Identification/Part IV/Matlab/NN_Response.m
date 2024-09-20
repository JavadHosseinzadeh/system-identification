function [NN_out] = NN_Response(net,Input)
Number_of_sample=length(Input);
NN_out=[];
NN_out(1)=net([0 0 0 0 Input(1) 0 0 0]');
NN_out(2)=net([-NN_out(1) 0 0 0 Input(2) Input(1) 0 0]');
NN_out(3)=net([-NN_out(2) -NN_out(1) 0 0 Input(3) Input(2) Input(1) 0]');
NN_out(4)=net([-NN_out(3) -NN_out(2) -NN_out(1) 0 Input(4) Input(3) Input(2) Input(1)]');
for i=5:Number_of_sample
    NN_out(i)=net([-NN_out(i-1) -NN_out(i-2) -NN_out(i-3) -NN_out(i-4) Input(i) Input(i-1) Input(i-2) Input(i-3)]');
end
end

