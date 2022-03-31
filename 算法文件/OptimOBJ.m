function objval = OptimOBJ(x)
[row,col]=size(x);
if row ~= 2
    error('����Ĳ�������');
end
if col > 1
    error('����Ĳ�������');
end
x1=x(1,1);
x2=x(2,1);
temp=(x1)^2+(x2)^2;
objval = 0.5 + ((sin(sqrt(temp)))^2-0.5) / (1+0.001*temp)^2;
