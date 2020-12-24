function [ tha,re_A,extdataA ] = extractA( re_B,payload,Z1A,Z2A,PK1A,PK2A )
%re_A恢复后的B部分，extdataA;A部分提取的秘密信息，tha：复杂度值，用于对比嵌入时对应的值

[ ~,ex_local_complexity_IA,x_posA,y_posA] = complexityA( re_B );%计算载秘图像的A部分的复杂度
[ ~,err_IA1,~,~,~,~,~,~,~ ] = predictionA( re_B );%求载秘图像A部分的预测误差
[sequence_xpos]=zigzagA(x_posA);%对得到的坐标做zigzag扫描得到一个序列
[sequence_ypos]=zigzagA(y_posA);
[ sequence_c ] = zigzagA( ex_local_complexity_IA );%得到局部复杂度的序列
[sort_sequence_c1,a]=sort(sequence_c,'ascend');%将得到的局部复杂度序列做升序排序
[sequence_err1] = zigzagA( err_IA1 );%将载秘的预测误差扫描得到一个序列
m=length(sequence_err1);
x_pos1=sequence_xpos(a(1:m));%将横纵坐标按照复杂度的排序顺序排序
y_pos1=sequence_ypos(a(1:m));
sort_sequence_errA=sequence_err1(a(1:m));%将预测误差按照复杂度的排序顺序排序
%% 提取A部分的秘密信息
extdataA=zeros();%承载提取的秘密信息
re_A=re_B;%恢复图像
numdataa=0;
for i=1:m
    if numdataa>=floor(payload/2)
        break;
    end
    if sort_sequence_errA(i)==(max(PK1A,PK2A)+1)%按照复杂度排序后如果预测预测误差等于右边的峰值点+1.则提取秘密信息1，如果等于右边的峰值点，就提取秘密信息0
        numdataa=numdataa+1;
        extdataA(numdataa)=1;
        re_A(x_pos1(i),y_pos1(i))=re_B(x_pos1(i),y_pos1(i))-1;
    elseif sort_sequence_errA(i)==max(PK1A,PK2A)
        numdataa=numdataa+1;
        extdataA(numdataa)=0;
        re_A(x_pos1(i),y_pos1(i))=re_B(x_pos1(i),y_pos1(i));
    elseif sort_sequence_errA(i)==(min(PK1A,PK2A)-1)%按照复杂度排序后如果预测预测误差等于左边的峰值点-1.则提取秘密信息1，如果等于左边的峰值点，就提取秘密信息0
        numdataa=numdataa+1;
        extdataA(numdataa)=1;
        re_A(x_pos1(i),y_pos1(i))=re_B(x_pos1(i),y_pos1(i))+1;
    elseif sort_sequence_errA(i)==min(PK1A,PK2A)
        numdataa=numdataa+1;
        extdataA(numdataa)=0;
        re_A(x_pos1(i),y_pos1(i))=re_B(x_pos1(i),y_pos1(i));
    elseif sort_sequence_errA(i)>(max(PK1A,PK2A)+1)&&sort_sequence_errA(i)<=max(Z1A,Z2A)%预测误差在右边峰值点+2到右边零值点的像素值做左移
        re_A(x_pos1(i),y_pos1(i))=re_B(x_pos1(i),y_pos1(i))-1;
    elseif sort_sequence_errA(i)<(min(PK1A,PK2A)-1)&&sort_sequence_errA(i)>=min(Z1A,Z2A)%预测误差在左边零值点与左边峰值点-2的像素值做右移
        re_A(x_pos1(i),y_pos1(i))=re_B(x_pos1(i),y_pos1(i))+1;
    end
    j=i;
end
tha=sort_sequence_c1(j);
end
