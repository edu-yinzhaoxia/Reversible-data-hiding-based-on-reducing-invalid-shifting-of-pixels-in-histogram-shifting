function [ pre_I,err_I,num_0,num_1,num_11,Z1,Z2,PK1,PK2 ] = predictionA( I )
%计算其预测误差，首先利用菱形预测，再加上权重
%  函数输入：I为原始图像
%  函数输出：pre_I为预测值,err_I预测误差,num_0预测误差为0的个数,num_1预测误差为1的个数,num_11预测误差为-1的个数,
%  Z1峰值点左边的零值点,Z2峰值点右边的零值点,PK1为峰值点,PK2次峰值点
[m,n]=size(I);
rhombus_I=I;
pre_I=I;
err_I=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        if mod(i+j,2)==0
            a=I(i-1,j);%a,b,c,d分别为上右下左位置的像素值
            b=I(i,j+1);
            c=I(i+1,j);
            d=I(i,j-1);
            rhombus_I(i,j)=floor((a+b+c+d)/4);%菱形预测
            e1=abs(a-rhombus_I(i,j));%
            e2=abs(b-rhombus_I(i,j));
            e3=abs(c-rhombus_I(i,j));
            e4=abs(d-rhombus_I(i,j));
            sum_e=e1+e2+e3+e4;
            if sum_e==0
                pre_I(i,j)=rhombus_I(i,j);
            else
                r1=sum_e/(e1+1);
                r2=sum_e/(e2+1);
                r3=sum_e/(e3+1);
                r4=sum_e/(e4+1);
                sum_r=r1+r2+r3+r4;
                w1=r1/sum_r;
                w2=r2/sum_r;
                w3=r3/sum_r;
                w4=r4/sum_r;
                pre_I(i,j)=floor(w1*a+w2*b+w3*c+w4*d);
            end
            err_I(i,j)=I(i,j)-pre_I(i,j);
        end
    end
end
num_0=0;
num_1=0;
num_11=0;
for i=2:m-1
    for j=2:n-1
        if mod(i+j,2)==0
            if err_I(i,j)==0
                num_0=num_0+1;
            elseif err_I(i,j)==1
                num_1=num_1+1;
            elseif err_I(i,j)==-1
                num_11=num_11+1;
            end 
        end
    end
end
%画出预测误差直方图
err1=[err_I(2:+2:m-1,2:+2:n-1);err_I(3:+2:m-1,3:+2:n-1)];%取出菱形mod（i+j,2）==0的值
hist_error_I=tabulate(err1(:));%对预测误差各个像素值进行统计
[PK1,PK2,Z1,num]=findpz1(err1); %找出矩阵的峰值点PK和在峰值点左侧的零值点Z
[PK3,Z2,num]=findpz2(err1); %找出矩阵的峰值点PK和在峰值点右侧的零值点Z
% figure(1)
% bar(hist_error_I(:,1),hist_error_I(:,2),0.1);%绘制预测误差直方图，2-第二列
% title('预测误差直方图');
end

