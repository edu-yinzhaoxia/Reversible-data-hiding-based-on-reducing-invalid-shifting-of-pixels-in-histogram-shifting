function [bin_LM bin_LM_len I] = LocationMap(I)
[d1 d2] = size(I);
flow_map = [];
pe= 0;
for i=2:2:d1-2
    for j=2:2:d2-2
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
        pe=I(i,j)-pre_I(i,j);
        ind = (i-1)*d2 + j;
        if I(i,j) ==255
            I(i,j) = I(i,j) - 1;
            flow_map = [flow_map 1];
            continue
        end
        if I(i,j) ==254
            I(i,j) = I(i,j) - 1;
            flow_map = [flow_map 0];
            continue
        end
        if pe<=-1 && I(i,j) ==0
            I(i,j) = I(i,j) + 1;
            flow_map = [flow_map 1];
            continue
        end
        if pe<=-1 && I(i,j) ==1
            I(i,j) = I(i,j) + 1;
            flow_map = [flow_map 0];
            continue
        end
    end
end

for i=3:2:d1-1
    for j=3:2:d2-1
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
        pe=I(i,j)-pre_I(i,j);
        ind = (i-1)*d2 + j;
        if pe>=0 && I(i,j) ==255
            I(i,j) = I(i,j) - 1;
            flow_map = [flow_map 1];
            continue
        end
        if pe>=0 && I(i,j) ==254
            I(i,j) = I(i,j) - 1;
            flow_map = [flow_map 0];
            continue
        end
        if pe<=-1 && I(i,j) ==0
            I(i,j) = I(i,j) + 1;
            flow_map = [flow_map 1];
            continue
        end
        if pe<=-1 && I(i,j) ==1
            I(i,j) = I(i,j) + 1;
            flow_map = [flow_map 0];
            continue
        end
    end
end

%without compression
bin_LM_len = length(flow_map);
bin_LM = flow_map;

%after compression
cPos_x = cell(1,1);%算术编码压缩
cPos_x{1} = flow_map;
loc_Com =  arith07(cPos_x);
bin_index = 8;
[bin_LM, bin_LM_len] = dec_transform_bin(loc_Com, bin_index);

end