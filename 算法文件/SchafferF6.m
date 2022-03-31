function result=SchafferF6(x0)
%Schaffer ����
%����x,������Ӧ��yֵ,��x=(0,0,��,0) ����ȫ����С��.
[row,col]=size(x0);
if row>1
    error('����Ĳ�������');
end
x=x0(1,1);
y=x0(1,2);
temp=x^2+y^2;
result=0.5+((sin(sqrt(temp)))^2-0.5)/(1+0.001*temp)^2;