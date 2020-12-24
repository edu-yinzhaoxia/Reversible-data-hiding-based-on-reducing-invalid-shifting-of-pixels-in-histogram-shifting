function [ complexity_I,local_complexity_I,x_posA,y_posA ] = complexityA( I )
%将每个位置的及其周边的范围的复杂度相结合得到一个局部复杂度
%函数输入：complexity_I是每个像素根据相邻像素得到的局部复杂度
%函数输出：complexity_I:相邻四个像素的复杂度
         %local_complexity_I：局部像素的复杂度
         %threshold：根据嵌入容量选出对应的复杂度值
[m,n]=size(I);
x_posA=zeros(m,n);%存放求取复杂度的像素值的横坐标位置
y_posA=zeros(m,n);%存放求取复杂度的像素值的纵坐标位置
complexity_I=zeros(m,n);
local_complexity_I=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        if mod(i+j,2)==0
            a=I(i-1,j);%a,b,c,d分别为上右下左位置的像素值
            b=I(i,j+1);
            c=I(i+1,j);
            d=I(i,j-1);
            complexity_I(i,j)=abs(a-c)+abs(b-d)+abs(a+b-c-d)+abs(b+c-a-d);%complexity_I存放I1的每个预测误差位置对应的复杂度
        end
    end
end
for i=2:m-1
    for j=2:n-1
        if mod(i+j,2)==0
            if (i>=3&&i<=510)&&(j>=3&&j<=510)
                a1=complexity_I(i-1,j-1);%左上
                b1=complexity_I(i-1,j+1);%右上
                c1=complexity_I(i+1,j-1);%左下
                d1=complexity_I(i+1,j+1);%右下
                local_complexity_I(i,j)=complexity_I(i,j)+floor((a1+b1+c1+d1)/4);
            elseif i==2&&j==2%右下
                local_complexity_I(i,j)=complexity_I(i,j)+complexity_I(i+1,j+1);
            elseif i==511&&j==511%左上
                local_complexity_I(i,j)=complexity_I(i,j)+complexity_I(i-1,j-1);
            elseif i==2&&(j>=4&&j<=510)%左下、右下
                local_complexity_I(i,j)=complexity_I(i,j)+floor((complexity_I(i+1,j-1)+complexity_I(i+1,j+1))/2);
            elseif j==2&&(i>=4&&i<=510)%右上、右下
                local_complexity_I(i,j)=complexity_I(i,j)+floor((complexity_I(i-1,j+1)+complexity_I(i+1,j+1))/2);
            elseif j==511&&(i>=3&&i<=509)%左上、左下
                local_complexity_I(i,j)=complexity_I(i,j)+floor((complexity_I(i-1,j-1)+complexity_I(i+1,j-1))/2);
            elseif i==511&&(j>=3&&j<=509)%左上、右上
                local_complexity_I(i,j)=complexity_I(i,j)+floor((complexity_I(i-1,j-1)+complexity_I(i-1,j+1))/2);
            end
            x_posA(i,j)=i;
            y_posA(i,j)=j;
        end
    end
end
end

