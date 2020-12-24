function [ psnrvalue ] = psnr( I,stego_I )
%得到图像origin和test 的PSNR
I1=I;
I2=stego_I;
E=I1-I2;
MSE=mean2(E.*E);
if MSE==0
    psnrvalue=-1;
else
    psnrvalue=10*log10(255*255/MSE);

end

