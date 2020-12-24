function [ stego_I1,numdata1,emddataA,th,x_pos1,y_pos1,j,l,err_I1 ] = embedA( I,local_complexity_I,data,Z1A,Z2A,PK1A,PK2A,err_I,payload,x_posA,y_posA )
%嵌入秘密信息
%函数输入：local_complexity_I为A部分每个像素值的局部复杂度,threshold根据嵌入容量选出对应的复杂度值,data秘密信息,Z1峰值点左边的零值点,
%Z2峰值点右边的零值点,PK1预测误差次峰值点,PK2预测误差峰值点,pre_I预测值,err_I预测误差
%函数输出：
[ sequence_c ] = zigzagA( local_complexity_I );%得到局部复杂度的序列
[sequence_xpos]=zigzagA(x_posA);%对得到的坐标做zigzag扫描得到一个序列
[sequence_ypos]=zigzagA(y_posA);
[sort_sequence_cA,a]=sort(sequence_c,'ascend');%将得到的局部复杂度序列做升序排序
[sequence_err] = zigzagA( err_I );
m=length(sequence_err);
x_pos1=sequence_xpos(a(1:m));
y_pos1=sequence_ypos(a(1:m));
sort_sequence_errA=sequence_err(a(1:m));
%% A部分嵌入秘密信息
stego_I1=I;
numdata1=0;
l=0;
err_I1=err_I;%载密预测误差
for i=1:m
    if numdata1>=floor(payload/2)
        break;
    end
    if sort_sequence_errA(i)==min(PK1A,PK2A)%按照复杂度排序后如果预测误差是左边的峰值点便减去秘密信息
         numdata1=numdata1+1;
         stego_I1(x_pos1(i),y_pos1(i))=I(x_pos1(i),y_pos1(i))-data(numdata1);
         err_I1(x_pos1(i),y_pos1(i))=err_I(x_pos1(i),y_pos1(i))-data(numdata1);
    elseif sort_sequence_errA(i)==max(PK1A,PK2A)%按照复杂度排序后如果预测误差是右边的峰值点便加上秘密信息
        numdata1=numdata1+1;
        stego_I1(x_pos1(i),y_pos1(i))=I(x_pos1(i),y_pos1(i))+data(numdata1);
        err_I1(x_pos1(i),y_pos1(i))=err_I(x_pos1(i),y_pos1(i))+data(numdata1);
    elseif sort_sequence_errA(i)<min(PK1A,PK2A)&&sort_sequence_errA(i)>min(Z1A,Z2A)%按照复杂度排序当预测误差在左边的峰值点和左边的零值点之间都向左平移
        stego_I1(x_pos1(i),y_pos1(i))=I(x_pos1(i),y_pos1(i))-1;
        err_I1(x_pos1(i),y_pos1(i))=err_I(x_pos1(i),y_pos1(i))-1;
        l=l+1;
    elseif sort_sequence_errA(i)>max(PK1A,PK2A)&&sort_sequence_errA(i)<max(Z1A,Z2A)%按照复杂度排序当预测误差在右边的峰值点和右边的零值点之间都向右平移
        stego_I1(x_pos1(i),y_pos1(i))=I(x_pos1(i),y_pos1(i))+1;
        err_I1(x_pos1(i),y_pos1(i))=err_I(x_pos1(i),y_pos1(i))-1;
        l=l+1;
    end
    j=i;
end
th=sort_sequence_cA(j);
emddataA=data(1:numdata1);
end
