# Reversible data hiding based on reducing invalid shifting of pixels in histogram shifting

This code is the implementation of the paper "Reversible data hiding based on reducing invalid shifting of pixels in histogram shifting".

[Paper link](https://www.sciencedirect.com/science/article/abs/pii/S0165168419301859)

## Abstract

In recent years, reversible data hiding (RDH), a new research hotspot in the field of information security, has been paid more and more attention by researchers. Most of the existing RDH schemes do not fully take it into account that natural image’s texture has influence on embedding distortion. The image distortion caused by embedding data in the image’s smooth region is much smaller than that in the unsmooth region, essentially, it is because embedding additional data in the smooth region corresponds to fewer invalid shifting pixels (ISPs) in histogram shifting. Thus, we propose a RDH scheme based on the images texture to reduce invalid shifting of pixels in histogram shifting. Specifically, first, a cover image is divided into two sub-images by the checkerboard pattern, and then each sub-image’s fluctuation values are calculated. Finally, additional data can be embedded into the region of sub-images with smaller fluctuation value preferentially. The experimental results demonstrate that the proposed method has higher capacity and better stego-image quality than some existing RDH schemes.

## 摘要

近年来，可逆信息隐藏（RDH）是信息安全领域的一个新研究热点，受到了研究人员的越来越多的关注。现有的大多数RDH方案都没有完全考虑到自然图像的纹理会影响嵌入失真。将数据嵌入图像的平滑区域所导致的图像失真要比不平滑区域小得多，这主要是因为在平滑区域中嵌入其他数据对应于直方图移位中的无效移位像素（ISP）更少。因此，我们提出了一种基于图像纹理的RDH方案，以减少直方图移位中像素的无效移位。具体来说，首先，通过棋盘格图案将封面图像分为两个子图像，然后计算每个子图像的波动值。最后，可以将附加数据优先地嵌入到具有较小波动值的子图像区域中。实验结果表明，与现有的一些RDH方案相比，该方法具有更高的容量和更好的隐秘图像质量。

## How to cite our paper

```
@article{jia2019reversible,
  title={Reversible data hiding based on reducing invalid shifting of pixels in histogram shifting},
  author={Jia, Yujie and Yin, Zhaoxia and Zhang, Xinpeng and Luo, Yonglong},
  journal={Signal Processing},
  volume={163},
  pages={238--246},
  year={2019},
  publisher={Elsevier}
}
```
