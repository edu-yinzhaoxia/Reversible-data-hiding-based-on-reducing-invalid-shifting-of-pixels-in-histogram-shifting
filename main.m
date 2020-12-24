clear%清除变量
clc%清除屏幕
%将图像的每一个像素值的复杂度做排序，从而嵌入信息
I=double(imread('lena.tiff'));
l=1;
% for i = 1:5
%     n=0.01*i;
% payload =round(n*512*512);%嵌入的载荷量
% K=zeros();
% for payload=3000:3000:36000
payload=10000;
% seed = 0; %设置种子,保证产生稳定的随机数
% rand('seed',seed); 
data = randi([0,1],1,payload); %随机生成的01比特作为秘密信息
%% 求A每个像素位置的复杂度并将复杂度做排序根据嵌入容量选出对应的复杂度值
%将每个位置的及其周边的范围的复杂度相结合得到一个局部复杂度
[ complexity_IA,local_complexity_IA,x_posA,y_posA] = complexityA( I );
%% 求A像素值的预测误差
[ pre_IA,err_IA,num_0A,num_1A,num_11A,Z1A,Z2A,PK1A,PK2A ] = predictionA( I );
%[bin_LM bin_LM_len I] = LocationMap(I);
%% 秘密数据的嵌入
[ stego_I1,numdata1,emddataA,th,x_pos1,y_pos1,j,l1,err_I1 ] = embedA(I,local_complexity_IA,data,Z1A,Z2A,PK1A,PK2A,err_IA,payload,x_posA,y_posA );
%% 求B每个像素位置的复杂度并将复杂度做排序根据嵌入容量选出对应的复杂度值
[ complexity_IB,local_complexity_IB,x_posB,y_posB  ] = complexityB( stego_I1 );
%% 求B像素值的预测误差
[ pre_IB,err_IB,num_0B,num_1B,num_11B,Z1B,Z2B,PK1B,PK2B ] = predictionB( stego_I1 );
% [bin_LM bin_LM_len I] = LocationMap_circle(stego_I1);
%% 秘密数据的嵌入
[stego_I2,numdata2,emddataB,thB,sort_sequence_cB,sequence_ypos1,k,l2,err_IB1]=embedB(stego_I1,local_complexity_IB,Z1B,Z2B,PK1B,PK2B,err_IB,numdata1,payload,data,x_posB,y_posB);
 psnr1 = psnr( I,stego_I2 );
%  PSNR(l)=psnr1;
% % %  N(i)=n;
%  l=l+1;
% end
%% 提取秘密信息（逆序提取）
%首先提取B部分的秘密信息（先计算B部分的复杂度），再提取A 部分的秘密信息
%提取B部分的秘密信息
[ re_B,extdataB,thb ] = extractB( stego_I2,payload,Z1B,Z2B,PK1B,PK2B );
ans1=isequal(emddataB,extdataB);
ans2=isequal(stego_I1,re_B);
%提取A部分的秘密信息
[ tha,re_A,extdataA ] = extractA( re_B,payload,Z1A,Z2A,PK1A,PK2A );
ans3=isequal(extdataA,emddataA);
ans4=isequal(re_A,I);
