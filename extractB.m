function [ re_B,extdataB,thb] = extractB( stego_I2,payload,Z1B,Z2B,PK1B,PK2B )
%re_B恢复后的B部分，extdataB:B部分提取的秘密信息，thb：复杂度值，用于对比嵌入时对应的值  

[ ~,ex_local_complexity_IB,x_posB,y_posB  ] = complexityB( stego_I2 );%计算载秘图像的B部分的复杂度
[ ~,err_IB1,~,~,~,~,~,~,~ ] = predictionB( stego_I2 );%求载秘图像B部分的预测误差
[sequence_xpos]=zigzagB(x_posB);%对得到的坐标做zigzag扫描得到一个序列
[sequence_ypos]=zigzagB(y_posB);
[ sequence_c ] = zigzagB( ex_local_complexity_IB );%得到局部复杂度的序列
[sort_sequence_c1,a]=sort(sequence_c,'ascend');%将得到的局部复杂度序列做升序排序
[sequence_err1] = zigzagB( err_IB1 );%将载秘的预测误差扫描得到一个序列
m=length(sequence_err1);
x_pos1=sequence_xpos(a(1:m));%将横纵坐标按照复杂度的排序顺序排序
y_pos1=sequence_ypos(a(1:m));
sort_sequence_errB=sequence_err1(a(1:m));%将预测误差按照复杂度的排序顺序排序
extdataB=zeros();%承载提取的秘密信息
re_B=stego_I2;%恢复图像
numdatab=0;
for i=1:m
    if numdatab>=ceil(payload/2)
        break;
    end
    if sort_sequence_errB(i)==(max(PK1B,PK2B)+1)%按照复杂度排序后如果预测预测误差等于右边的峰值点+1.则提取秘密信息1，如果等于右边的峰值点，就提取秘密信息0
        numdatab=numdatab+1;
        extdataB(numdatab)=1;
        re_B(x_pos1(i),y_pos1(i))=stego_I2(x_pos1(i),y_pos1(i))-1;
    elseif sort_sequence_errB(i)==max(PK1B,PK2B)
        numdatab=numdatab+1;
        extdataB(numdatab)=0;
        re_B(x_pos1(i),y_pos1(i))=stego_I2(x_pos1(i),y_pos1(i));
    elseif sort_sequence_errB(i)==(min(PK1B,PK2B)-1)%按照复杂度排序后如果预测预测误差等于左边的峰值点-1.则提取秘密信息1，如果等于左边的峰值点，就提取秘密信息0
        numdatab=numdatab+1;
        extdataB(numdatab)=1;
        re_B(x_pos1(i),y_pos1(i))=stego_I2(x_pos1(i),y_pos1(i))+1;
    elseif sort_sequence_errB(i)==min(PK1B,PK2B)
        numdatab=numdatab+1;
        extdataB(numdatab)=0;
        re_B(x_pos1(i),y_pos1(i))=stego_I2(x_pos1(i),y_pos1(i));
    elseif sort_sequence_errB(i)>(max(PK1B,PK2B)+1)&&sort_sequence_errB(i)<=max(Z1B,Z2B)%预测误差在右边峰值点+2到右边零值点的像素值做左移
        re_B(x_pos1(i),y_pos1(i))=stego_I2(x_pos1(i),y_pos1(i))-1;
    elseif sort_sequence_errB(i)<(min(PK1B,PK2B)-1)&&sort_sequence_errB(i)>=min(Z1B,Z2B)%预测误差在左边零值点与左边峰值点-2的像素值做右移
        re_B(x_pos1(i),y_pos1(i))=stego_I2(x_pos1(i),y_pos1(i))+1;
    end
    j=i;
end
thb=sort_sequence_c1(j);
end


