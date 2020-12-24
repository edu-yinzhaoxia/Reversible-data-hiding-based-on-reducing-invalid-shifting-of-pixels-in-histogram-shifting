function[stego_I2,numdata2,emddataB,thB,sort_sequence_cB,sequence_ypos,k,l,err_IB1]=embedB(stego_I1,local_complexity_IB,Z1B,Z2B,PK1B,PK2B,err_IB,numdata1,payload,data,x_posB,y_posB)
%对B部分做秘密信息的嵌入
%函数输入：stego_I1嵌入A部分后的载秘图像,local_complexity_IB,thB,Z1B,Z2B,PK1B,PK2B,err_IB,numdata1,payload,data
[ sequence_c ] = zigzagB( local_complexity_IB );%得到局部复杂度的序列
[sequence_xpos]=zigzagB(x_posB);%对得到的坐标做zigzag扫描得到一个序列
[sequence_ypos]=zigzagB(y_posB);
[sort_sequence_cB,a]=sort(sequence_c,'ascend');%将得到的局部复杂度序列做升序排序
[sequence_err] = zigzagB( err_IB );
m=length(sequence_err);
x_pos1=sequence_xpos(a(1:m));
y_pos1=sequence_ypos(a(1:m));
sort_sequence_errB=sequence_err(a(1:m));
%% B部分嵌入秘密信息
stego_I2=stego_I1;
numdata2=numdata1;
emddataB=zeros();
err_IB1=err_IB;
l=0;
for i=1:m
    if numdata2>=payload
        break;
    end
    if sort_sequence_errB(i)==min(PK1B,PK2B)%按照复杂度排序后如果预测误差是左边的峰值点便减去秘密信息
        numdata2=numdata2+1;
        stego_I2(x_pos1(i),y_pos1(i))=stego_I1(x_pos1(i),y_pos1(i))-data(numdata2);
        err_IB1(x_pos1(i),y_pos1(i))=err_IB(x_pos1(i),y_pos1(i))-data(numdata2);
    elseif sort_sequence_errB(i)==max(PK1B,PK2B)%按照复杂度排序后如果预测误差是右边的峰值点便加上秘密信息
        numdata2=numdata2+1;
        stego_I2(x_pos1(i),y_pos1(i))=stego_I1(x_pos1(i),y_pos1(i))+data(numdata2);
        err_IB1(x_pos1(i),y_pos1(i))=err_IB(x_pos1(i),y_pos1(i))+data(numdata2);
    elseif sort_sequence_errB(i)>max(PK1B,PK2B)&&sort_sequence_errB(i)<max(Z1B,Z2B)%按照复杂度排序当预测误差在右边的峰值点和右边的零值点之间都向右平移
        stego_I2(x_pos1(i),y_pos1(i))=stego_I1(x_pos1(i),y_pos1(i))+1;
        err_IB1(x_pos1(i),y_pos1(i))=err_IB(x_pos1(i),y_pos1(i))+1;
        l=l+1;
    elseif sort_sequence_errB(i)<min(PK1B,PK2B)&&sort_sequence_errB(i)>min(Z1B,Z2B)%按照复杂度排序当预测误差在左边的峰值点和左边的零值点之间都向左平移
        stego_I2(x_pos1(i),y_pos1(i))=stego_I1(x_pos1(i),y_pos1(i))-1;
        err_IB1(x_pos1(i),y_pos1(i))=err_IB(x_pos1(i),y_pos1(i))-1;
        l=l+1;
    end
    k=i;
end
thB=sort_sequence_cB(k);
emddataB=data(numdata1+1:numdata2);
end
