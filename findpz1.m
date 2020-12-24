function [PK1,PK2,Z,num1]=findpz1(x) 
%找出矩阵x的峰值点PK和在峰值点左侧的零值点Z
y=tabulate(x(:));
[m,~]=size(y);
num1=max(y(:,2));
sequence=sort(y(:,2),'descend');
num2=sequence(2);
n1=find(y==num1);%find函数是寻找y矩阵中的与num1相等的位置
k1=n1-m;
PK1=y(k1,1);
n2=find(y==num2);%find函数是寻找y矩阵中的与num1相等的位置
k2=n2-m;
PK2=y(k2,1);
Z=y(1,1)-1;
for i=1:k1
    f=y(i+1,1)-y(i,1);
    if f~=1
        Z=y(i+1,1)-1;
    end
end
i =1;    